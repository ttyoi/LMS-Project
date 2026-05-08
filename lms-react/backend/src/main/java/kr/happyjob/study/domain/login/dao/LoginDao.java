package kr.happyjob.study.domain.login.dao;

import kr.happyjob.study.domain.login.model.LgnInfoModel;
import kr.happyjob.study.domain.login.model.UsrMnuAtrtModel;
import kr.happyjob.study.domain.login.model.UsrMnuChildAtrtModel;

import java.util.List;
import java.util.Map;


public interface LoginDao {


	/** 사용자 로그인 체크*/
	public String checkLogin(Map<String, Object> paramMap);
	
	/** 사용자 로그인 */
	public LgnInfoModel selectLogin(Map<String, Object> paramMap);
	
	/**  사용자 메뉴 권한 */
	public List<UsrMnuAtrtModel> listUsrMnuAtrt(Map<String, Object> paramMap);
	
	/**  사용자 자식 메뉴 권한 */
	public List<UsrMnuChildAtrtModel> listUsrChildMnuAtrt(Map<String, Object> paramMap);
	
	/** 사용자 ID 찾기 */
	public LgnInfoModel selectFindId(Map<String, Object> paramMap);

	/** 사용자 PW 찾기 */
	public LgnInfoModel selectFindPw(Map<String, Object> paramMap);
	
	/** 사용자 PW 찾기 ID 체크*/
	public LgnInfoModel registerIdCheck(Map<String, Object> paraMap);

	/** 사용자 회원가입*/
	public int registerUser(Map<String, Object> paramMap);
	
	/** 사용자스킬*/
//	public int registerUser_skill(Map<String, Object> paramMap);

	/**loginID 중복체크*/
	public int check_loginID(LgnInfoModel model);
	
	/**이메일 중복체크*/
	public int check_email(LgnInfoModel model);
	
	/**이력서 파일 업로드 */
//	public static void insertResume(Map<String, Object> paramMap) {
//		// TODO Auto-generated method stub
//
//	}
	
	public static String getDirectory() {
		// TODO Auto-generated method stub
		return null;
	} 
	
	
/*	*//**select박스 은행 목록*//*
	public List<LgnInfoModel> selectBankList();*/
	
}//end interface
