package kr.happyjob.study.domain.student.controller;

import kr.happyjob.study.domain.student.model.*;
import kr.happyjob.study.domain.student.service.STestService;
import lombok.RequiredArgsConstructor;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
@RequestMapping("/stu/exams")
public class STestController {

    // Set logger
    private final Logger logger = LogManager.getLogger(this.getClass());

    // Get class name for logger
    private final String className = this.getClass().toString();

    private final STestService testService;

    //시험목록 페이지
    @GetMapping("")
    public String TestList(HttpSession session){

        return "student/testList";
    }

    //시험목록 불러오기
    @GetMapping("/list")
    @ResponseBody
    public Map<String, Object> getTestList(HttpSession session,
                                         @RequestParam(required = false) String course,
                                         @RequestParam(defaultValue = "1") int currentPage,
                                         @RequestParam(defaultValue = "5") int pageSize
                                                      ) throws Exception {

        // 세션에서 loginId 얻어오기
        String loginId = (String) session.getAttribute("loginId");

        logger.info("+ 수강생 시험목록 불러오기 시작" + className + ".initComnCod");


        Map<String,Object> paramMap = new HashMap<>();


        paramMap.put("loginId", loginId);
        int pageIndex = (currentPage - 1) * pageSize;
        paramMap.put("pageIndex", pageIndex);
        paramMap.put("pageSize", pageSize);

        if(course==null || course.trim().equals("")){
            paramMap.put("course", null);
        } else {
            paramMap.put("course", course);
        }

        logger.info("loginId = " + loginId);

        //Service 호출
        List<STestListDTO> testList = testService.getTestList(paramMap);
        int totalCount = testService.getTestTotalCount(paramMap);
        
        logger.info("   - paramMap : " + paramMap);
        logger.info("+ 수강생 시험목록 불러오기 끝 " + className + ".initComnCod");

        // JSP 로 전달할 Model 값 넣기
        Map<String, Object> result = new HashMap<>();
        result.put("list", testList);
        result.put("totalCount", totalCount);

        return result;
    }

    // 강의목록 불러오기
    @GetMapping("/courses")
    @ResponseBody
    public List<STestCourseListDTO> getCourseList(HttpSession session) throws Exception {
        logger.info("+ 수강생 강의목록 불러오기 시작" + className + ".initComnCod");
        String loginId = (String) session.getAttribute("loginId");
        List<STestCourseListDTO> courseList = testService.getCourseList(loginId);
        logger.info("+ 수강생 강의목록 불러오기 끝" + className + ".initComnCod");
        return courseList;
    }

    // 시험 응시 가능여부 체크
    @GetMapping("/check")
    @ResponseBody
    public Map<String,Object> checkExamAvailable(
            @RequestParam int courseId,
            @RequestParam int period
    ) throws Exception {
        logger.info("+ 시험응시 가능여부 체크 시작" + className + ".initComnCod");
        boolean available = testService.checkExamAvailable(courseId,period);
        logger.info("available = " + available);
        logger.info("+ 시험응시 가능여부 체크 끝" + className + ".initComnCod");
        Map<String,Object> result = new HashMap<>();
        result.put("available", available);
        result.put("message", available ? "OK" : "응시 가능한 시간이 아닙니다!");
        return result;
    }


    //시험 응시페이지로 이동
    @GetMapping("/detail/{courseId}/{period}")
    public String TestDetail(
            @PathVariable int courseId,
            @PathVariable int period,
            Model model
    ) {
        logger.info("+ 수강생 시험상세 페이지로 이동 시작" + className + ".initComnCod");
//        logger.info("   - paramMap : " + paramMap);
//
        model.addAttribute("courseId", courseId);
        model.addAttribute("period", period);
        logger.info("+ 수강생 시험상세 페이지로 이동 끝 " + className + ".initComnCod");
        return "student/testDetail";
    }

