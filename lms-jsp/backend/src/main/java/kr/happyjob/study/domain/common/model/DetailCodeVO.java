package kr.happyjob.study.domain.common.model;

public class DetailCodeVO {
	private String detail_code; // 상세코드: 0, 1, 2, ...
	private String group_code; // 그룹코드: attend_status
	private String detail_name; // 상세코드명: 결석, 출석, 지각, ...
	
	public String getDetail_code() {
		return detail_code;
	}
	public void setDetail_code(String detail_code) {
		this.detail_code = detail_code;
	}
	public String getGroup_code() {
		return group_code;
	}
	public void setGroup_code(String group_code) {
		this.group_code = group_code;
	}
	public String getDetail_name() {
		return detail_name;
	}
	public void setDetail_name(String detail_name) {
		this.detail_name = detail_name;
	}
}
