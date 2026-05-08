package kr.happyjob.study.domain.student.model;

import lombok.Data;

@Data
public class SMyCourseListDTO {
    private Long course_id;
    private String title;
    private String name;
    private String class_name;
    private String start_time;
    private String end_time;
    private String scs_name;
    private String status;
    private String start_date;
    private String end_date;
    private Integer time_code;
}
