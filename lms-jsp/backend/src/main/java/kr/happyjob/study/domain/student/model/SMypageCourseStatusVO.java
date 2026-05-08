package kr.happyjob.study.domain.student.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SMypageCourseStatusVO {

    private Long courseId;
    private String courseName;

    private Integer totalScore;     // 시험 총점
    private Integer studentScore;   // 학생 점수
    private String testStatus;      // 시험상태 (NO_TEST, NOT TAKEN, TAKEN)
    private String grade;           // 성적 (A/B/C/D/F)

    private Integer courseStatusCode;
    private String courseStatusName;

    private Double avgScore;
    private Double myAvgScore;

}
