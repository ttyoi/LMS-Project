package kr.happyjob.study.domain.student.controller;

import kr.happyjob.study.domain.student.model.*;
import kr.happyjob.study.domain.student.service.SCourseService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class SCourseController {

    Logger logger = LoggerFactory.getLogger(SCourseController.class);

    @Autowired
    SCourseService scourseService;

    private void normalizeSearchKey(SSearchParamsDTO dto) {
        if (dto == null) return;

        String key = dto.getSearchKey();
        if (key == null) return;

        key = key.trim();
        if (key.isEmpty()) return;

        String lower = key.toLowerCase();

        if ("professor".equals(lower)) {
            dto.setSearchKey("name");
            return;
        }

        if ("classname".equals(lower) || "className".equals(key)) {
            dto.setSearchKey("class_name");
            return;
        }

        dto.setSearchKey(key);
    }

    // =========================
    // JSP / 기존 유지
    // =========================

    @RequestMapping("/stu/courses")
    public String courses() {
        return "student/scourse/courses";
    }

    @ResponseBody
    @RequestMapping("/stu/courses/totalCount")
    public Map<String, Object> courseTotalCount(SSearchParamsDTO searchParamsDTO) {
        logger.info("courseTotalCount start");
        normalizeSearchKey(searchParamsDTO);

        Map<String, Object> result = new HashMap<>();
        int totalCnt = scourseService.courseTotalCnt(searchParamsDTO);
        result.put("totalCnt", totalCnt);
        return result;
    }

    @ResponseBody
    @RequestMapping("/stu/courses/loadAllCourse")
    public List<SCourseListDTO> loadAllCourses(SSearchParamsDTO searchParamsDTO) {
        logger.info("loadAllCourses start");
        normalizeSearchKey(searchParamsDTO);

        searchParamsDTO.setStart((searchParamsDTO.getCurrentPage() - 1) * searchParamsDTO.getPageSize());
        searchParamsDTO.setEnd(searchParamsDTO.getPageSize());

        return scourseService.loadAllCourses(searchParamsDTO);
    }

    @ResponseBody
    @RequestMapping("/stu/courses/courseDetail")
    public SCourseDetailDTO courseDetail(@RequestParam("course_id") int course_id,
                                         @RequestParam(value = "loginID", required = false) String loginID) {
        return scourseService.courseDetail(course_id, loginID);
    }

    @ResponseBody
    @RequestMapping("/stu/courses/postCourse")
    public Map<String, Object> postCourse(@RequestParam("apply_status") String apply_status,
                                          @RequestParam("course_id") Long course_id,
                                          @RequestParam(value = "loginID", required = false) String loginID,
                                          HttpSession session) {

        Map<String, Object> result = new HashMap<>();

        if (loginID == null || loginID.trim().isEmpty()) {
            Object sid = session.getAttribute("loginID");
            if (sid != null) {
                loginID = String.valueOf(sid);
            }
        }

        if (loginID == null || loginID.trim().isEmpty()) {
            result.put("status", "401");
            result.put("msg", "로그인이 필요합니다");
            return result;
        }

        try {
            String msg = scourseService.postCourse(apply_status, course_id, loginID);
            result.put("status", "200");
            result.put("msg", msg);
        } catch (Exception e) {
            result.put("status", "500");
            result.put("msg", e.getMessage());
        }

        return result;
    }

    @RequestMapping("/stu/my-courses")
    public String myCourses() {
        return "student/scourse/my-courses";
    }

    @ResponseBody
    @RequestMapping("/stu/my-courses/totalCount")
    public Map<String, Object> myCourseTotalCount(SSearchParamsDTO searchParamsDTO) {
        Map<String, Object> result = new HashMap<>();
        int totalCnt = scourseService.myCourseTotalcount(searchParamsDTO);
        result.put("totalCnt", totalCnt);
        return result;
    }

    @ResponseBody
    @RequestMapping("/stu/my-courses/loadMyCourse")
    public List<SMyCourseListDTO> loadMyCourses(SSearchParamsDTO searchParamsDTO) {
        searchParamsDTO.setStart((searchParamsDTO.getCurrentPage() - 1) * searchParamsDTO.getPageSize());
        searchParamsDTO.setEnd(searchParamsDTO.getPageSize());
        return scourseService.myCourseList(searchParamsDTO);
    }

    @ResponseBody
    @RequestMapping("/stu/my-courses/myCourseDetail")
    public SMyCosDetailDTO myCourseDetail(@RequestParam("loginID") String loginID,
                                          @RequestParam("course_id") int course_id) {
        return scourseService.myCourseDetail(loginID, course_id);
    }

    @ResponseBody
    @GetMapping("/stu/my-courses/myCourseAttCalendar")
    public List<Map<String, Object>> myCourseAttCalendar(
            @RequestParam("loginID") String loginID,
            @RequestParam("course_id") int course_id,
            @RequestParam("year") int year,
            @RequestParam("month") int month) {
        Map<String, Object> params = new HashMap<>();
        params.put("loginID", loginID);
        params.put("course_id", course_id);
        params.put("year", year);
        params.put("month", month);
        return scourseService.myCourseAttCalendar(params);
    }

    @ResponseBody
    @RequestMapping("/stu/courses/loadSearchKeys")
    public List<SSearchKeyDTO> loadSearchKeys(@RequestParam("group_code") String group_code) {
        return scourseService.loadSearchKeys(group_code);
    }

    // =========================
    // React / API 용
    // =========================

    @ResponseBody
    @GetMapping("/api/stu/courses")
    public Map<String, Object> getCoursesForReact(
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "pageSize", defaultValue = "10") int pageSize,
            @RequestParam(name = "searchKey", required = false) String searchKey,
            @RequestParam(name = "searchWord", required = false) String searchWord,
            @RequestParam(name = "startDate", required = false) String startDate,
            @RequestParam(name = "endDate", required = false) String endDate,
            @RequestParam(name = "loginID", required = false) String loginID
    ) {
        SSearchParamsDTO dto = new SSearchParamsDTO();
        dto.setCurrentPage(page);
        dto.setPageSize(pageSize);
        dto.setSearchKey(searchKey);
        dto.setSearchWord(searchWord);
        dto.setStartDate(startDate);
        dto.setEndDate(endDate);
        dto.setLoginID(loginID);

        normalizeSearchKey(dto);

        dto.setStart((dto.getCurrentPage() - 1) * dto.getPageSize());
        dto.setEnd(dto.getPageSize());

        int totalCnt = scourseService.courseTotalCnt(dto);
        List<SCourseListDTO> items = scourseService.loadAllCourses(dto);

        Map<String, Object> result = new HashMap<>();
        result.put("totalCount", totalCnt);
        result.put("items", items);

        return result;
    }

    @ResponseBody
    @GetMapping("/api/stu/courses/{courseId}")
    public SCourseDetailDTO getCourseDetailForReact(
            @PathVariable("courseId") int courseId,
            @RequestParam(name = "loginID", required = false) String loginID
    ) {
        logger.info("getCourseDetailForReact courseId=" + courseId + ", loginID=" + loginID);
        return scourseService.courseDetail(courseId, loginID);
    }

    @ResponseBody
    @PostMapping("/api/stu/courses/{courseId}/action")
    public Map<String, Object> courseActionForReact(
            @PathVariable("courseId") Long courseId,
            @RequestParam("action") String action,
            @RequestParam(value = "loginID", required = false) String loginID,
            HttpSession session
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            if (loginID == null || loginID.trim().isEmpty()) {
                Object sid = session.getAttribute("loginID");
                if (sid != null) {
                    loginID = String.valueOf(sid);
                }
            }

            if (loginID == null || loginID.trim().isEmpty()) {
                result.put("status", "401");
                result.put("msg", "로그인이 필요합니다");
                return result;
            }

            String msg = scourseService.postCourse(action, courseId, loginID);

            result.put("status", "200");
            result.put("msg", msg);
        } catch (Exception e) {
            result.put("status", "500");
            result.put("msg", e.getMessage());
        }

        return result;
    }

    @ResponseBody
    @GetMapping("/api/stu/my-courses/loadMyCourse")
    public List<SMyCourseListDTO> loadMyCoursesForReact(SSearchParamsDTO searchParamsDTO) {
        logger.info("loadMyCoursesForReact searchParamsDTO=" + searchParamsDTO);

        searchParamsDTO.setStart((searchParamsDTO.getCurrentPage() - 1) * searchParamsDTO.getPageSize());
        searchParamsDTO.setEnd(searchParamsDTO.getPageSize());

        return scourseService.myCourseList(searchParamsDTO);
    }

    @ResponseBody
    @GetMapping("/api/stu/my-courses/myCourseDetail")
    public SMyCosDetailDTO myCourseDetailForReact(@RequestParam("loginID") String loginID,
                                                  @RequestParam("course_id") int course_id) {
        logger.info("myCourseDetailForReact loginID=" + loginID + ", course_id=" + course_id);
        return scourseService.myCourseDetail(loginID, course_id);
    }

    @ResponseBody
    @GetMapping("/api/stu/my-courses/myCourseAttCalendar")
    public List<Map<String, Object>> myCourseAttCalendarForReact(
            @RequestParam("loginID") String loginID,
            @RequestParam("course_id") int course_id,
            @RequestParam("year") int year,
            @RequestParam("month") int month) {
        Map<String, Object> params = new HashMap<>();
        params.put("loginID", loginID);
        params.put("course_id", course_id);
        params.put("year", year);
        params.put("month", month);
        return scourseService.myCourseAttCalendar(params);
    }
}