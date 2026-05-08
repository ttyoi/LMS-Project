package kr.happyjob.study.domain.admin.service;

import kr.happyjob.study.domain.admin.model.AResumeVO;
import kr.happyjob.study.domain.admin.model.AUserVO;

import java.util.List;
import java.util.Map;

public interface AUserService {
    // 강사 리스트
    List<AUserVO> getInstructorList(Map<String,Object> paramMap);

    // 강사 수
    int getInstructorListCount(Map<String,Object> paramMap);

    // 강사 상세 정보
    AUserVO getInstructorDetail(String loginID);


    //학생리스트
    List<AUserVO> getStudentList(Map<String, Object> paramMap);
    // 학생 수
    int getStudentListCount(Map<String, Object> paramMap);

    // 학생 상세 정보
    AUserVO getStudentDetailByLogin(String loginID);

    // 학생 상태 업데이트
    int updateStudentStatus(String loginID, String status);

    // 이력서 다운로드
    AResumeVO getResumeByLoginID(String loginID);

}
