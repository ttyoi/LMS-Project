package kr.happyjob.study.domain.student.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class STestListDTO {
    private Long courseId;
    private String title;
    private int period;
    private Date date; // nullable
    private Integer score; // nullable
    private String loginId;
    private int status;
    private String courseName;
    private java.sql.Date startDate; // 응시 시작일
    private java.sql.Date endDate;   // 응시 종료일

}
