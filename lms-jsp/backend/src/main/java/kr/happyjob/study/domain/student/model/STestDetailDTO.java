package kr.happyjob.study.domain.student.model;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class STestDetailDTO {
    private int courseId;     // 강의코드
    private int period;          // 차시
    private String testTitle;    // 시험명
    private int questionNo;     // 문제번호
    private String content;     // 지문
    private String option1;     // 보기1
    private String option2;     //...
    private String option3;
    private String option4;

    // 추가
    private Integer answer;    // 정답
    private String comment;     // 해설
}
