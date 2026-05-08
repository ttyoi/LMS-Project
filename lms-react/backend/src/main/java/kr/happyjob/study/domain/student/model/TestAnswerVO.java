package kr.happyjob.study.domain.student.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;
import java.util.List;


@Data
@NoArgsConstructor
@AllArgsConstructor
public class TestAnswerVO {
    private String loginId; // userInfo 테이블에서 가져오기
    private int courseId;
    private int period;
    private List<SAnswerDTO> answers; //문제번호당 답변 저장
}
