package kr.happyjob.study.domain.instructor.model;

public class ICourseVO {
    private int course_id;
    private String title;
    private String start_date;
    private String end_date;
    private String content;
    private String notice;
    private String plan;
    private String reg_sta_date;
    private String reg_end_date;
    private int stu_cnt;
    private int people_limit;
    private double att_ratio;
    private double per_ratio;
    private double abs_ratio;
    private int cour_cnt;
    private String inst_name;
    private String sInst_name;
    private int period_cnt;
    private String status;
    private String class_name;
    private String sub_prof;

    private int class_id;
    private String time_code;

    private String cos_sta_code;

    public int getCourse_id() {
        return course_id;
    }

    public void setCourse_id(int course_id) {
        this.course_id = course_id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getStart_date() {
        return start_date;
    }

    public void setStart_date(String start_date) {
        this.start_date = start_date;
    }

    public String getEnd_date() {
        return end_date;
    }

    public void setEnd_date(String end_date) {
        this.end_date = end_date;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getNotice() {
        return notice;
    }

    public void setNotice(String notice) {
        this.notice = notice;
    }

    public String getPlan() {
        return plan;
    }

    public void setPlan(String plan) {
        this.plan = plan;
    }

    public String getReg_sta_date() {
        return reg_sta_date;
    }

    public void setReg_sta_date(String reg_sta_date) {
        this.reg_sta_date = reg_sta_date;
    }

    public String getReg_end_date() {
        return reg_end_date;
    }

    public void setReg_end_date(String reg_end_date) {
        this.reg_end_date = reg_end_date;
    }

    public int getStu_cnt() {
        return stu_cnt;
    }

    public void setStu_cnt(int stu_cnt) {
        this.stu_cnt = stu_cnt;
    }

    public int getPeople_limit() {
        return people_limit;
    }

    public void setPeople_limit(int people_limit) {
        this.people_limit = people_limit;
    }

    public double getAtt_ratio() {
        return att_ratio;
    }

    public void setAtt_ratio(double att_ratio) {
        this.att_ratio = att_ratio;
    }

    public String getInst_name() {
        return inst_name;
    }

    public void setInst_name(String inst_name) {
        this.inst_name = inst_name;
    }

    public String getsInst_name() {
        return sInst_name;
    }

    public void setsInst_name(String sInst_name) {
        this.sInst_name = sInst_name;
    }

    public int getPeriod_cnt() {
        return period_cnt;
    }

    public void setPeriod_cnt(int period_cnt) {
        this.period_cnt = period_cnt;
    }

    public double getPer_ratio() {
        return per_ratio;
    }

    public void setPer_ratio(double per_ratio) {
        this.per_ratio = per_ratio;
    }

    public double getAbs_ratio() {
        return abs_ratio;
    }

    public void setAbs_ratio(double abs_ratio) {
        this.abs_ratio = abs_ratio;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getCour_cnt() {
        return cour_cnt;
    }

    public void setCour_cnt(int cour_cnt) {
        this.cour_cnt = cour_cnt;
    }

    public String getClass_name() {
        return class_name;
    }

    public void setClass_name(String class_name) {
        this.class_name = class_name;
    }

    public String getSub_prof() {
        return sub_prof;
    }

    public void setSub_prof(String sub_prof) {
        this.sub_prof = sub_prof;
    }

    public int getClass_id() {
        return class_id;
    }
    public void setClass_id(int class_id) {
        this.class_id = class_id;
    }

    public String getTime_code() {
        return time_code;
    }
    public void setTime_code(String time_code) {
        this.time_code = time_code;
    }

    public String getCos_sta_code() {
        return cos_sta_code;
    }

    public void setCos_sta_code(String cos_sta_code) {
        this.cos_sta_code = cos_sta_code;
    }

}
