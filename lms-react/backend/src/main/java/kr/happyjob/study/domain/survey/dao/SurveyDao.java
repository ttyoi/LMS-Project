package kr.happyjob.study.domain.survey.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.domain.survey.model.SurveyModel;

public interface SurveyDao {

    List<SurveyModel> surveyList(Map<String, Object> paramMap) throws Exception;

    int surveyCnt(Map<String, Object> paramMap) throws Exception;

    SurveyModel surveyDetail(Map<String, Object> paramMap) throws Exception;

    int insertSurvey(Map<String, Object> paramMap) throws Exception;

    int updateSurvey(Map<String, Object> paramMap) throws Exception;

    int deleteSurvey(Map<String, Object> paramMap) throws Exception;

    Long getNextSurveyId() throws Exception;

    int increaseViewCount(Map<String, Object> paramMap) throws Exception;

    List<Map<String, Object>> getActiveCourseList() throws Exception;
}
