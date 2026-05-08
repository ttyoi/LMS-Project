package kr.happyjob.study.domain.instructor.dao;

import kr.happyjob.study.domain.instructor.model.*;
import kr.happyjob.study.domain.student.model.MypagePasswordChangeParamDTO;
import kr.happyjob.study.domain.student.model.MypageProfileUpdateParamDTO;

import java.util.List;
import java.util.Map;

public interface IMypageDAO {
    public IMypageVO getInstructorMypage(String loginId) throws Exception;

    public int updateInstructorMypage(IUpdateDTO dto) throws Exception;

    public int updateEduCareer(IUpdateEduCareerDTO dto) throws Exception;

    public int changePassword(MypagePasswordChangeParamDTO dto) throws Exception;

    public int checkOldPassword(MypagePasswordChangeParamDTO dto) throws Exception;

    public int updateProfileImage(MypageProfileUpdateParamDTO dto) throws Exception;

    public IEduCareerVO getEduCareer(String loginId);

    public List<IMyCourseVO> getMyCourseList(Map<String, Object> param);

    public List<Map<String, Object>> getInstructorCourseStatusCards(String loginID);

    public int getMyCourseListCnt(Map<String, Object> param);

    public int updateTempPasswordFlag(String loginID);


}
