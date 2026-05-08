package kr.happyjob.study.domain.instructor.dao;

import kr.happyjob.study.domain.homework.model.SubmissionListVO;
import kr.happyjob.study.domain.instructor.model.ICourseVO;
import kr.happyjob.study.domain.instructor.model.IHomeworkVO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

@Repository("homeworkDAO")
public interface IHomeworkDAO {
  // ... 기존 메서드들 유지 ...

  // ★ 4번째 파라미터 appealReply 추가
  int updateSubmission(@Param("submissionCode") int submissionCode,
                       @Param("score") Integer score,
                       @Param("feedback") String feedback,
                       @Param("appealReply") String appealReply);

  List<SubmissionListVO> selectHomeworkSubmissions(int homeworkCode);
  List<SubmissionListVO> selectAllSubmissions(String loginId);

  // 나머지 메서드 동일하게 유지
  int insertHomework(IHomeworkVO vo);
  List<IHomeworkVO> listHomework(String loginId);
  List<IHomeworkVO> listHomework();
  IHomeworkVO detailHomework(int homework_code);
  int updateHomework(IHomeworkVO vo);
  int deleteHomework(int homework_code);
  int insertFile(Map<String, Object> fileData);
  List<ICourseVO> getCourseListByTeacher(@Param("loginId") String loginId);
  int countSubmissions(int homework_code);
}
