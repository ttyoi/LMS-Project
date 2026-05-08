package kr.happyjob.study.domain.admin.model;

import lombok.Data;

import java.util.Date;

@Data
public class AResumeVO {
    private Long resume_id;
    private String loginID;
    private String name;
    private String logical_path;
    private String physical_path;
    private String extension; // extends 안됨
    private Integer size;
    private Date create_at;
}
