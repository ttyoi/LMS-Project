package kr.happyjob.study.domain.common.model;

public class CourseClassVO {
	private int class_id; // 강의실 ID: 1, 2, 3, ...
	private String class_name; // 호: 101호, 102호, 103호, ...
	private int people_limit; // 인원수 (현재 40명 고정)
	private int status; // 상태: 0, 1
	
	public int getClass_id() {
		return class_id;
	}
	public void setClass_id(int class_id) {
		this.class_id = class_id;
	}
	public String getClass_name() {
		return class_name;
	}
	public void setClass_name(String class_name) {
		this.class_name = class_name;
	}
	public int getPeople_limit() {
		return people_limit;
	}
	public void setPeople_limit(int people_limit) {
		this.people_limit = people_limit;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
}
