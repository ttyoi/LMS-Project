package kr.happyjob.study.domain.instructor.model;

import lombok.Data;

@Data
public class IMaterialSearchDTO {

    private String loginID;

    private int currentPage;

    private int pageSize;

    private Integer course_id;
    private int start;
    private int limit;

}
