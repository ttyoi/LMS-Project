package kr.happyjob.study.domain.survey.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.domain.survey.dao.SurveyQuestionDao;
import kr.happyjob.study.domain.survey.model.SurveyQuestionModel;

@Service
public class SurveyQuestionServiceImpl implements SurveyQuestionService {

	@Autowired
	SurveyQuestionDao surveyQuestionDao;

	@Override
	public List<SurveyQuestionModel> listQuestionsBySurveyId(Map<String, Object> paramMap) throws Exception {
		return surveyQuestionDao.listQuestionsBySurveyId(paramMap);
	}

	@Override
	public SurveyQuestionModel getQuestionById(Map<String, Object> paramMap) throws Exception {
		return surveyQuestionDao.getQuestionById(paramMap);
	}

	@Override
	public int insertQuestion(Map<String, Object> paramMap) throws Exception {
		return surveyQuestionDao.insertQuestion(paramMap);
	}

	@Override
	public int updateQuestion(Map<String, Object> paramMap) throws Exception {
		return surveyQuestionDao.updateQuestion(paramMap);
	}

	@Override
	public int deleteQuestion(Map<String, Object> paramMap) throws Exception {
		return surveyQuestionDao.deleteQuestion(paramMap);
	}

	@Override
	public int deleteQuestionsBySurveyId(Map<String, Object> paramMap) throws Exception {
		return surveyQuestionDao.deleteQuestionsBySurveyId(paramMap);
	}
}
