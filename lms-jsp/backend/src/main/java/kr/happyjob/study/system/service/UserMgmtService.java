package kr.happyjob.study.system.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.happyjob.study.system.model.UserMgmtModel;

public interface UserMgmtService {

	// 사용자 목록 조회
	public List<UserMgmtModel> userlist(Map<String, Object> paramMap) throws Exception;

	// 사용자 목록 카운트 조회
	public int userlisttotalcnt(Map<String, Object> paramMap)throws Exception ;
	
	// 특정 사용자 조회
	public UserMgmtModel userselect(Map<String, Object> paramMap) throws Exception;
	
	// ID 중복 체크
	public int iddupcheck(Map<String, Object> paramMap)throws Exception ;
	
	// user 등록
	public int insertuser(Map<String, Object> paramMap, HttpServletRequest request)throws Exception ;
		
	// user 수정
	public int updateuser(Map<String, Object> paramMap, HttpServletRequest request)throws Exception ;
			
	// user 삭제
	public int deleteuser(Map<String, Object> paramMap)throws Exception ;
				
	// 파일정보 조회
	public UserMgmtModel selectuserfile(Map<String, Object> paramMap)throws Exception ;
		
	
	
}
