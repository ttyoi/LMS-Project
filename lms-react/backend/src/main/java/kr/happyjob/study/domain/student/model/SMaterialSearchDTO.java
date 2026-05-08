package kr.happyjob.study.domain.student.model;

import lombok.Data;

@Data
public class SMaterialSearchDTO {
    private String loginID;
    private int currentPage;
    private int pageSize;
    private Integer course_id;
    private int start;
    private int limit;
}
