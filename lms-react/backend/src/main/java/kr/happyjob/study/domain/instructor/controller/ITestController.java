package kr.happyjob.study.domain.instructor.controller;

import kr.happyjob.study.domain.instructor.model.ITestListDTO;
import kr.happyjob.study.domain.instructor.model.RegTestDTO;
import kr.happyjob.study.domain.instructor.model.TestDetailVO;
import kr.happyjob.study.domain.instructor.service.ITestService;
import kr.happyjob.study.domain.instructor.model.ITestCourseListDTO;
import lombok.RequiredArgsConstructor;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inst")
public class ITestController {

  private final Logger logger = LogManager.getLogger(this.getClass());
  private final String className = this.getClass().toString();
  private final ITestService testService;

  // 시험목록 불러오기 페이지
  @GetMapping("/exams")
  public String getTestList(){
    logger.info("+ 강사 시험목록 페이지 이동 시작" + className + ".initComnCod");
    logger.info("+ 강사 시험목록 페이지 이동 끝 " + className + ".initComnCod");
    return "instructor/testList";
  }

  // 시험목록 불러오기
  @GetMapping("/exams/list")
  @ResponseBody
  public Map<String, Object> getTestList(HttpSession session,
                                         @RequestParam(required = false) String course,
                                         @RequestParam(defaultValue = "1") int currentPage,
                                         @RequestParam(defaultValue = "5") int pageSize
  ) throws Exception{

    String loginId = (String) session.getAttribute("loginId");
    if (loginId == null) {
      throw new Exception("세션 만료. 다시 로그인해주세요.");
    }

    logger.info("+ 강사 시험목록 불러오기 시작" + className + ".initComnCod");
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

    Map<String, Object> result = new HashMap<>();
    try{
      List<ITestListDTO> testList = testService.getTestList(paramMap);
      int totalCount = testService.getTestTotalCount(paramMap);

      result.put("list", testList);
      result.put("totalCount", totalCount);
      logger.info("+ 강사 시험목록 불러오기 끝 " + className + ".initComnCod");
    } catch(Exception e){
      logger.error("시험목록 불러오기 중 오류 발생",e);
      throw e;
    }
    return result;
  }

  // 강의목록 불러오기
  @GetMapping("/exams/courses")
  @ResponseBody
  public List<ITestCourseListDTO> getCourseList(HttpSession session) throws Exception {
    logger.info("+ 강사 강의목록 불러오기 시작" + className + ".initComnCod");
    String loginId = (String) session.getAttribute("loginId");
    if (loginId == null) {
      throw new Exception("세션 만료. 다시 로그인해주세요.");
    }
    List<ITestCourseListDTO> courseList = testService.getCourseList(loginId);
    logger.info("+ 강사 강의목록 불러오기 끝" + className + ".initComnCod");
    return courseList;
  }

  /**
   * [수정 및 확정] 특정 시험의 학생 제출 현황 조회
   * Vue의 fetchStudentSubmissions API와 매핑됩니다.
   */
  @GetMapping("/exams/submissions/{courseId}/{period}")
  @ResponseBody
  public List<Map<String, Object>> getStudentSubmissions(
    @PathVariable("courseId") int courseId,
    @PathVariable("period") int period,
    HttpSession session
  ) throws Exception {
    String loginId = (String) session.getAttribute("loginId");
    if (loginId == null) throw new Exception("세션 만료");

    logger.info("[강사] 학생 제출 현황 조회 시작 : courseId=" + courseId + ", period=" + period);

    // 서비스에서 학생 목록(이름, 아이디, 획득점수 등)을 가져옵니다.
    List<Map<String, Object>> studentList = testService.getStudentSubmissionList(courseId, period);

    logger.info("[강사] 학생 제출 현황 조회 끝 : " + studentList);
    return studentList;
  }

  // 수강생별 시험 결과 상세 조회
  @GetMapping("/exams/result/{courseId}/{period}/{studentId}")
  @ResponseBody
  public Map<String, Object> getTestResult(
    @PathVariable int courseId,
    @PathVariable int period,
    @PathVariable String studentId,
    HttpSession session
  ) throws Exception {

    String loginId = (String) session.getAttribute("loginId");
    if (loginId == null) {
      throw new Exception("세션이 만료되었습니다. 로그인 후 이용해주세요.");
    }

    Map<String, Object> result = new HashMap<>();
    logger.info("[강사] 시험 상세조회 courseId=" + courseId + ", period=" + period + ", studentId=" + studentId);

    // 시험 문항 + 학생답안 + 채점결과
    List<TestDetailVO> detailList = testService.getTestResult(courseId, period, studentId);

    if (detailList == null || detailList.isEmpty()) {
      throw new Exception("시험 데이터가 존재하지 않습니다.");
    }

    // 총점 계산
    int totalScore = detailList.stream()
      .mapToInt(q -> q.getEarnedScore() != null ? q.getEarnedScore() : 0)
      .sum();

    result.put("questions", detailList);
    result.put("totalScore", totalScore);
    result.put("studentId", studentId);
    result.put("courseId", courseId);
    result.put("period", period);
    result.put("title", detailList.get(0).getTitle());
    result.put("studentName", detailList.get(0).getStudentName());

    logger.info("[강사] 시험 상세조회 끝 " + className);
    return result;
  }

