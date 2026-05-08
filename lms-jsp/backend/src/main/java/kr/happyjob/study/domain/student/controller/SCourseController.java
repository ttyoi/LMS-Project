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

    // =========================================================
    // ✅ searchKey 정규화(React/JSP API 모두 안전하게 호환)
    // - React에서 사용: professor, className
    // - SQL/Mapper에서 사용(보통): name, class_name
    // =========================================================
    private void normalizeSearchKey(SSearchParamsDTO dto) {
        if (dto == null) return;

        String key = dto.getSearchKey();
        if (key == null) return;

        key = key.trim();
        if (key.isEmpty()) return;

        // 대소문자/표기 흔들림 방어
        String lower = key.toLowerCase();

        if ("professor".equals(lower)) {
            dto.setSearchKey("name");
            return;
        }

        // className / classname 둘 다 방어
        if ("classname".equals(lower) || "className".equals(key)) {
            dto.setSearchKey("class_name");
            return;
        }

        // 나머지(all, title 등)는 그대로 사용
        dto.setSearchKey(key);
    }

    // =========================================================
    // ✅ 기존 JSP 화면 진입(유지)
    // =========================================================
    @RequestMapping("/stu/courses")
    public String courses() {
        return "student/scourse/courses";
    }

    // =========================================================
    // ✅ 기존 JSP Ajax 연동 API (유지)
    // =========================================================

    @ResponseBody
    @RequestMapping("/stu/courses/totalCount")
    public Map<String, Object> courseTotalCount(SSearchParamsDTO searchParamsDTO) {

        logger.info("courseTotalCount start");

        // ✅ 추가: searchKey 정규화
        normalizeSearchKey(searchParamsDTO);

        logger.info("searchParamsDTO=" + searchParamsDTO);

        Map<String, Object> result = new HashMap<>();
        int totalCnt = scourseService.courseTotalCnt(searchParamsDTO);

        logger.info("totalCnt=" + totalCnt);

        result.put("totalCnt", totalCnt);
        return result;
    }

    /**
     * 강의목록 조회
     */
    @ResponseBody
    @RequestMapping("/stu/courses/loadAllCourse")
    public List<SCourseListDTO> loadAllCourses(SSearchParamsDTO searchParamsDTO) {

        logger.info("loadAllCourses start");

        // ✅ 추가: searchKey 정규화
        normalizeSearchKey(searchParamsDTO);

        logger.info("searchParamsDTO=" + searchParamsDTO);

        searchParamsDTO.setStart((searchParamsDTO.getCurrentPage() - 1) * searchParamsDTO.getPageSize());
        searchParamsDTO.setEnd(searchParamsDTO.getPageSize());

        List<SCourseListDTO> courseList = scourseService.loadAllCourses(searchParamsDTO);

        logger.info("courseList size=" + (courseList == null ? 0 : courseList.size()));
        return courseList;
    }

    /**
     * 강의 상세조회
     */
    @ResponseBody
    @RequestMapping("/stu/courses/courseDetail")
    public SCourseDetailDTO courseDetail(@RequestParam("course_id") int course_id,
                                         @RequestParam(value = "loginID", required = false) String loginID) {

        SCourseDetailDTO dto = scourseService.courseDetail(course_id, loginID);
        logger.info("courseDetail course_id=" + course_id + ", loginID=" + loginID + ", dto=" + dto);

        return dto;
    }

    /**
     * 수강신청/취소 메서드
     * apply_status : "apply" or "delete"
     */
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
            logger.info("postCourse apply_status=" + apply_status + ", course_id=" + course_id + ", loginID=" + loginID);

            String msg = scourseService.postCourse(apply_status, course_id, loginID);

            result.put("status", "200");
            result.put("msg", msg);

        } catch (Exception e) {
            logger.info("postCourse error=" + e.getMessage());
            result.put("status", "500");
            result.put("msg", e.getMessage());
        }

        return result;
    }

    // =========================================================
    // ✅ React 전용 API 추가 (기존 JSP 연동 유지하면서 "추가"만)
    // =========================================================

    /**
     * React용: 목록 + totalCount 한번에 반환
     * GET /stu/api/courses?page=1&pageSize=10&searchKey=...&searchWord=...&loginID=...
     */
    @ResponseBody
    @GetMapping("/stu/api/courses")
    public Map<String, Object> getCoursesForReact(
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "pageSize", defaultValue = "10") int pageSize,
            @RequestParam(name = "searchKey", required = false) String searchKey,
            @RequestParam(name = "searchWord", required = false) String searchWord,
            @RequestParam(name = "loginID", required = false) String loginID
    ) {
        logger.info("getCoursesForReact page=" + page + ", pageSize=" + pageSize
                + ", searchKey=" + searchKey + ", searchWord=" + searchWord + ", loginID=" + loginID);

        // 기존 DTO 활용
        SSearchParamsDTO dto = new SSearchParamsDTO();
        dto.setCurrentPage(page);
        dto.setPageSize(pageSize);
        dto.setSearchKey(searchKey);
        dto.setSearchWord(searchWord);
        dto.setLoginID(loginID);

        // ✅ 추가: searchKey 정규화(React에서 professor/className 보내도 처리되게)
        normalizeSearchKey(dto);

        // 기존 로직과 동일하게 start/end 계산
        dto.setStart((dto.getCurrentPage() - 1) * dto.getPageSize());
        dto.setEnd(dto.getPageSize());

        int totalCnt = scourseService.courseTotalCnt(dto);
        List<SCourseListDTO> items = scourseService.loadAllCourses(dto);

        Map<String, Object> result = new HashMap<>();
        result.put("totalCount", totalCnt);
        result.put("items", items);

        return result;
    }

    /**
     * React용: 상세 조회
     * GET /stu/api/courses/{courseId}?loginID=...
     */
    @ResponseBody
    @GetMapping("/stu/api/courses/{courseId}")
    public SCourseDetailDTO getCourseDetailForReact(
            @PathVariable("courseId") int courseId,
            @RequestParam(name = "loginID", required = false) String loginID
    ) {
        logger.info("getCourseDetailForReact courseId=" + courseId + ", loginID=" + loginID);
        return scourseService.courseDetail(courseId, loginID);
    }

    /**
     * React용: 신청/취소 액션
     * POST /stu/api/courses/{courseId}/action
     * body: {"action":"apply","loginID":"..." } or {"action":"delete","loginID":"..."}
     */
    @ResponseBody
    @PostMapping("/stu/api/courses/{courseId}/action")
    public Map<String, Object> courseActionForReact(
            @PathVariable("courseId") Long courseId,
            @RequestBody Map<String, Object> body
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            String action = body.get("action") == null ? null : String.valueOf(body.get("action"));
            String loginID = body.get("loginID") == null ? null : String.valueOf(body.get("loginID"));

            logger.info("courseActionForReact action=" + action + ", courseId=" + courseId + ", loginID=" + loginID);

            String msg = scourseService.postCourse(action, courseId, loginID);

            result.put("status", "200");
            result.put("msg", msg);

        } catch (Exception e) {
            logger.info("courseActionForReact error=" + e.getMessage());
            result.put("status", "500");
            result.put("msg", e.getMessage());
        }

        return result;
    }

    // =========================================================
    // ✅ 나의 수강목록 영역 (기존 유지)
    // =========================================================

    @RequestMapping("/stu/my-courses")
    public String myCourses() {
        return "student/scourse/my-courses";
    }

    @ResponseBody
    @RequestMapping("/stu/my-courses/totalCount")
    public Map<String, Object> myCourseTotalCount(SSearchParamsDTO searchParamsDTO) {

        Map<String, Object> result = new HashMap<>();

        logger.info("myCourseTotalCount start");
        logger.info("searchParamsDTO=" + searchParamsDTO);

        int totalCnt = scourseService.myCourseTotalcount(searchParamsDTO);

        logger.info("totalCnt=" + totalCnt);

        result.put("totalCnt", totalCnt);
        return result;
    }

    /**
     * 나의 수강목록 조회
     */
    @ResponseBody
    @RequestMapping("/stu/my-courses/loadMyCourse")
    public List<SMyCourseListDTO> loadMyCourses(SSearchParamsDTO searchParamsDTO) {

        logger.info("loadMyCourses searchParamsDTO=" + searchParamsDTO);

        searchParamsDTO.setStart((searchParamsDTO.getCurrentPage() - 1) * searchParamsDTO.getPageSize());
        searchParamsDTO.setEnd(searchParamsDTO.getPageSize());

        List<SMyCourseListDTO> myCourseList = scourseService.myCourseList(searchParamsDTO);

        logger.info("myCourseList size=" + (myCourseList == null ? 0 : myCourseList.size()));

        return myCourseList;
    }

    /**
     * 수강 상세보기
     */
    @ResponseBody
    @RequestMapping("/stu/my-courses/myCourseDetail")
    public SMyCosDetailDTO myCourseDetail(@RequestParam("loginID") String loginID,
                                          @RequestParam("course_id") int course_id) {

        logger.info("myCourseDetail loginID=" + loginID + ", course_id=" + course_id);

        SMyCosDetailDTO dto = scourseService.myCourseDetail(loginID, course_id);
        logger.info("myCourseDetail dto=" + dto);

        return dto;
    }

    /**
     * 나의 강의 출결 달력 (월별 att_sta_code 목록)
     * GET /stu/my-courses/myCourseAttCalendar?loginID=&course_id=&year=&month=
     */
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

    /**
     * 검색 조건설정
     */
    @ResponseBody
    @RequestMapping("/stu/courses/loadSearchKeys")
    public List<SSearchKeyDTO> loadSearchKeys(@RequestParam("group_code") String group_code) {
        return scourseService.loadSearchKeys(group_code);
    }
}
