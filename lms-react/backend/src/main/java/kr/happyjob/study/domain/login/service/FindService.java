package kr.happyjob.study.domain.login.service;

public interface FindService {

	/* 이메일을 가지고, ID를 가져오기 */
	public String getIDbyEmail(String email);

	/* 비밀번호 찾기 */
	public String requestSearchPassword(String id, String email);
	
	/* 임시 비밀번호 만들기 */
	public String makeTempPassword(int length);
}//end interface
