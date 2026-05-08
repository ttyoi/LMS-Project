package kr.happyjob.study.domain.survey.service;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.domain.survey.model.SurveyResponseModel;

public interface SurveyResponseService {

	// 설문 응답 리스트 조회
	public List<SurveyResponseModel> surveyResponseList(Map<String, Object> paramMap) throws Exception;

	// 설문 응답 목록 카운트 조회
	public int surveyResponseCnt(Map<String, Object> paramMap) throws Exception;

	// 설문 응답 단건 조회
	public SurveyResponseModel surveyResponseDetail(Map<String, Object> paramMap) throws Exception;

	// 설문 응답 저장
	public int insertSurveyResponse(Map<String, Object> paramMap) throws Exception;

	// 설문 응답 수정
	public int updateSurveyResponse(Map<String, Object> paramMap) throws Exception;

	// 설문 응답 삭제
	public int deleteSurveyResponse(Map<String, Object> paramMap) throws Exception;

	// 특정 사용자의 특정 설문 응답 여부 확인
	public int checkUserSurveyResponse(Map<String, Object> paramMap) throws Exception;

	// 설문 응답 통계 - 문항별 평균 및 응답 수
	public List<Map<String, Object>> getQuestionStatistics(Map<String, Object> paramMap) throws Exception;

	// 주관식 응답 목록 조회
	public List<Map<String, Object>> getTextResponses(Map<String, Object> paramMap) throws Exception;

	// 전체 응답자 목록 및 응답 내용
	public List<Map<String, Object>> getAllResponsesBySurvey(Map<String, Object> paramMap) throws Exception;
}
