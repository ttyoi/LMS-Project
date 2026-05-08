package kr.happyjob.study.domain.instructor.dao;

import kr.happyjob.study.domain.student.model.UserInfoVO;

import java.util.Map;

public interface IJoinDAO {

	/* 중복된 강사 아이디 갯수 확인 */
	public int selectInstrucDuplicateIDCnt(String id);

	/* (초기 강사 등록)강사 등록 */
	public int insertRegisterInstructor(Map<String, String> instructorInfo);

	/* (초기 강사 등록)강사 로그인 체크 */
	public int chkInstructorIdAndPassword(Map<String, String> loginInfo);

	/* (초기 강사 등록)이메일 가져오기 */
	public String selectEmailById(String loginID);

	/* (초기 강사 등록) 강사 정보 업데이트 */
	public int updateInstructorInfo(UserInfoVO userInfoVO);
}//end interface
