package kr.happyjob.study.domain.common.model;

public class SCourseStatusVO {
	private int stu_cou_sta_code; // 수강상태코드: -1, 0, 1
	private String name; // 수강상태명: 낙제, 수강중, 수강완료
	
	public int getStu_cou_sta_code() {
		return stu_cou_sta_code;
	}
	public void setStu_cou_sta_code(int stu_cou_sta_code) {
		this.stu_cou_sta_code = stu_cou_sta_code;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
}
