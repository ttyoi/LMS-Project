package kr.happyjob.study.domain.instructor.controller;

import kr.happyjob.study.domain.instructor.model.ICourseVO;
import kr.happyjob.study.domain.instructor.service.ICourseService;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ICourseController {

    private final Logger logger = LogManager.getLogger(this.getClass());
    private final String className = this.getClass().toString();

    @Autowired
    private ICourseService courseService;

    private final String path = "instructor/icourse/courlist";

    @GetMapping("/inst/course-list")
    public String courseMgr(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".courseView (React)");
        logger.info("   - paramMap : " + paramMap);
        logger.info("+ End " + className + ".courseView (React)");
        return path + "/courseView";
    }

    @RequestMapping("/inst/getCourseList")
    public String courseList(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".courseList");
        logger.info("   - paramMap : " + paramMap);

        HttpSession session = request.getSession();
        String loginId = getSessionString(session, "loginId");
        String userType = getSessionString(session, "userType");

        paramMap.put("loginID", loginId);

        int currentPage = parseInt(paramMap.get("currentPage"), 1);
        int pageSize = parseInt(paramMap.get("pageSize"), 10);
        int pageIndex = (currentPage - 1) * pageSize;

        paramMap.put("pageIndex", pageIndex);
        paramMap.put("pageSize", pageSize);

        List<ICourseVO> courseList = courseService.courseList(paramMap);
        int totalCount = courseService.totalCntCourse(paramMap);

        model.addAttribute("courseListModel", courseList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("pageSize", pageSize);

        logger.info("   - loginId : " + loginId);
        logger.info("   - userType : " + userType);
        logger.info("+ End " + className + ".courseList");

        return path + "/courseList";
    }

    @PostMapping("/inst/getCourseDetail")
    @ResponseBody
    public Map<String, Object> courseDetail(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".courseDetail");
        logger.info("   - paramMap : " + paramMap);

        Map<String, Object> resultMap = new HashMap<>();

        try {
            HttpSession session = request.getSession();
            String loginId = getSessionString(session, "loginId");

            paramMap.put("loginID", loginId);
            normalizeCourseIdParam(paramMap);

            ICourseVO course = courseService.getCourseDetail(paramMap);

            resultMap.put("course", course);
            resultMap.put("result", "SUCCESS");
            resultMap.put("resultMsg", "조회 되었습니다.");
        } catch (Exception e) {
            logger.error("courseDetail error", e);
            resultMap.put("course", null);
            resultMap.put("result", "FAIL");
            resultMap.put("resultMsg", e.getMessage() == null ? "강의 상세 조회 중 오류가 발생했습니다." : e.getMessage());
        }

        logger.info("+ End " + className + ".courseDetail");
        return resultMap;
    }

    @RequestMapping("/inst/searchCourseList")
    public String getCourseList(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".getCourseList");
        logger.info("   - paramMap : " + paramMap);

        HttpSession session = request.getSession();
        String loginId = getSessionString(session, "loginId");
        String userType = getSessionString(session, "userType");

        int currentPage = parseInt(paramMap.get("currentPage"), 1);
        int pageSize = parseInt(paramMap.get("pageSize"), 10);
        int pageIndex = (currentPage - 1) * pageSize;

        paramMap.put("loginID", loginId);
        paramMap.put("userType", userType);
        paramMap.put("pageIndex", pageIndex);
        paramMap.put("pageSize", pageSize);

        List<ICourseVO> findCourseList = courseService.findCourseList(paramMap);
        int totalCount = courseService.totalCntCourse(paramMap);

        model.addAttribute("courseListModel", findCourseList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("loginID", loginId);
        model.addAttribute("userType", userType);

        logger.info("   - findCourseList : " + findCourseList);
        logger.info("+ End " + className + ".getCourseList");

        return path + "/courseList";
    }

    @PostMapping("/api/inst/getAllCourseList.json")
    @ResponseBody
    public Map<String, Object> getAllCourseListJson(@RequestParam Map<String, Object> paramMap) {
        Map<String, Object> res = new HashMap<>();

        try {
            int currentPage = parseInt(paramMap.get("currentPage"), 1);
            int pageSize = parseInt(paramMap.get("pageSize"), 999);
            int pageIndex = (currentPage - 1) * pageSize;

            paramMap.put("pageIndex", pageIndex);
            paramMap.put("pageSize", pageSize);

            List<ICourseVO> list = courseService.allCourseList(paramMap);
            int totalCount = courseService.totalCntAllCourse(paramMap);

            res.put("list", list);
            res.put("totalCount", totalCount);
            res.put("result", "SUCCESS");
            res.put("resultMsg", "SUCCESS");
        } catch (Exception e) {
            logger.error("getAllCourseListJson error", e);
            res.put("list", null);
            res.put("totalCount", 0);
            res.put("result", "FAIL");
            res.put("resultMsg", e.getMessage() == null ? "전체 강의 조회 중 오류가 발생했습니다." : e.getMessage());
        }

        return res;
    }

    @PostMapping("/api/inst/getAllCourseDetail")
    @ResponseBody
    public Map<String, Object> getAllCourseDetailJson(@RequestParam Map<String, Object> paramMap) {
        Map<String, Object> resultMap = new HashMap<>();

        try {
            normalizeCourseIdParam(paramMap);

            ICourseVO course = courseService.getAllCourseDetail(paramMap);

            resultMap.put("course", course);
            resultMap.put("result", "SUCCESS");
            resultMap.put("resultMsg", "조회 되었습니다.");
        } catch (Exception e) {
            logger.error("getAllCourseDetailJson error", e);
            resultMap.put("course", null);
            resultMap.put("result", "FAIL");
            resultMap.put("resultMsg", e.getMessage() == null ? "전체 강의 상세 조회 중 오류가 발생했습니다." : e.getMessage());
        }

        return resultMap;
    }

    @PostMapping("/api/inst/getCourseList.json")
    @ResponseBody
    public Map<String, Object> getCourseListJson(HttpServletRequest request,
                                                 @RequestParam Map<String, Object> paramMap) {
        Map<String, Object> res = new HashMap<>();

        try {
            HttpSession session = request.getSession();
            String loginId = getSessionString(session, "loginId");
            String userType = getSessionString(session, "userType");

            int currentPage = parseInt(paramMap.get("currentPage"), 1);
            int pageSize = parseInt(paramMap.get("pageSize"), 999);
            int pageIndex = (currentPage - 1) * pageSize;

            paramMap.put("loginID", loginId);
            paramMap.put("userType", userType);
            paramMap.put("pageIndex", pageIndex);
            paramMap.put("pageSize", pageSize);

            List<ICourseVO> list = courseService.courseList(paramMap);
            int totalCount = courseService.totalCntCourse(paramMap);

            res.put("list", list);
            res.put("totalCount", totalCount);
            res.put("result", "SUCCESS");
            res.put("resultMsg", "SUCCESS");
            res.put("loginID", loginId);
            res.put("userType", userType);
        } catch (Exception e) {
            logger.error("getCourseListJson error", e);
            res.put("list", null);
            res.put("totalCount", 0);
            res.put("result", "FAIL");
            res.put("resultMsg", e.getMessage() == null ? "강의 목록 조회 중 오류가 발생했습니다." : e.getMessage());
        }

        return res;
    }

    @PostMapping("/api/inst/getCourseDetail")
    @ResponseBody
    public Map<String, Object> getCourseDetailJson(HttpServletRequest request,
                                                   @RequestParam Map<String, Object> paramMap) {
        Map<String, Object> resultMap = new HashMap<>();

        try {
            HttpSession session = request.getSession();
            String loginId = getSessionString(session, "loginId");

            paramMap.put("loginID", loginId);
            normalizeCourseIdParam(paramMap);

            ICourseVO course = courseService.getCourseDetail(paramMap);

            resultMap.put("course", course);
            resultMap.put("result", "SUCCESS");
            resultMap.put("resultMsg", "조회 되었습니다.");
        } catch (Exception e) {
            logger.error("getCourseDetailJson error", e);
            resultMap.put("course", null);
            resultMap.put("result", "FAIL");
            resultMap.put("resultMsg", e.getMessage() == null ? "강의 상세 조회 중 오류가 발생했습니다." : e.getMessage());
        }

        return resultMap;
    }

    @PostMapping("/api/inst/weeklySchedule")
    @ResponseBody
    public List<ICourseVO> weeklySchedule(HttpServletRequest request,
                                          @RequestParam Map<String, Object> paramMap) {
        HttpSession session = request.getSession();
        String loginId = getSessionString(session, "loginId");
        paramMap.put("loginID", loginId);
        return courseService.weeklySchedule(paramMap);
    }

    @PostMapping("/api/inst/searchCourseList.json")
    @ResponseBody
    public Map<String, Object> searchCourseListJson(HttpServletRequest request,
                                                    @RequestParam Map<String, Object> paramMap) {
        Map<String, Object> res = new HashMap<>();

        try {
            HttpSession session = request.getSession();
            String loginId = getSessionString(session, "loginId");
            String userType = getSessionString(session, "userType");

            int currentPage = parseInt(paramMap.get("currentPage"), 1);
            int pageSize = parseInt(paramMap.get("pageSize"), 999);
            int pageIndex = (currentPage - 1) * pageSize;

            paramMap.put("loginID", loginId);
            paramMap.put("userType", userType);
            paramMap.put("pageIndex", pageIndex);
            paramMap.put("pageSize", pageSize);

            List<ICourseVO> list = courseService.findCourseList(paramMap);
            int totalCount = courseService.totalCntCourse(paramMap);

            res.put("list", list);
            res.put("totalCount", totalCount);
            res.put("result", "SUCCESS");
            res.put("resultMsg", "SUCCESS");
            res.put("loginId", loginId);
            res.put("userType", userType);
        } catch (Exception e) {
            logger.error("searchCourseListJson error", e);
            res.put("list", null);
            res.put("totalCount", 0);
            res.put("result", "FAIL");
            res.put("resultMsg", e.getMessage() == null ? "강의 검색 중 오류가 발생했습니다." : e.getMessage());
        }

        return res;
    }

    @PostMapping("/api/inst/classList")
    @ResponseBody
    public Map<String, Object> classList(@RequestParam Map<String, Object> paramMap) {
        Map<String, Object> res = new HashMap<>();

        try {
            List<ICourseVO> list = courseService.classList(paramMap);
            res.put("list", list);
            res.put("result", "SUCCESS");
            res.put("resultMsg", "SUCCESS");
        } catch (Exception e) {
            logger.error("classList error", e);
            res.put("list", null);
            res.put("result", "FAIL");
            res.put("resultMsg", e.getMessage() == null ? "강의실 목록 조회 중 오류가 발생했습니다." : e.getMessage());
        }

        return res;
    }

    @PostMapping("/api/inst/timeList")
    @ResponseBody
    public Map<String, Object> timeList(@RequestParam Map<String, Object> paramMap) {
        Map<String, Object> res = new HashMap<>();

        try {
            List<ICourseVO> list = courseService.timeList(paramMap);
            res.put("list", list);
            res.put("result", "SUCCESS");
            res.put("resultMsg", "SUCCESS");
        } catch (Exception e) {
            logger.error("timeList error", e);
            res.put("list", null);
            res.put("result", "FAIL");
            res.put("resultMsg", e.getMessage() == null ? "강의시간 목록 조회 중 오류가 발생했습니다." : e.getMessage());
        }

        return res;
    }

    // 추가: 보조강사 목록
    @PostMapping("/api/inst/subInstructorList")
    @ResponseBody
    public Map<String, Object> subInstructorList(@RequestParam Map<String, Object> paramMap) {
        Map<String, Object> res = new HashMap<>();

        try {
            List<ICourseVO> list = courseService.subInstructorList(paramMap);
            res.put("list", list);
            res.put("result", "SUCCESS");
            res.put("resultMsg", "SUCCESS");
        } catch (Exception e) {
            logger.error("subInstructorList error", e);
            res.put("list", null);
            res.put("result", "FAIL");
            res.put("resultMsg", e.getMessage() == null ? "보조강사 목록 조회 중 오류가 발생했습니다." : e.getMessage());
        }

        return res;
    }

    @PostMapping("/api/inst/courseSave")
    @ResponseBody
    public Map<String, Object> courseSave(HttpServletRequest request,
                                          @RequestParam Map<String, Object> paramMap) {
        Map<String, Object> resultMap = new HashMap<>();

        try {
            HttpSession session = request.getSession();
            String loginId = getSessionString(session, "loginId");

            paramMap.put("loginID", loginId);
            courseService.courseSave(paramMap);

            resultMap.put("result", "SUCCESS");
            resultMap.put("resultMsg", "강의가 등록되었습니다.");
        } catch (Exception e) {
            logger.error("courseSave error", e);
            resultMap.put("result", "FAIL");
            resultMap.put("resultMsg", e.getMessage() == null ? "강의 등록 중 오류가 발생했습니다." : e.getMessage());
        }

        return resultMap;
    }

    @PostMapping("/api/inst/courseUpdate")
    @ResponseBody
    public Map<String, Object> courseUpdate(HttpServletRequest request,
                                            @RequestParam Map<String, Object> paramMap) {
        Map<String, Object> resultMap = new HashMap<>();

        try {
            HttpSession session = request.getSession();
            String loginId = getSessionString(session, "loginId");

            paramMap.put("loginID", loginId);
            courseService.courseUpdate(paramMap);

            resultMap.put("result", "SUCCESS");
            resultMap.put("resultMsg", "강의가 수정되었습니다.");
        } catch (Exception e) {
            logger.error("courseUpdate error", e);
            resultMap.put("result", "FAIL");
            resultMap.put("resultMsg", e.getMessage() == null ? "강의 수정 중 오류가 발생했습니다." : e.getMessage());
        }

        return resultMap;
    }

    @PostMapping("/api/inst/courseDelete")
    @ResponseBody
    public Map<String, Object> courseDelete(HttpServletRequest request,
                                            @RequestParam Map<String, Object> paramMap) {
        Map<String, Object> resultMap = new HashMap<>();

        try {
            HttpSession session = request.getSession();
            String loginId = getSessionString(session, "loginId");

            paramMap.put("loginID", loginId);
            courseService.courseDelete(paramMap);

            resultMap.put("result", "SUCCESS");
            resultMap.put("resultMsg", "강의가 삭제되었습니다.");
        } catch (Exception e) {
            logger.error("courseDelete error", e);
            resultMap.put("result", "FAIL");
            resultMap.put("resultMsg", e.getMessage() == null ? "강의 삭제 중 오류가 발생했습니다." : e.getMessage());
        }

        return resultMap;
    }

    private void normalizeCourseIdParam(Map<String, Object> paramMap) {
        Object courseId = paramMap.get("courseId");
        Object course_id = paramMap.get("course_id");

        if ((courseId == null || "".equals(String.valueOf(courseId).trim())) && course_id != null) {
            paramMap.put("courseId", course_id);
        }

        if ((course_id == null || "".equals(String.valueOf(course_id).trim())) && courseId != null) {
            paramMap.put("course_id", courseId);
        }
    }

    private String getSessionString(HttpSession session, String key) {
        Object value = session.getAttribute(key);
        return value == null ? "" : String.valueOf(value);
    }

    private int parseInt(Object value, int defaultValue) {
        try {
            if (value == null) {
                return defaultValue;
            }
            return Integer.parseInt(String.valueOf(value));
        } catch (Exception e) {
            return defaultValue;
        }
    }
}