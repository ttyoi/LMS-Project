package kr.happyjob.study.domain.student.dao;

import kr.happyjob.study.domain.instructor.model.FileVO;
import kr.happyjob.study.domain.student.model.SHomeworkVO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;


@Repository("SHomeworkDAO")
public interface SHomeworkDAO {
    // 학생이 듣는 과정의 과제 목록 조회
    List<SHomeworkVO> getStudentHomeworkList(@Param("loginId") String loginId);

    SHomeworkVO getHomeworkDetail(@Param("homework_code") int homework_code, @Param("loginId") String loginId);

    int insertFile(FileVO file); // ✔ 정답
    int insertSubmission(SHomeworkVO vo);
    int insertHomeworkFile(@Param("homework_code") int homework_code,
                           @Param("submission_code") int submission_code,
                           @Param("file_id") int file_id);
    List<Map<String, Object>> getSubmittedHomework(@Param("loginId") String loginId);
    List<SHomeworkVO> selectSubmittedHomework(@Param("loginId") String loginId);
    SHomeworkVO getSubmittedOne(int submissionCode);
    List<SHomeworkVO> submittedList(@Param("loginId") String loginId);

    /** 기존 제출 여부 확인 */
    Integer findSubmissionCode(Map<String, Object> param);


    /** 제출 정보 갱신 (날짜, 상태) */
    void updateSubmission(SHomeworkVO vo);

    /** 기존 제출 파일 삭제 */
    void deleteSubmissionFile(@Param("submission_code") int submission_code);
     int updateAppeal(SHomeworkVO vo);
}
