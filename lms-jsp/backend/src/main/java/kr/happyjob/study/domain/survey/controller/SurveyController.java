package kr.happyjob.study.domain.survey.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.happyjob.study.domain.survey.model.SurveyModel;
import kr.happyjob.study.domain.survey.model.SurveyQuestionModel;
import kr.happyjob.study.domain.survey.service.SurveyService;
import kr.happyjob.study.domain.survey.service.SurveyQuestionService;
import kr.happyjob.study.domain.instructor.service.IHomeworkService;
import kr.happyjob.study.domain.instructor.model.ICourseVO;

@Controller
@RequestMapping("/survey/")
public class SurveyController {

    @Autowired
    SurveyService surveyService;

    @Autowired
    SurveyQuestionService surveyQuestionService;

    @Autowired
    kr.happyjob.study.domain.survey.service.SurveyResponseService surveyResponseService;

    @Autowired
    IHomeworkService iHomeworkService;

    private final Logger logger = LogManager.getLogger(this.getClass());
    private final String className = this.getClass().toString();

    @RequestMapping("survey.do")
    public String init(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
                       HttpServletResponse response, HttpSession session) throws Exception {

        String loginID = (String) session.getAttribute("loginId");
        String userType = (String) session.getAttribute("userType");

        paramMap.put("loginID", loginID);
        paramMap.put("userType", userType);

        // 강사/관리자의 경우 강의 목록 조회
        if (!"S".equals(userType)) {
            List<ICourseVO> courseList = iHomeworkService.getCourseListByTeacher(loginID);
            model.addAttribute("courseList", courseList);
        }

        // user_type에 따라 페이지 분기
        // A: 관리자, I: 강사 -> survey.jsp
        // S: 학생 -> survey_student.jsp
        if ("S".equals(userType)) {
            return "survey/survey_student";
        } else {
            return "survey/survey";
        }
    }

    @RequestMapping("surveyList.do")
    public String surveyList(Model model, @RequestParam Map<String, Object> paramMap,
                             HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

        int currentPage = Integer.parseInt((String) paramMap.get("currentPage"));
        int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
        int pageIndex = (currentPage - 1) * pageSize;

        paramMap.put("pageIndex", pageIndex);
        paramMap.put("pageSize", pageSize);

        // 응답 완료 여부 확인을 위해 loginID 전달
        String loginID = (String) session.getAttribute("loginId");
        paramMap.put("loginID", loginID);

        List<SurveyModel> surveyList = surveyService.surveyList(paramMap);
        model.addAttribute("survey", surveyList);

        int surveyCnt = surveyService.surveyCnt(paramMap);

        model.addAttribute("surveyCnt", surveyCnt);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("currentPage", currentPage);

        // userType 전달
        String userType = (String) session.getAttribute("userType");
        model.addAttribute("userType", userType);

        if ("S".equals(userType)) {
            return "survey/surveyList_student";
        } else {
            return "survey/surveyList_admin";
        }
    }

    @RequestMapping("detailSurvey.do")
    @ResponseBody
    public Map<String, Object> detailSurvey(Model model, @RequestParam Map<String, Object> paramMap,
                                            HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

        String loginId = (String) session.getAttribute("loginId");
        String surveyId = (String) paramMap.get("surveyId");

        SurveyModel detailSurvey = surveyService.surveyDetail(paramMap);
        Map<String, Object> resultMap = new HashMap<>();

        if (detailSurvey != null) {
            // 조회수 증가 - 같은 사용자는 1번만 증가
            String viewedKey = "viewed_survey_" + surveyId + "_" + loginId;
            if (session.getAttribute(viewedKey) == null) {
                surveyService.increaseViewCount(paramMap);
                session.setAttribute(viewedKey, true);
            }

            // 해당 사용자가 이미 응답했는지 확인
            Map<String, Object> checkParam = new HashMap<>();
            checkParam.put("surveyId", surveyId);
            checkParam.put("loginId", loginId);
            int responseCount = surveyResponseService.checkUserSurveyResponse(checkParam);

            List<SurveyQuestionModel> questions = surveyQuestionService.listQuestionsBySurveyId(paramMap);
            resultMap.put("resultMsg", "SUCCESS");
            resultMap.put("result", detailSurvey);
            resultMap.put("questions", questions);
            resultMap.put("alreadyResponded", responseCount > 0); // 이미 응답했는지 여부
        } else {
            resultMap.put("resultMsg", "FAIL");
        }

        return resultMap;
    }

