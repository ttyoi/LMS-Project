package kr.happyjob.study.domain.instructor.service;

import kr.happyjob.study.domain.instructor.model.*;
import kr.happyjob.study.domain.student.model.MypagePasswordChangeParamDTO;
import kr.happyjob.study.domain.student.model.MypageProfileUpdateParamDTO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

public interface IMypageService {
    public IMypageVO getInstructorMypage(String loginId) throws Exception;

    public int updateInstructorMypage(IUpdateDTO dto) throws Exception;

    public int updateEduCareer(IUpdateEduCareerDTO dto) throws Exception;

    public int changePassword(MypagePasswordChangeParamDTO dto) throws Exception;

    public  Map<String, Object> uploadProfileImage(String loginId, MultipartFile file) throws Exception;

    public IEduCareerVO getEduCareer(String loginId);

    public List<IMyCourseVO> getMyCourseList(Map<String, Object> param);

    public Map<String, Object> getInstructorCourseStatusPageData(String loginID);

    public int getMyCourseListCnt(Map<String, Object> param);

}
