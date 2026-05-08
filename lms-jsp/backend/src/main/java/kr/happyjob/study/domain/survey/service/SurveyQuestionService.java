package kr.happyjob.study.domain.survey.service;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.domain.survey.model.SurveyQuestionModel;

public interface SurveyQuestionService {

	// 설문 문항 리스트 조회
	public List<SurveyQuestionModel> listQuestionsBySurveyId(Map<String, Object> paramMap) throws Exception;

	// 설문 문항 단건 조회
	public SurveyQuestionModel getQuestionById(Map<String, Object> paramMap) throws Exception;

	// 설문 문항 저장
	public int insertQuestion(Map<String, Object> paramMap) throws Exception;

	// 설문 문항 수정
	public int updateQuestion(Map<String, Object> paramMap) throws Exception;

	// 설문 문항 삭제
	public int deleteQuestion(Map<String, Object> paramMap) throws Exception;

	// 특정 설문의 모든 문항 삭제
	public int deleteQuestionsBySurveyId(Map<String, Object> paramMap) throws Exception;
}
