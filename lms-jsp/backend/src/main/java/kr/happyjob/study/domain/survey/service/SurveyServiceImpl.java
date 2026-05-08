package kr.happyjob.study.domain.survey.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.domain.survey.dao.SurveyDao;
import kr.happyjob.study.domain.survey.model.SurveyModel;

@Service
public class SurveyServiceImpl implements SurveyService {

    @Autowired
    SurveyDao surveyDao;

    @Override
    public List<SurveyModel> surveyList(Map<String, Object> paramMap) throws Exception {
        return surveyDao.surveyList(paramMap);
    }

    @Override
    public int surveyCnt(Map<String, Object> paramMap) throws Exception {
        return surveyDao.surveyCnt(paramMap);
    }

    @Override
    public SurveyModel surveyDetail(Map<String, Object> paramMap) throws Exception {
        return surveyDao.surveyDetail(paramMap);
    }

    @Override
    public int insertSurvey(Map<String, Object> paramMap) throws Exception {
        return surveyDao.insertSurvey(paramMap);
    }

    @Override
    public int updateSurvey(Map<String, Object> paramMap) throws Exception {
        return surveyDao.updateSurvey(paramMap);
    }

    @Override
    public int deleteSurvey(Map<String, Object> paramMap) throws Exception {
        return surveyDao.deleteSurvey(paramMap);
    }

    @Override
    public Long getNextSurveyId() throws Exception {
        return surveyDao.getNextSurveyId();
    }

    @Override
    public int increaseViewCount(Map<String, Object> paramMap) throws Exception {
        return surveyDao.increaseViewCount(paramMap);
    }

    @Override
    public List<Map<String, Object>> getActiveCourseList() throws Exception {
        return surveyDao.getActiveCourseList();
    }
}
