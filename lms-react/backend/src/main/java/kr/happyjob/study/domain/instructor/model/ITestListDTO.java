package kr.happyjob.study.domain.instructor.model;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ITestListDTO {
    private String title;
    private Integer courseId;
    private int period;
    private String studentId; //학생의 ID정보 (점수계산용)
    private String name; // 학생이름
    private Date date; // nullable
    private Integer score; // nullable
    private String loginId; //해당 과목의 담당교수 or 부교수
    private String courseName;
    private Integer status;
    private String startDate; // 응시 시작일
    private String endDate;   // 응시 종료일

}

