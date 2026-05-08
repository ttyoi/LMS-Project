package kr.happyjob.study.domain.student.service;

import kr.happyjob.study.domain.student.model.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

public interface SMypageService {
    public SMypageVO getStudentMypage(String loginId) throws Exception;

    public int updateStudentMypage(SMypageUpdateDTO dto) throws Exception;

    public int changePassword(MypagePasswordChangeParamDTO dto) throws Exception;

    public Map<String, Object> uploadProfileImage(String loginId, MultipartFile file) throws Exception;


    public Map<String, Object> uploadResume(String loginId, MultipartFile uploadFile) throws Exception;

    public int deleteResume(String loginId) throws Exception;

    public void downloadResume(long resumeId, HttpServletResponse response) throws Exception;

    public List<SMypageCourseStatusVO> getStudentCourseStatus(SMypageCourseStatusParamDTO param);

    public Map<String, Object> getStudentCourseStatusPageData(String loginID);

    public MypageResumeVO getResumeById(long resumeId);

    public List<SMypagePeriodScoreVO> getCoursePeriodScores(String loginID, int courseId);


}
