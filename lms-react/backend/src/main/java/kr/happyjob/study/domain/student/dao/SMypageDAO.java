package kr.happyjob.study.domain.student.dao;

import kr.happyjob.study.domain.student.model.*;

import java.util.List;
import java.util.Map;

public interface SMypageDAO {

    public SMypageVO getStudentMypage(String loginId) throws Exception;

    public int updateStudentMypage(SMypageUpdateDTO dto) throws Exception;

    public int changePassword(MypagePasswordChangeParamDTO dto) throws Exception;

    public int checkOldPassword(MypagePasswordChangeParamDTO dto) throws Exception;

    public int updateTempPasswordFlag(String loginID);

    public int updateProfileImage(MypageProfileUpdateParamDTO dto) throws Exception;

    public int insertResume(MypageResumeInsertParamDTO dto) throws Exception;

    public int deleteResumeByLoginId(String loginID);

    public List<SMypageCourseStatusVO> getStudentCourseStatus(SMypageCourseStatusParamDTO param);

    public List<Map<String, Object>> getStudentCourseStatusCards(String loginID);

    public MypageResumeVO getResumeByLoginId(String loginID);

    public MypageResumeVO getResumeById(long resumeId);

    public List<SMypagePeriodScoreVO> getCoursePeriodScores(Map<String, Object> param);

}
