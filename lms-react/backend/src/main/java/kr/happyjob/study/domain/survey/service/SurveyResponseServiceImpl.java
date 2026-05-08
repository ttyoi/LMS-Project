package kr.happyjob.study.domain.survey.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.domain.survey.dao.SurveyResponseDao;
import kr.happyjob.study.domain.survey.model.SurveyResponseModel;

@Service
public class SurveyResponseServiceImpl implements SurveyResponseService {

	@Autowired
	SurveyResponseDao surveyResponseDao;

	@Override
	public List<SurveyResponseModel> surveyResponseList(Map<String, Object> paramMap) throws Exception {
		List<SurveyResponseModel> surveyResponseList = surveyResponseDao.surveyResponseList(paramMap);
		return surveyResponseList;
	}

	@Override
	public int surveyResponseCnt(Map<String, Object> paramMap) throws Exception {
		int surveyResponseCnt = surveyResponseDao.surveyResponseCnt(paramMap);
		return surveyResponseCnt;
	}

	@Override
	public SurveyResponseModel surveyResponseDetail(Map<String, Object> paramMap) throws Exception {
		SurveyResponseModel surveyResponseModel = surveyResponseDao.surveyResponseDetail(paramMap);
		return surveyResponseModel;
	}

	@Override
	public int insertSurveyResponse(Map<String, Object> paramMap) throws Exception {
		int statusChange = surveyResponseDao.insertSurveyResponse(paramMap);
		return statusChange;
	}

	@Override
	public int updateSurveyResponse(Map<String, Object> paramMap) throws Exception {
		int statusChange = surveyResponseDao.updateSurveyResponse(paramMap);
		return statusChange;
	}

	@Override
	public int deleteSurveyResponse(Map<String, Object> paramMap) throws Exception {
		int statusChange = surveyResponseDao.deleteSurveyResponse(paramMap);
		return statusChange;
	}

	@Override
	public int checkUserSurveyResponse(Map<String, Object> paramMap) throws Exception {
		int count = surveyResponseDao.checkUserSurveyResponse(paramMap);
		return count;
	}

	@Override
	public List<Map<String, Object>> getQuestionStatistics(Map<String, Object> paramMap) throws Exception {
		return surveyResponseDao.getQuestionStatistics(paramMap);
	}

	@Override
	public List<Map<String, Object>> getTextResponses(Map<String, Object> paramMap) throws Exception {
		return surveyResponseDao.getTextResponses(paramMap);
	}

	@Override
	public List<Map<String, Object>> getAllResponsesBySurvey(Map<String, Object> paramMap) throws Exception {
		return surveyResponseDao.getAllResponsesBySurvey(paramMap);
	}
}
