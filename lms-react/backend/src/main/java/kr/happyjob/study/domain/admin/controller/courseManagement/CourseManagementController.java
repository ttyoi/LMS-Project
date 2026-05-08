package kr.happyjob.study.domain.admin.controller.courseManagement;

import kr.happyjob.study.domain.admin.dao.courseManagement.CourseManagementDAO;
import kr.happyjob.study.domain.admin.model.courseManagement.CourseManagement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
//@RequestMapping("/admin/courseManagement")
@RequestMapping("api/admin/courseManagement")
public class CourseManagementController {

    Logger logger = LoggerFactory.getLogger(this.getClass());
    @Autowired
    private CourseManagementDAO courseManagementDAO;

    /**
     * 강의 목록 조회
     */
    @GetMapping("/list")
    @ResponseBody
    public List<CourseManagement> list() {

        List<CourseManagement> list = courseManagementDAO.selectCourseList();
        for  (CourseManagement courseManagement : list) {
            logger.info(" 뭐라고 나오지???????????????????????????"+courseManagement.toString());
        }
        return list;
    }
    


    /**
     * 강의 목록 페이징 조회
     */
    @GetMapping("/list/paging")
    @ResponseBody
    public Map<String, Object> listPaging(
            @RequestParam Map<String, Object> paramMap
    ) {
        // 1. 페이징 계산 (문자열로 넘어오므로 파싱 필요)
        int page = Integer.parseInt(String.valueOf(paramMap.getOrDefault("page", "1")));
        int pageSize = Integer.parseInt(String.valueOf(paramMap.getOrDefault("pageSize", "10")));
        int offset = (page - 1) * pageSize;

        // 2. 파라미터 추가
        paramMap.put("offset", offset);
        paramMap.put("pageSize", pageSize);

        // 3. DAO 호출 (이제 Map 하나만 넘깁니다)
        List<CourseManagement> list = courseManagementDAO.selectCourseListPaging(paramMap);
        int totalCount = courseManagementDAO.countCourses(paramMap);

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("totalCount", totalCount);
        result.put("page", page);
        result.put("pageSize", pageSize);

        return result;
    }


    /**
     * 강의 상세 조회
     */
    @GetMapping("/detail/{courseId}")
    @ResponseBody
    public CourseManagement detail(@PathVariable("courseId") int courseId) {



        return courseManagementDAO.selectCourseDetail(courseId);
    }


    /**
     * 강의 수정
     */
    @PutMapping("/update")
    @ResponseBody
    public Map<String, Object> update(@RequestBody CourseManagement course) {
        Map<String, Object> result = new java.util.HashMap<>();
        try {
            courseManagementDAO.updateCourse(course);
            result.put("success", true);
            result.put("message", "강의가 수정되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "강의 수정에 실패했습니다.");
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 강의 삭제
     */
    @DeleteMapping("/delete")
    @ResponseBody
    public Map<String, Object> delete(@RequestParam("course_id") int courseId) {
        Map<String, Object> result = new java.util.HashMap<>();
        try {
            courseManagementDAO.deleteCourse(courseId);
            result.put("success", true);
            result.put("message", "강의가 삭제되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "강의 삭제에 실패했습니다.");
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 강의 승인 (요청상태 변경: 요청중 → 수락)
     */
    @PostMapping("/approve")
    @ResponseBody
    public Map<String, Object> approveCourse(@RequestParam("course_id") int courseId) {
        Map<String, Object> result = new java.util.HashMap<>();
        try {
            courseManagementDAO.updateCourseStatus(courseId, "1"); // 1 = 승인(강의중)
            result.put("success", true);
            result.put("message", "강의가 승인되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "강의 승인에 실패했습니다.");
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 강의 거절 (요청상태 변경: 요청중 → 거절)
     */
    @PostMapping("/reject")
    @ResponseBody
    public Map<String, Object> rejectCourse(@RequestParam("course_id") int courseId) {
        Map<String, Object> result = new java.util.HashMap<>();
        try {
            courseManagementDAO.updateCourseStatus(courseId, "-1"); // -1 = 거절
            result.put("success", true);
            result.put("message", "강의가 거절되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "강의 거절에 실패했습니다.");
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 강의신청 취소 (요청상태 변경: 수락 → 요청중)
     */
    @PostMapping("/cancel")
    @ResponseBody
    public Map<String, Object> cancelCourse(@RequestParam("course_id") int courseId) {
        Map<String, Object> result = new java.util.HashMap<>();
        try {
            courseManagementDAO.updateCourseStatus(courseId, "0"); // 0 = 요청중
            result.put("success", true);
            result.put("message", "강의신청이 취소되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "강의신청 취소에 실패했습니다.");
            e.printStackTrace();
        }
        return result;
    }

    @GetMapping("")
    public String view() {
        return "admin/course/courseManagement";
    }

    // CourseManagementController.java 수정 제안
    @PutMapping("/updateStatus")
    @ResponseBody
    public Map<String, Object> updateStatus(@RequestParam("course_id") int courseId,
                                            @RequestParam("status") String status) {
    	System.out.println("************************************************");
        Map<String, Object> result = new HashMap<>();
        try {
            // XML의 변수명과 일치하게 DAO 호출
            courseManagementDAO.updateCourseStatus(courseId, status);

            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            e.printStackTrace();
        }
        return result;
    }

}
