package kr.happyjob.study.domain.common.model;

public class CourseStatusVO {
	private int cos_sta_code; // 강의신청상태코드: -1, 0, 1
	private String name; // 강의신청상태명: 거절, 대기중, 활성화
	
	public int getCos_sta_code() {
		return cos_sta_code;
	}
	public void setCos_sta_code(int cos_sta_code) {
		this.cos_sta_code = cos_sta_code;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
}
