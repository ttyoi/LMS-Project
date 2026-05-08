package kr.happyjob.study.domain.common.model;

public class CourseTimeVO {
	private int time_code; // 강의시간코드: 1, 2, 3
	private String start_time; // 시작시간: 09:00, 12:00, 14:00
	private String end_time; // 종료시간: 12:00, 14:00, 17:00
	
	public int getTime_code() {
		return time_code;
	}
	public void setTime_code(int time_code) {
		this.time_code = time_code;
	}
	public String getStart_time() {
		return start_time;
	}
	public void setStart_time(String start_time) {
		this.start_time = start_time;
	}
	public String getEnd_time() {
		return end_time;
	}
	public void setEnd_time(String end_time) {
		this.end_time = end_time;
	}
}
