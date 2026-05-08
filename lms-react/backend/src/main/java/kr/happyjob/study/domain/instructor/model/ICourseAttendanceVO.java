package kr.happyjob.study.domain.instructor.model;

import kr.happyjob.study.domain.admin.model.AUserVO;

public class ICourseAttendanceVO {
    private int attendance_code;
    private String course_id;
    private String date;
    private String loginID;
    private int att_sta_code;

    public int getAttendance_code() {
        return attendance_code;
    }

    public void setAttendance_code(int attendance_code) {
        this.attendance_code = attendance_code;
    }

    public String getCourse_id() {
        return course_id;
    }

    public void setCourse_id(String course_id) {
        this.course_id = course_id;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getLoginID() {
        return loginID;
    }

    public void setLoginID(String loginID) {
        this.loginID = loginID;
    }

    public int getAtt_sta_code() {
        return att_sta_code;
    }

    public void setAtt_sta_code(int att_sta_code) {
        this.att_sta_code = att_sta_code;
    }

}