    // ---------------------- 핵심 수정된 메소드 ---------------------- //

    @RequestMapping("surveySave.do")
    @ResponseBody
    public Map<String, Object> surveySave(Model model, @RequestParam Map<String, Object> paramMap,
                                          HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

        String action = (String) paramMap.get("action");
        String resultMsg = "";

        paramMap.put("loginId", session.getAttribute("loginId"));

        // 신규등록
        if ("I".equals(action)) {

            // surveyId 비우기
            if (paramMap.get("surveyId") != null && "".equals(paramMap.get("surveyId").toString().trim())) {
                paramMap.remove("surveyId");
            }

            // 설문 저장
            surveyService.insertSurvey(paramMap);

            // selectKey 결과가 paramMap에 들어오지 않기 때문에 직접 조회
            Long surveyId = surveyService.getNextSurveyId() - 1;
            paramMap.put("surveyId", surveyId);

            // 문항 저장
            String[] questionContents = request.getParameterValues("questionContents");
            String[] questionTypes = request.getParameterValues("questionTypes");

            if (questionContents != null && questionTypes != null) {
                for (int i = 0; i < questionContents.length; i++) {
                    Map<String, Object> questionParam = new HashMap<>();
                    questionParam.put("content", questionContents[i]);
                    questionParam.put("type", questionTypes[i]);
                    questionParam.put("order", i + 1);
                    questionParam.put("surveyId", surveyId);

                    surveyQuestionService.insertQuestion(questionParam);
                }
            }

            resultMsg = "SUCCESS";

        } else if ("U".equals(action)) {

            // 설문 수정
            surveyService.updateSurvey(paramMap);

            // 기존 문항 삭제
            surveyQuestionService.deleteQuestionsBySurveyId(paramMap);

            // 문항 재저장
            String[] questionContents = request.getParameterValues("questionContents");
            String[] questionTypes = request.getParameterValues("questionTypes");
            Long surveyId = Long.parseLong(paramMap.get("surveyId").toString());

            if (questionContents != null && questionTypes != null) {
                for (int i = 0; i < questionContents.length; i++) {
                    Map<String, Object> questionParam = new HashMap<>();
                    questionParam.put("content", questionContents[i]);
                    questionParam.put("type", questionTypes[i]);
                    questionParam.put("order", i + 1);
                    questionParam.put("surveyId", surveyId);

                    surveyQuestionService.insertQuestion(questionParam);
                }
            }

            resultMsg = "UPDATED";

        } else {
            resultMsg = "FALSE";
        }

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("resultMsg", resultMsg);

        return resultMap;
    }

    @RequestMapping("surveyDelete.do")
    @ResponseBody
    public Map<String, Object> surveyDelete(Model model, @RequestParam Map<String, Object> paramMap,
                                            HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

        surveyQuestionService.deleteQuestionsBySurveyId(paramMap);
        surveyService.deleteSurvey(paramMap);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", "SUCCESS");
        resultMap.put("resultMsg", "삭제 되었습니다.");

        return resultMap;
    }

    // 설문 통계 페이지로 이동
    @RequestMapping("surveyResult.do")
    public String surveyResult(Model model, @RequestParam Map<String, Object> paramMap,
                               HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

        String surveyId = (String) paramMap.get("surveyId");
        model.addAttribute("surveyId", surveyId);

        return "survey/survey_result";
    }

