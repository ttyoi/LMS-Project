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

import kr.happyjob.study.domain.survey.model.SurveyResponseModel;
import kr.happyjob.study.domain.survey.service.SurveyResponseService;

@Controller
@RequestMapping("/survey/")
public class SurveyResponseController {

	@Autowired
	SurveyResponseService surveyResponseService;

	private final Logger logger = LogManager.getLogger(this.getClass());
	private final String className = this.getClass().toString();

	// 처음 로딩될 때 설문 응답 연결
	@RequestMapping("surveyResponse.do")
	public String init(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".initSurveyResponse");
		logger.info("   - paramMap : " + paramMap);

		String loginID = (String) session.getAttribute("loginId");
		paramMap.put("loginID", loginID);

		return "survey/surveyResponse";
	}

	// 설문 응답 리스트 출력
	@RequestMapping("surveyResponseList.do")
	public String surveyResponseList(Model model, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("   - paramMap : " + paramMap);

		int currentPage = Integer.parseInt((String) paramMap.get("currentPage"));
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int pageIndex = (currentPage - 1) * pageSize;

		paramMap.put("pageIndex", pageIndex);
		paramMap.put("pageSize", pageSize);

		List<SurveyResponseModel> surveyResponseList = surveyResponseService.surveyResponseList(paramMap);
		model.addAttribute("surveyResponse", surveyResponseList);

		int surveyResponseCnt = surveyResponseService.surveyResponseCnt(paramMap);

		model.addAttribute("surveyResponseCnt", surveyResponseCnt);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("currentPage", currentPage);

		return "survey/surveyResponseList";
	}

	// 설문 응답 상세 조회
	@RequestMapping("detailSurveyResponse.do")
	@ResponseBody
	public Map<String, Object> detailSurveyResponse(Model model, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".detailSurveyResponse");
		logger.info("   - paramMap : " + paramMap);

		String result = "";

		SurveyResponseModel detailSurveyResponse = surveyResponseService.surveyResponseDetail(paramMap);

		if (detailSurveyResponse != null) {
			result = "SUCCESS";
		} else {
			result = "FAIL / 불러오기에 실패했습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultMsg", result);
		resultMap.put("result", detailSurveyResponse);

		logger.info("+ End " + className + ".detailSurveyResponse");

		return resultMap;
	}

	// 설문 응답 신규등록, 업데이트
	@RequestMapping("surveyResponseSave.do")
	@ResponseBody
	public Map<String, Object> surveyResponseSave(Model model, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".surveyResponseSave");
		logger.info("   - paramMap : " + paramMap);

		String action = (String) paramMap.get("action");
		String resultMsg = "";

		paramMap.put("loginId", session.getAttribute("loginId"));

		logger.info("loginId : " + paramMap.get("loginId"));

		if ("I".equals(action)) {
			surveyResponseService.insertSurveyResponse(paramMap);
			resultMsg = "SUCCESS";
		} else if ("U".equals(action)) {
			surveyResponseService.updateSurveyResponse(paramMap);
			resultMsg = "UPDATED";
		} else {
			resultMsg = "FALSE : 등록에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultMsg", resultMsg);

		return resultMap;
	}

	// 설문 응답 삭제
	@RequestMapping("surveyResponseDelete.do")
	@ResponseBody
	public Map<String, Object> surveyResponseDelete(Model model, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".surveyResponseDelete");
		logger.info("   - paramMap : " + paramMap);

		String result = "SUCCESS";
		String resultMsg = "삭제 되었습니다.";

		surveyResponseService.deleteSurveyResponse(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result", result);
		resultMap.put("resultMsg", resultMsg);

		logger.info("+ End " + className + ".surveyResponseDelete");

		return resultMap;
	}
}
