package kr.happyjob.study.domain.instructor.dao;

import kr.happyjob.study.domain.instructor.model.FileVO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository("homeworkFileDao")
public interface IHomeworkFileDAO {
    int insertHomeworkFile(Map<String, Object> map);
  int updateSubmission(@Param("submissionCode") int submissionCode,
                       @Param("score") Integer score,
                       @Param("feedback") String feedback,
                       @Param("appealReply") String appealReply);
    List<Map<String, Object>> selectFilesByHomework(int homeworkCode);
    int deleteHomeworkFiles(int homeworkCode);
    void insertFile(FileVO fileVO);
    int countHomeworkFile(int homework_code);
    int findFileId(int homework_code);
    int deleteHomeworkFile(int homework_code);
    int countFile(int file_id);
    int deleteFile(int file_id);

    Map<String, Object> selectFileDetail(int file_id);
}
