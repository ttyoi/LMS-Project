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
  private String date;
  private String courseName;
  private String startDate; // 응시 시작일
  private String endDate;   // 응시 종료일

}
