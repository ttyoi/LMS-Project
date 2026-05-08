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
@RequestMapping("/inst/")
public class ICourseController {
    // Set logger
    private final Logger logger = LogManager.getLogger(this.getClass());

    // Get class name for logger
    private final String className = this.getClass().toString();

    @Autowired
    private ICourseService courseService;
    private String path = "instructor/icourse/courlist";

    @GetMapping("course-list")
    public String courseMgr(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".courseView (Vue)");
        logger.info("   - paramMap : " + paramMap);
        logger.info("+ End " + className + ".courseView (Vue)");
        return path + "/courseView"; // Serve the Vue application's index.html
    }

    @RequestMapping("getCourseList")
    //@ResponseBody
    public String courseList(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".courseList");
        logger.info("   - paramMap : " + paramMap);
        HttpSession session = request.getSession();
        String loginId =  session.getAttribute("loginId").toString();
        String userType =  session.getAttribute("userType").toString();
        logger.info("   - loginId : " + loginId);
        logger.info("   - userType : " + userType);
        paramMap.put("loginID", loginId);
        int currentPage = Integer.parseInt((String)paramMap.get("currentPage"));	// 현재 페이지 번호
        int pageSize = Integer.parseInt((String)paramMap.get("pageSize"));			// 페이지 사이즈
        int pageIndex = (currentPage-1)*pageSize;												// 페이지 시작 row 번호
        logger.info("   - currentPage : " + currentPage);
        logger.info("   - pageSize : " + pageSize);
        logger.info("   - pageIndex : " + pageIndex);
        paramMap.put("pageIndex", pageIndex);
        paramMap.put("pageSize", pageSize);

        //Map<String, Object> resultMap = new HashMap<String, Object>();
        List<ICourseVO> courseList =  courseService.courseList(paramMap);
        logger.info("   - courseList : " + courseList);
        model.addAttribute("courseListModel", courseList);

        int totalCount = courseService.totalCntCourse(paramMap);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("pageSize", pageSize);
        logger.info("+ End " + className + ".courseList");
        return path+"/courseList";
    }
    @PostMapping("getCourseDetail")
    @ResponseBody
    public Map<String, Object> courseDetail(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".courseDetail");
        logger.info("   - paramMap : " + paramMap);
        HttpSession session = request.getSession();
        String loginId =  session.getAttribute("loginId").toString();
        String userType =  session.getAttribute("userType").toString();

        paramMap.put("loginID", loginId);

        ICourseVO course = courseService.getCourseDetail(paramMap);
        logger.info(" - course : " + course);
        Map<String, Object> resultMap = new HashMap<String, Object>();
        String result = "SUCCESS";
        String resultMsg = "조회 되었습니다.";

        resultMap.put("course", course);
        resultMap.put("result", result);
        resultMap.put("resultMsg", resultMsg);
        logger.info("+ End " + className + ".courseDetail");
        return resultMap;
    }
    @RequestMapping("searchCourseList")
    public String getCourseList (Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".getCourseList");
        logger.info("   - paramMap : " + paramMap);
        HttpSession session = request.getSession();
        String loginId =  session.getAttribute("loginId").toString();
        String userType =  session.getAttribute("userType").toString();

        int currentPage = Integer.parseInt((String)paramMap.get("currentPage"));	// 현재 페이지 번호
        int pageSize = Integer.parseInt((String)paramMap.get("pageSize"));			// 페이지 사이즈
        int pageIndex = (currentPage-1)*pageSize;												// 페이지 시작 row 번호

        paramMap.put("loginID", loginId);
        paramMap.put("userType", userType);
        paramMap.put("pageIndex", pageIndex);
        paramMap.put("pageSize", pageSize);

        List<ICourseVO> findCourseList =  courseService.findCourseList(paramMap);
        logger.info("   - findCourseList : " + findCourseList);
        int totalCount = courseService.totalCntCourse(paramMap);

        Map<String, Object> resultMap = new HashMap<>();
        model.addAttribute("courseListModel", findCourseList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("loginID", loginId);
        model.addAttribute("userType", userType);
        logger.info("+ End " + className + ".getCourseList");
        return path+"/courseList";
    }

    @PostMapping("getCourseList.json")
    @ResponseBody
    public Map<String, Object> getCourseListJson(HttpServletRequest request,
                                                 @RequestParam Map<String, Object> paramMap) {
        HttpSession session = request.getSession();
        String loginId = session.getAttribute("loginId").toString();
        String userType = session.getAttribute("userType").toString();

        int currentPage = Integer.parseInt((String) paramMap.get("currentPage"));
        int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
        int pageIndex = (currentPage - 1) * pageSize;

        paramMap.put("loginID", loginId);
        paramMap.put("userType", userType);
        paramMap.put("pageIndex", pageIndex);
        paramMap.put("pageSize", pageSize);

        List<ICourseVO> list = courseService.courseList(paramMap);
        int totalCount = courseService.totalCntCourse(paramMap);

        Map<String, Object> res = new HashMap<>();
        res.put("list", list);
        res.put("totalCount", totalCount);
        res.put("resultMsg", "SUCCESS");
        res.put("loginID", loginId);
        res.put("userType", userType);
        return res;
    }

    @PostMapping("weeklySchedule")
    @ResponseBody
    public List<ICourseVO> weeklySchedule(HttpServletRequest request,
                                          @RequestParam Map<String, Object> paramMap) {
        HttpSession session = request.getSession();
        String loginId = session.getAttribute("loginId").toString();
        paramMap.put("loginID", loginId);
        return courseService.weeklySchedule(paramMap);
    }

    @PostMapping("searchCourseList.json")
    @ResponseBody
    public Map<String, Object> searchCourseListJson(HttpServletRequest request,
                                                    @RequestParam Map<String, Object> paramMap) {
        HttpSession session = request.getSession();
        String loginId = session.getAttribute("loginId").toString();
        String userType = session.getAttribute("userType").toString();

        int currentPage = Integer.parseInt((String) paramMap.get("currentPage"));
        int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
        int pageIndex = (currentPage - 1) * pageSize;

        paramMap.put("loginID", loginId);
        paramMap.put("userType", userType);
        paramMap.put("pageIndex", pageIndex);
        paramMap.put("pageSize", pageSize);

        List<ICourseVO> list = courseService.findCourseList(paramMap);

        // ※ 검색 totalCount가 별도 쿼리라면 그걸 쓰는 게 정석이지만,
        // 현재 기존 코드도 totalCntCourse를 쓰고 있으니 일단 동일하게 둡니다.
        int totalCount = courseService.totalCntCourse(paramMap);

        Map<String, Object> res = new HashMap<>();
        res.put("list", list);
        res.put("totalCount", totalCount);
        res.put("resultMsg", "SUCCESS");
        res.put("loginId", loginId);
        res.put("userType",  userType);
        return res;
    }
    
}
