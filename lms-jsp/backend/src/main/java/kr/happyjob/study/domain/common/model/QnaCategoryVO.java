package kr.happyjob.study.domain.common.model;

public class QnaCategoryVO {
	private String category_code; // 카테고리코드: ACCOUNT, ENROLL, ETC, LECUTRE, SYSTEM
	private String name; // 카테고리이름: 계정/로그인, 수강관련, 기타, 강의내용, 시스템오류
	
	public String getCategory_code() {
		return category_code;
	}
	public void setCategory_code(String category_code) {
		this.category_code = category_code;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
}

