package kr.happyjob.study.domain.student.controller;
import kr.happyjob.study.domain.student.model.SHomeworkVO;
import kr.happyjob.study.domain.student.service.SHomeworkService;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.util.Collections;
import java.util.List;


@Log4j
@Controller
@RequestMapping("/stu")
public class SHomeworkController {

    @Autowired
    SHomeworkService homeworkService;

    @GetMapping("/assignments")
    public String assignments(Model model) {
        return "student/assignments";
    }


    @ResponseBody
    @GetMapping(value = { "/homeworklist", "/homeworklist.do" })
    public List<SHomeworkVO> homeworkList(
            @RequestParam(value = "loginId", required = false) String loginIdParam,
            HttpSession session) {

        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null || loginId.isEmpty()) {
            loginId = loginIdParam;
        }

        if (loginId == null || loginId.isEmpty()) {
            return Collections.emptyList();
        }

        return homeworkService.getStudentHomeworkList(loginId);
    }

    @GetMapping("/assignmentSubmit")
    public String assignmentSubmit(
            @RequestParam(required = false) Integer homework_code,
            @RequestParam(required = false) Integer submission_code,
            HttpSession session,
            Model model
    ) {

        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) return "redirect:/login";

        SHomeworkVO detail = null;

        if (submission_code != null) {
            // 수정 모드 → 제출했던 내용 조회
            detail = homeworkService.getSubmittedOne(submission_code);

            model.addAttribute("mode", "edit");
        } else {
            // 등록 모드 → 과제 기본 정보 조회
            detail = homeworkService.getHomeworkDetail(homework_code, loginId);

            model.addAttribute("mode", "write");
        }

        model.addAttribute("detail", detail);

        return "student/assignmentSubmit";
    }

    // 리액트용 과제 제출 화면
    @ResponseBody
    @GetMapping({"/assignmentDetail/{homework_code}/{submissionId}", "/assignmentDetail/{homework_code}/{submissionId}.do"})
    public SHomeworkVO assignmentDetail(
            @PathVariable("homework_code") Integer homework_code,
            @PathVariable("submissionId") Integer submissionId,
            HttpSession session
    ) {
        String loginId = (String) session.getAttribute("loginId");

        if (submissionId != null && submissionId != 0) {
            // 수정 모드 → 제출했던 내용 조회
            return homeworkService.getSubmittedOne(submissionId);
        } else {
            // 등록 모드 → 과제 기본 정보 조회
            return homeworkService.getHomeworkDetail(homework_code, loginId);
        }
    }


    @PostMapping("/submitHomework")
    public String submitHomework(
            @RequestParam("file") MultipartFile uploadFile,
            SHomeworkVO vo,
            HttpSession session) throws Exception {

        String loginId = (String) session.getAttribute("loginId");
        vo.setLoginID(loginId);

        homeworkService.submitHomework(vo, uploadFile);

        return "redirect:/stu/assignments-result";
    }

    // 리액트용 과제 제출
    @PostMapping(value = {"/submitSubmission", "/submitSubmission.do"}
            , consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> submitSubmission(
            @RequestPart("vo") SHomeworkVO vo,
            @RequestParam(value="uploadFile", required = false)
            MultipartFile uploadFile,
            HttpSession session) throws Exception {

        String loginId = (String) session.getAttribute("loginId");
        vo.setLoginID(loginId);

        try {
            homeworkService.submitHomework(vo, uploadFile);
            return ResponseEntity.ok("success");
        }
        catch(Exception e){
            System.out.println("에러 : " + e);
            return ResponseEntity.ok("failed");
        }


    }
    @GetMapping("/assignments-result")
    public String assignmentResultPage(HttpSession session, Model model) {
        String loginId = (String) session.getAttribute("loginId");

        // 제출정보 조회
        List<SHomeworkVO> submittedList = homeworkService.getSubmittedResult(loginId);
        model.addAttribute("submittedList", submittedList);
        return "student/assignments-result";
        // 실제 JSP 위치 : /WEB-INF/view/student/assignments-result.jsp
    }
    @ResponseBody
    @GetMapping({"/submittedList", "/submittedList.do"})
    public List<SHomeworkVO> submittedList(HttpSession session) {
        String loginId = (String) session.getAttribute("loginId");
        return homeworkService.getSubmittedResult(loginId);
    }
  // SHomeworkController.java에 추가
  @ResponseBody
  @PostMapping("/submitAppeal")
  public String submitAppeal(@RequestBody SHomeworkVO vo, HttpSession session) {
    try {
      String loginId = (String) session.getAttribute("loginId");
      vo.setLoginID(loginId);

      // Mapper의 updateAppeal을 호출하도록 서비스 로직 연결
      int result = homeworkService.updateAppeal(vo);
      return result > 0 ? "success" : "failed";
    } catch (Exception e) {
      return "failed";
    }
  }
}



