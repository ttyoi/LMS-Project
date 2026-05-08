package kr.happyjob.study.domain.instructor.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class IMyCourseVO {

    private Long courseId;
    private String title;

    private String period;
    private String time;
    private String className;
    private Integer studentCount;
    private Integer peopleLimit;

}
