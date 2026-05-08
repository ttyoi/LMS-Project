package kr.happyjob.study.domain.common.controller;

import kr.happyjob.study.domain.instructor.service.IMypageService;
import kr.happyjob.study.domain.student.service.SMypageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@Controller
public class MypageApiController {

    @Autowired
    private SMypageService studentMypageService;

    @Autowired
    private IMypageService instructorMypageService;

    @ResponseBody
    @GetMapping("/api/stu/my-page/course-status")
    public Map<String, Object> getStudentCourseStatus(HttpSession session) {
        String loginId = (String) session.getAttribute("loginId");

        if (loginId == null || loginId.trim().isEmpty()) {
            return createFailResponse();
        }

        Map<String, Object> response = studentMypageService.getStudentCourseStatusPageData(loginId);
        response.put("result", "SUCCESS");
        return response;
    }

    @ResponseBody
    @GetMapping("/api/inst/my-page/course-status")
    public Map<String, Object> getInstructorCourseStatus(HttpSession session) {
        String loginId = (String) session.getAttribute("loginId");

        if (loginId == null || loginId.trim().isEmpty()) {
            return createFailResponse();
        }

        Map<String, Object> response = instructorMypageService.getInstructorCourseStatusPageData(loginId);
        response.put("result", "SUCCESS");
        return response;
    }

    private Map<String, Object> createFailResponse() {
        Map<String, Object> summary = new HashMap<>();
        summary.put("totalCount", 0);
        summary.put("inProgressCount", 0);
        summary.put("scheduledCount", 0);
        summary.put("completedCount", 0);

        Map<String, Object> response = new HashMap<>();
        response.put("result", "FAIL");
        response.put("msg", "로그인이 필요합니다.");
        response.put("summary", summary);
        response.put("courses", Collections.emptyList());
        return response;
    }
}
