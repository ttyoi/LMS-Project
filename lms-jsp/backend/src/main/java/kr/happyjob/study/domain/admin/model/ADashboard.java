package kr.happyjob.study.domain.admin.model;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Getter
@Setter
public class ADashboard {

    /* 시험과목 */
    private Long course_courseId;
    private String testSchedule_date;
    private String testSchedule_title;

    /* 강의실 */
    private Long courseClass_classId;
    private String courseClass_className;
    private String courseTime_timeCode;
    private String courseTime_startTime;
    private String courseTime_endTime;
    private String course_startDate;
    private String course_endDate;
    private String course_title;

    /* 사용자 */
    private String tbUserinfo_loginID;
    private String tbUserinfo_userType;
    private String tbUserinfo_regDate;

    /* 커뮤니티 */
    private String notice_noticeId;
    private String notice_title;
    private String notice_regDate;

    private Long survey_id;
    private String survey_title;
    private Long Survey_viewCount;
    private String survey_createAt;

    private Long qnaPost_postId;
    private String qnaPost_title;
    private String qnaPost_answerStatus;
    private String qnaPost_createAt;

    public ADashboard() {}

}
