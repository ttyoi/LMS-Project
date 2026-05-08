package kr.happyjob.study.domain.instructor.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ITestCourseListDTO {
    private Integer course_id;
    private String title;
  private String courseName; // ⭐ 과정명 (추가!)


}