    //시험문제 불러오기
    @GetMapping("/test/{courseId}/{period}")
    @ResponseBody
    public Map<String, Object> getTestDetail(HttpSession session,
                                             @PathVariable int courseId,
                                             @PathVariable int period
    ) throws Exception {
        // 세션에서 loginId 얻어오기
        String loginId = (String) session.getAttribute("loginId");

        // 강의명, 차시정보와 일치하는 시험문제 불러오기
        logger.info("+ 시험문제 불러오기 시작" + className + ".initComnCod");


        Map<String,Object> paramMap = new HashMap<>();
        paramMap.put("loginId", loginId);
        paramMap.put("courseId", courseId);
        paramMap.put("period", period);


        //Service 호출
        List<STestDetailDTO> testDetailList = testService.getTestDetail(paramMap);


        logger.info("   - paramMap : " + paramMap);
        logger.info("+ 시험문제 불러오기 끝 " + className + ".initComnCod");

        // JSP 에 전달할 값 넣기
        Map<String, Object> result = new HashMap<>();
        result.put("list", testDetailList);
        return result;
    }

    //시험 답안 제출
    @PostMapping("/submit")
    @ResponseBody
    public Map<String, Object> submitTestAnswer(@RequestBody TestAnswerVO param,
                                                HttpSession session){

        Map<String, Object> result = new HashMap<>();

        String loginId = (String) session.getAttribute("loginId");

        // 비정상 접근 막기
        if (loginId == null) {
            result.put("result", "FAIL");
            result.put("msg", "로그인이 필요합니다.");
            return result;
        }


        logger.info("+ 시험답안 제출 시작" + className + ".initComnCod");


        //Service 호출



        try {

            param.setLoginId(loginId);


            testService.submitTestAnswer(param);
            result.put("result", "OK");

            logger.info("+ 시험답안 제출 끝" + className + ".initComnCod");

        } catch (Exception e) {
            result.put("result", "FAIL");
            logger.info("+ 시험답안 제출 실패" + className + ".initComnCod");
        }

        return result;
    }

    //시험결과 상세보기 페이지 이동
    @GetMapping("/result/{courseId}/{period}")
    public String TestResult(
            @PathVariable int courseId,
            @PathVariable int period,
            HttpSession session,
            Model model
    ) throws Exception {

        String loginId = (String) session.getAttribute("loginId");

        if (loginId == null || !loginId.equals(session.getAttribute("loginId"))) {
            return null;
        }
        logger.info("+ 수강생 시험결과 페이지 이동 시작" + className + ".initComnCod");
        model.addAttribute("courseId", courseId);
        model.addAttribute("period", period);
        model.addAttribute("loginId", loginId);
        logger.info("   - model : " + model);
        logger.info("+ 수강생 시험결과 페이지 이동 끝 " + className + ".initComnCod");
        return "student/testResult";
    }

    // 수강생별 시험결과 로드
    @GetMapping("/result/{courseId}/{period}/data")
    @ResponseBody
    public Map<String, Object> getTestResult(
            HttpSession session,
            @PathVariable int courseId,
            @PathVariable int period
    ) throws Exception {

        String loginId = (String) session.getAttribute("loginId");

        if (loginId == null) {
            throw new Exception("세션이 만료되었습니다. 로그인 후 이용해주세요.");
        }

        Map<String, Object> result = new HashMap<>();

        // 1) 문제 + 학생답안 + 정답 + 획득 점수 조회
        List<STestResultDTO> resultList = testService.getTestResult(loginId, courseId, period);

        logger.info("+ 수강생 시험결과 불러오기 시작 " + className + ".initComnCod");

        // 2) 총점 계산
        int totalScore = resultList.stream()
                .mapToInt(q -> q.getEarnedScore() != null ? q.getEarnedScore() : 0)
                .sum();

        result.put("questions", resultList);
        result.put("totalScore", totalScore);
        result.put("title",resultList.get(0).getTitle());

        logger.info("   - result : " + result);
        logger.info("+ 수강생 시험결과 불러오기 끝 " + className + ".initComnCod");

        return result;
    }

    
}
