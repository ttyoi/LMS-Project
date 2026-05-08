package kr.happyjob.study.domain.instructor.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TestDetailVO {

    private Integer courseId;
    private Integer period;
    private String title;
    private String studentId;
    private String studentName;
    private int questionNo;
    private String content;
    private String option1;
    private String option2;
    private String option3;
    private String option4;
    private Integer answer; // 등록용 (DB test_detail.answer)
    private Integer score;  // 등록용 (DB test_detail.score)


    private Integer correctAnswer;     // 정답
    private Integer studentAnswer;     // 학생 답안 (없으면 null)
    private Integer earnedScore;

    private String comment; //Nullable
}