    // 설문 통계 데이터 조회
    @RequestMapping("getSurveyStatistics.do")
    @ResponseBody
    public Map<String, Object> getSurveyStatistics(Model model, @RequestParam Map<String, Object> paramMap,
                                                    HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

        Map<String, Object> resultMap = new HashMap<>();

        try {
            // 설문 정보 조회
            SurveyModel survey = surveyService.surveyDetail(paramMap);

            // 문항별 통계 조회
            List<Map<String, Object>> questionStats = surveyResponseService.getQuestionStatistics(paramMap);

            // 전체 응답자 목록 조회
            List<Map<String, Object>> allResponses = surveyResponseService.getAllResponsesBySurvey(paramMap);

            resultMap.put("resultMsg", "SUCCESS");
            resultMap.put("survey", survey);
            resultMap.put("questionStats", questionStats);
            resultMap.put("allResponses", allResponses);

        } catch (Exception e) {
            resultMap.put("resultMsg", "FAIL");
            resultMap.put("errorMsg", e.getMessage());
        }

        return resultMap;
    }

    // 특정 문항의 주관식 응답 조회
    @RequestMapping("getTextResponses.do")
    @ResponseBody
    public Map<String, Object> getTextResponses(Model model, @RequestParam Map<String, Object> paramMap,
                                                 HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

        Map<String, Object> resultMap = new HashMap<>();

        try {
            List<Map<String, Object>> textResponses = surveyResponseService.getTextResponses(paramMap);

            resultMap.put("resultMsg", "SUCCESS");
            resultMap.put("textResponses", textResponses);

        } catch (Exception e) {
            resultMap.put("resultMsg", "FAIL");
            resultMap.put("errorMsg", e.getMessage());
        }

        return resultMap;
    }

    // 개설된 강의 목록 조회
    @RequestMapping("getActiveCourseList.do")
    @ResponseBody
    public Map<String, Object> getActiveCourseList(Model model, @RequestParam Map<String, Object> paramMap,
                                                    HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

        Map<String, Object> resultMap = new HashMap<>();

        try {
            List<Map<String, Object>> courseList = surveyService.getActiveCourseList();

            resultMap.put("resultMsg", "SUCCESS");
            resultMap.put("courseList", courseList);

        } catch (Exception e) {
            resultMap.put("resultMsg", "FAIL");
            resultMap.put("errorMsg", e.getMessage());
        }

        return resultMap;
    }

    @RequestMapping("/surveyListAjax.do")
    @ResponseBody
    public Map<String, Object> surveyListAjax(@RequestParam Map<String, Object> param, HttpSession session) {

      Map<String, Object> res = new HashMap<>();

      try {
        // 1) 페이지 계산 (JSP에서 쓰던 방식 그대로)
        int currentPage = Integer.parseInt(String.valueOf(param.getOrDefault("currentPage", "1")));
        int pageSize = Integer.parseInt(String.valueOf(param.getOrDefault("pageSize", "5")));
        int pageIndex = (currentPage - 1) * pageSize;

        param.put("currentPage", currentPage);
        param.put("pageSize", pageSize);
        param.put("pageIndex", pageIndex);

        // 2) (선택) 로그인 사용자 id를 mapper의 responseYn 계산에 쓰고 있다면 넣어주기
        // mapper에서 sr.loginID 조건을 타기 때문에, 로그인 기준 응답여부가 필요하면 세팅
        Object loginId = session.getAttribute("loginId");
        if (loginId != null) {
          param.put("loginID", String.valueOf(loginId));
        } else {
          param.put("loginID", "");
        }

        // 3) 조회
        List<SurveyModel> list = surveyService.surveyList(param);
        int totalCnt = surveyService.surveyCnt(param);

        res.put("resultMsg", "SUCCESS");
        res.put("list", list);
        res.put("totalCnt", totalCnt);
        res.put("currentPage", currentPage);
        res.put("pageSize", pageSize);

      } catch (Exception e) {
        res.put("resultMsg", "FAIL");
        res.put("errorMsg", e.getMessage());
      }

      return res;
    }
}
