package kr.happyjob.study.domain.student.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SAnswerDTO {
    private int questionNo;
    private Integer studentAnswer;  // nullable
}
