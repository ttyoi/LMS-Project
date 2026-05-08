package kr.happyjob.study.domain.admin.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ATestDetailVO {
    private Integer courseId;
    private String courseName;  // 강의명
    private Integer period;
    private String testName;    // 시험명
    private Integer questionNo; // 문제번호
    private String content;     // 지문
    private String option1;
    private String option2;
    private String option3;
    private String option4;
    private Integer answer;     // 정답
    private Integer score;      // 배점
    private String comment;     // 해설
}
