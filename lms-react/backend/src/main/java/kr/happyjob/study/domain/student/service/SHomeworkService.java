package kr.happyjob.study.domain.student.service;


import kr.happyjob.study.domain.student.model.SHomeworkVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface SHomeworkService {
      // 학생이 듣는 과정 -> 해당 강사가 올린 과제 목록 조회
    List<SHomeworkVO> getStudentHomeworkList(String loginId);

    SHomeworkVO getHomeworkDetail(int homework_code, String loginId);

    void submitHomework(SHomeworkVO vo, MultipartFile uploadFile) throws Exception;

    List<SHomeworkVO> getSubmittedHomework(String loginId);

    List<SHomeworkVO> getSubmittedResult(String loginId);

    SHomeworkVO getSubmittedOne(int submissionCode);

    Integer findSubmissionCode(int homework_code, String loginId);
    void updateSubmission(int submission_code);
    void deleteSubmissionFile(int submission_code);
    int updateAppeal(SHomeworkVO vo) throws Exception;


}
