package kr.happyjob.study.domain.instructor.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RegTestDTO {
    private Integer courseId;
    private Integer period;
    private String title;
    private List<TestDetailVO> questions;
    private Integer status; //  (0: 임시저장, 1: 출제완료)
  private String date; // ★ 이 필드가 추가되어야 합니다!
  private String courseName; // ⭐ 과정명 (추가!)

}
