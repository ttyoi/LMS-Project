package kr.happyjob.study.domain.instructor.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TestScheduleVO {
    private int period;          // 차시
    private int courseId;     // 강의 ID, DB 상 타입은 BigInt
    private String testDate;     // 시험 날짜 (타입은 생각해볼것)
    private int testStatus;     // 시험 상태 (0,1)

}
