package kr.happyjob.study.domain.login.dao;

import java.util.Map;

public interface FindDAO {
	public String selectIDbyEmail(String email);
	public int selectCntbyIDAEmail(Map<String, String> info);
	public int updatePasswordByIDAEmail(Map<String, String> info);
}//end interface
