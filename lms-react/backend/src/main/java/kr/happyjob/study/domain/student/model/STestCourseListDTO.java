package kr.happyjob.study.domain.student.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class STestCourseListDTO {
    private Long course_id;
    private String title;
}
