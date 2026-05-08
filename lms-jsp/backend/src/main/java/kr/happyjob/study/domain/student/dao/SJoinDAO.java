package kr.happyjob.study.domain.student.dao;

import kr.happyjob.study.domain.student.model.UserInfoVO;

public interface SJoinDAO {
	/* 로그인 중복 체크 */
	public int checkDuplicateID(String loginID);
	/* 이메일 중복 체크 */
	public int checkDuplicateEmail(String email);
	/* 학생 회원 가입 */
	public int insertStudentInfo(UserInfoVO uim);

}//end interface
