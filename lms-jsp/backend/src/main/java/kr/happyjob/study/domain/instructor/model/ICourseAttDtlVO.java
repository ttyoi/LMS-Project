package kr.happyjob.study.domain.instructor.model;

public class ICourseAttDtlVO {
    private String prof_nm;
    private String loginID;
    private String course_id;
    private String stu_nm;
    private String cour_title;
    private String att_date;
    private int att_code;
    private int att_sta_code;

    public String getProf_nm() {
        return prof_nm;
    }

    public void setProf_nm(String prof_nm) {
        this.prof_nm = prof_nm;
    }

    public String getLoginID() {
        return loginID;
    }

    public void setLoginID(String loginID) {
        this.loginID = loginID;
    }

    public String getCourse_id() {
        return course_id;
    }

    public void setCourse_id(String course_id) {
        this.course_id = course_id;
    }

    public String getStu_nm() {
        return stu_nm;
    }

    public void setStu_nm(String stu_nm) {
        this.stu_nm = stu_nm;
    }

    public String getCour_title() {
        return cour_title;
    }

    public void setCour_title(String cour_title) {
        this.cour_title = cour_title;
    }

    public String getAtt_date() {
        return att_date;
    }

    public void setAtt_date(String att_date) {
        this.att_date = att_date;
    }

    public int getAtt_code() {
        return att_code;
    }

    public void setAtt_code(int att_code) {
        this.att_code = att_code;
    }

    public int getAtt_sta_code() {
        return att_sta_code;
    }

    public void setAtt_sta_code(int att_sta_code) {
        this.att_sta_code = att_sta_code;
    }
}
