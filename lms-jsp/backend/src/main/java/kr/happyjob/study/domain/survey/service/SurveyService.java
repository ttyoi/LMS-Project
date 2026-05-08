package kr.happyjob.study.domain.survey.service;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.domain.survey.model.SurveyModel;

public interface SurveyService {

	// 설문조사 리스트 조회
	public List<SurveyModel> surveyList(Map<String, Object> paramMap) throws Exception;

	// 설문조사 목록 카운트 조회
	public int surveyCnt(Map<String, Object> paramMap) throws Exception;

	// 설문조사 단건 조회
	public SurveyModel surveyDetail(Map<String, Object> paramMap) throws Exception;

	// 설문조사 저장
	public int insertSurvey(Map<String, Object> paramMap) throws Exception;

	// 설문조사 수정
	public int updateSurvey(Map<String, Object> paramMap) throws Exception;

	// 설문조사 삭제
	public int deleteSurvey(Map<String, Object> paramMap) throws Exception;

    Long getNextSurveyId() throws Exception;

	// 설문조사 조회수 증가
	public int increaseViewCount(Map<String, Object> paramMap) throws Exception;

	// 개설된 강의 목록 조회
	public List<Map<String, Object>> getActiveCourseList() throws Exception;
}
