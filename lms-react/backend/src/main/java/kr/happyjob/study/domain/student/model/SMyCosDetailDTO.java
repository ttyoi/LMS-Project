package kr.happyjob.study.domain.student.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.util.Date;

@Data
public class SMyCosDetailDTO {
    private Long course_id;
    private String title;
    private String professior;
    private String sub_prof;
    private String class_name;
    private String phone;
    private String email;
    private String stu_cou_sta_name;

    @JsonFormat(shape =  JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date  start_date;
    @JsonFormat(shape =  JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date  end_date;

    private int time_code;
    private String start_time;
    private String end_time;
    private String plan;

    private int attendance;
    private int absen_sick;
    private int tard_levEarly;

    private String content;
    private String notice;

    /**
     * 수강 가능 여부
     */
    private String enrollable;

    private int stu_num;
    private int people_limit;
}
