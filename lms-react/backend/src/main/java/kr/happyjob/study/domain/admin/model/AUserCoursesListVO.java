package kr.happyjob.study.domain.admin.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.util.Date;

@Data
public class AUserCoursesListVO {

    // 테이블 - course
    private Long course_id; // 강의 아이디 course
    private String title; // 강의명 course
    private String name; // 담당교수 - tb_userinfo와 course테이블의 proffessor_id의 id일치하는거 가져오기
    //테이블 - course_class
    private String class_name; // 강의실

    private Integer student_cnt; // 수강생 수(강사에서 쓸 것)
    // (수강상태) 테이블 : student_course_status 테이블에서  -> student_cou_sta_name를 찾기
    private String scs_name; // 강의 상태 (진행중, 종강)

    // 날짜
    @JsonFormat(shape =  JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date  start_date;
    @JsonFormat(shape =  JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date  end_date;

    // 강의 시간
    private String start_time;
    private String end_time;
    
}
