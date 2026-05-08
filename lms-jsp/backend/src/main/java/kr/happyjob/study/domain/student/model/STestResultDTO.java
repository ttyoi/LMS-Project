package kr.happyjob.study.domain.student.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class STestResultDTO {
    private int courseId;
    private int period;

    private String title;

    private int questionNo;
    private String content;

    private String option1;
    private String option2;
    private String option3;
    private String option4;

    private Integer correctAnswer;     // 정답
    private Integer studentAnswer;     // 학생 답안 (없으면 null)
    private Integer earnedScore;       // 맞춘 경우 점수, 틀리면 0

    private String comment;            // 해설
}
