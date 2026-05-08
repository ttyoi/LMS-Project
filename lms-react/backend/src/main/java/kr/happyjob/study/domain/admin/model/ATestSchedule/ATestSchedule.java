package kr.happyjob.study.domain.admin.model.ATestSchedule;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ATestSchedule {

    private Long course_courseId;
    private String course_title;
    private Integer testSchedule_period;
    private String course_startDate;
    private String course_endDate;
    private String courseClass_className;
    private String course_professor;
    private String tbUserinfo_name;
    private String testSchedule_title;
    private String testSchedule_date;
    private Integer testSchedule_status;

    private Integer testDetail_questionNo;
    private String testDetail_content;
    private String testDetail_option1;
    private String testDetail_option2;
    private String testDetail_option3;
    private Integer testDetail_answer;
    private Integer testDetail_score;
    private String testDetail_comment;

    public ATestSchedule() {}
}
