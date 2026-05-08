package kr.happyjob.study.domain.admin.dao;

import kr.happyjob.study.domain.admin.model.AResumeVO;
import kr.happyjob.study.domain.admin.model.AUserVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface AUserDAO {

    // 목록
    List<AUserVO> selectUserList(Map<String, Object> paramMap);

    // 전체 건수
    int selectUserListCount(Map<String, Object> paramMap);


    // 학생 상태 변겅
    int updateStudentStatus(@Param("loginID") String loginID, @Param("status") String status);

    // 이력서 다운로드
    AResumeVO selectResumeByLoginID(@Param("loginID") String loginID);



}
