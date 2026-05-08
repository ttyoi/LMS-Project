package kr.happyjob.study.domain.student.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.util.Date;

@Data
public class SMyCourseListDTO {
    private Long course_id;
    private String title;
    private String name;
    private String class_name;
    private String scs_name;
    private int time_code;
    private String start_time;
    private String end_time;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date start_date;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date end_date;
}