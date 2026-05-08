package kr.happyjob.study.domain.homework.dao;

import kr.happyjob.study.domain.homework.model.HomeworkFileVO;
import org.apache.ibatis.annotations.Param;

public interface HomeworkFileDAO {
  // XML의 #{fileId}와 매칭되도록 @Param 추가
  HomeworkFileVO selectFile(@Param("fileId") int fileId);

  // 등록 후 file_id가 VO에 자동으로 담깁니다.
  int insertFile(HomeworkFileVO fileVO);
}
