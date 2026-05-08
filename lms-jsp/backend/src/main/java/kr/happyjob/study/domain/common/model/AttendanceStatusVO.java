package kr.happyjob.study.domain.common.model;

public class AttendanceStatusVO {
	private int att_sta_code; // 출결상태코드: 0, 1, 2, 3, 4
	private String status; // 출결상태구분: 결석, 출석, 지각, 조퇴, 외출
	
	public int getAtt_sta_code() {
		return att_sta_code;
	}
	public void setAtt_sta_code(int att_sta_code) {
		this.att_sta_code = att_sta_code;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
}