  // 시험 삭제
  @DeleteMapping("/exams/{courseId}/{period}")
  @ResponseBody
  public Map<String, Object> deleteExam(
      @PathVariable int courseId,
      @PathVariable int period,
      HttpSession session
  ) {
      Map<String, Object> result = new HashMap<>();
      String loginId = (String) session.getAttribute("loginId");
      if (loginId == null) {
          result.put("success", false);
          result.put("message", "세션이 만료되었습니다.");
          return result;
      }
      try {
          testService.deleteExam(courseId, period, loginId);
          result.put("success", true);
      } catch (IllegalStateException e) {
          result.put("success", false);
          result.put("message", e.getMessage());
      } catch (Exception e) {
          result.put("success", false);
          result.put("message", "삭제 중 오류가 발생했습니다.");
      }
      return result;
  }

  // 시험 등록 페이지
  @GetMapping("/exam-register")
  public String getRegTest(){
    logger.info("+ 강사 시험등록 페이지 이동 시작" + className + ".initComnCod");
    logger.info("+ 강사 시험등록 페이지 이동 끝 " + className + ".initComnCod");
    return "instructor/regTest";
  }

  // DB 등록
  @PostMapping("/exam-register")
  @ResponseBody
  public Map<String, Object> postRegTest(@RequestBody RegTestDTO req, HttpSession session) throws Exception {
    Map<String, Object> result = new HashMap<>();
    String loginId = (String) session.getAttribute("loginId");

    if (loginId == null) {
      result.put("success", false);
      result.put("message", "세션이 만료되었습니다.");
      return result;
    }

    try {
      if (req.getStatus() == 1) {
        // 1. 문항 수 체크 (10~20개)
        if (req.getQuestions() == null || req.getQuestions().size() < 10 || req.getQuestions().size() > 20) {
          throw new IllegalArgumentException("문항 수는 10개에서 20개 사이여야 합니다.");
        }

        // 2. 총점 체크 (100점 만점)
        int totalScore = req.getQuestions().stream()
          .mapToInt(q -> q.getScore() != null ? q.getScore() : 0)
          .sum();
        if (totalScore != 100) {
          throw new IllegalArgumentException("배점 합계가 100점이어야 합니다. (현재: " + totalScore + "점)");
        }
      }

      // 3. 권한 및 중복 체크 후 저장
      testService.validateExamRegister(req, loginId);
      testService.registerExam(req);

      result.put("success", true);
    } catch (IllegalArgumentException | IllegalStateException e) {
        e.printStackTrace();
      result.put("success", false);
      result.put("message", e.getMessage());
    } catch (Exception e) {
        e.printStackTrace();
      result.put("success", false);
      result.put("message", "시스템 오류가 발생했습니다.");
    }

    return result;
  }

//  // [추가] 시험 문항 정보만 조회하는 API (강사용 상세조회)
//  @GetMapping("/exams/detail-info/{courseId}/{period}")
//  @ResponseBody
//  public Map<String, Object> getExamDetailOnly(
//    @PathVariable int courseId,
//    @PathVariable int period,
//    HttpSession session
//  ) throws Exception {
//    String loginId = (String) session.getAttribute("loginId");
//    if (loginId == null) throw new Exception("세션 만료");
//
//    Map<String, Object> result = new HashMap<>();
//
//    // 학생 ID 대신 빈 문자열을 넘겨서 문제 데이터만 가져오도록 기존 서비스 활용
//    List<TestDetailVO> detailList = testService.getTestResult(courseId, period, "");
//
//    if (detailList != null && !detailList.isEmpty()) {
//      result.put("questions", detailList);
//      result.put("title", detailList.get(0).getTitle());
//    }
//
//    return result;
//  }
//
//    @GetMapping("/exams/detail-info/{courseId}/{period}")
//    @ResponseBody
//    public Map<String, Object> getExamDetailOnly(
//            @PathVariable int courseId,
//            @PathVariable int period,
//            HttpSession session
//    ) throws Exception {
//        Map<String, Object> result = new HashMap<>();
//
//        // 학생 ID 대신 빈 문자열("")이 아닌, 문제만 가져올 수 있는 로직이 필요함
//        // 만약 서비스의 getTestResult가 내부적으로 학생 정보를 JOIN 한다면
//        // 학생이 없는 상태에서는 아무것도 조회되지 않을 수 있습니다.
//
//        List<TestDetailVO> detailList = testService.getTestResult(courseId, period, "");
//
//        if (detailList != null && !detailList.isEmpty()) {
//            result.put("questions", detailList);
//            result.put("title", detailList.get(0).getTitle());
//        } else {
//            // 데이터가 없을 경우 클라이언트에서 .length 에러가 나지 않게 빈 배열 반환
//            result.put("questions", new ArrayList<>());
//            result.put("title", "시험 정보 없음");
//        }
//
//        return result;
//    }

    //강사 출제 문제 목록 조회
    @GetMapping("/exams/detail-info/{courseId}/{period}")
    @ResponseBody
    public Map<String, Object> getExamDetailOnly(
            @PathVariable int courseId,
            @PathVariable int period
    ) throws Exception {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("courseId", courseId);
        paramMap.put("period", period);

        // 새롭게 만든 "문항 전용" 서비스 호출
        List<TestDetailVO> detailList = testService.getExamQuestionsOnly(paramMap);

        if (detailList != null && !detailList.isEmpty()) {
            result.put("questions", detailList);
            result.put("title", detailList.get(0).getTitle());
        } else {
            result.put("questions", new ArrayList<TestDetailVO>());
            result.put("title", "등록된 문항이 없습니다.");
        }

        return result;
    }

}
