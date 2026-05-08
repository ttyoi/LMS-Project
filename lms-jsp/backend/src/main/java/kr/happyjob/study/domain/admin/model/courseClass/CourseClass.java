package kr.happyjob.study.domain.admin.model.courseClass;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class CourseClass {

    // getter / setter
    private long class_id;        // BIGINT → long
    private String title;
    private String class_name;    // varchar(255) → String
    private int people_limit;     // int → int
    private int status;          // int → int (예: 1=활성, 0=비활성화)

    // 추가 필드
    private int time_code;
    private String start_time;
    private String end_time;

    private long course_id;
    private String course_title;
    private String start_date;
    private String end_date;

    private String professor;
    private String sub_professor;
    private String name;


    // 기본 생성자
    public CourseClass() {}

}
