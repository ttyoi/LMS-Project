package kr.happyjob.study.domain.student.model;

import lombok.Data;

import java.time.LocalDate;
import java.util.Date;

@Data
public class SEnrollCheckDTO {
    private Long course_id;
    private Date start_date;
    private Date end_date;
    private int time_code;

}
