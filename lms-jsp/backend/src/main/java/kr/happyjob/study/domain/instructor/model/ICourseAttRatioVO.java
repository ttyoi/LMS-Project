package kr.happyjob.study.domain.instructor.model;

import kr.happyjob.study.domain.admin.model.AUserVO;

public class ICourseAttRatioVO {
    private String prof_name;
    private String course_id;
    private String stu_name;
    private String cour_title;
    private String stu_loginID;
    private int att_sta_code;
    private int att_cnt;
    private int att_per_cnt;
    private int att_leav_cnt;
    private int att_out_cnt;
    private int att_abs_cnt;

    private String today_att_code;
    private Integer today_att_code_pk;
    private int stu_cou_sta_code;

    public String getProf_name() {
        return prof_name;
    }

    public void setProf_name(String prof_name) {
        this.prof_name = prof_name;
    }

    public String getCourse_id() {
        return course_id;
    }

    public void setCourse_id(String course_id) {
        this.course_id = course_id;
    }

    public String getStu_name() {
        return stu_name;
    }

    public void setStu_name(String stu_name) {
        this.stu_name = stu_name;
    }

    public String getCour_title() {
        return cour_title;
    }

    public void setCour_title(String cour_title) {
        this.cour_title = cour_title;
    }

    public String getStu_loginID() {
        return stu_loginID;
    }

    public void setStu_loginID(String stu_loginID) {
        this.stu_loginID = stu_loginID;
    }

    public int getAtt_sta_code() {
        return att_sta_code;
    }

    public void setAtt_sta_code(int att_sta_code) {
        this.att_sta_code = att_sta_code;
    }

    public int getAtt_cnt() {
        return att_cnt;
    }

    public void setAtt_cnt(int att_cnt) {
        this.att_cnt = att_cnt;
    }

    public int getAtt_per_cnt() {
        return att_per_cnt;
    }

    public void setAtt_per_cnt(int att_per_cnt) {
        this.att_per_cnt = att_per_cnt;
    }

    public int getAtt_leav_cnt() {
        return att_leav_cnt;
    }

    public void setAtt_leav_cnt(int att_leav_cnt) {
        this.att_leav_cnt = att_leav_cnt;
    }

    public int getAtt_out_cnt() {
        return att_out_cnt;
    }

    public void setAtt_out_cnt(int att_out_cnt) {
        this.att_out_cnt = att_out_cnt;
    }

    public int getAtt_abs_cnt() {
        return att_abs_cnt;
    }

    public void setAtt_abs_cnt(int att_abs_cnt) {
        this.att_abs_cnt = att_abs_cnt;
    }

    public String getToday_att_code() { return today_att_code; }

    public void setToday_att_code(String today_att_code) { this.today_att_code = today_att_code; }

  public Integer getToday_att_code_pk() {return today_att_code_pk;}

  public void setToday_att_code_pk(Integer today_att_code_pk) { this.today_att_code_pk = today_att_code_pk; }

  public int getStu_cou_sta_code() { return stu_cou_sta_code; }

  public void setStu_cou_sta_code(int stu_cou_sta_code) { this.stu_cou_sta_code = stu_cou_sta_code; }
}
