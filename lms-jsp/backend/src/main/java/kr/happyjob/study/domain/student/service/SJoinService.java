package kr.happyjob.study.domain.student.service;

import kr.happyjob.study.domain.student.model.UserInfoVO;

import java.util.Map;

public interface SJoinService{
	/* 아이디 중복 체크 */
	public int checkDuplicateID(String loginID);
	/* 이메일 중복 체크 */
	public int checkDuplicateEmail(String email);
	/* 약관 가져오기 */
	public Map<String, String> getUserPolicy(String checkboxID);

	/* 회원가입(학생) */
	public int registerStudent(UserInfoVO uim);

}//end interface
