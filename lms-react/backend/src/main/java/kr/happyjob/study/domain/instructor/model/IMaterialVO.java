package kr.happyjob.study.domain.instructor.model;

import lombok.Data;


@Data
public class IMaterialVO {
    private Long materials_id;
    private String title;
    private String course_title;
    private String content;
    private String register_date;
    private String update_date;
    private Long course_id;
    private Long file_id;
    private String file_name;
    private String logical_path;
}
