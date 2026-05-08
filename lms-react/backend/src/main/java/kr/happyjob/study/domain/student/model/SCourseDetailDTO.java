package kr.happyjob.study.domain.student.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.util.Date;


@Data
public class SCourseDetailDTO {
    private Long course_id;
    private String title;

    @JsonFormat(shape =  JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date start_date;
    @JsonFormat(shape =  JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date end_date;
    private int time_code;

    private String content;
    private String notice;
    private String plan;
    private String professor;
    private String sub_prof;
    private String start_time;
    private String end_time;
    private String class_name;
    private int people_limit;

    private int stu_num;



    /**
     * 수강가능 여부 판단 변수
     */
    private String enrollable;

    /**
     * 프론트엔드용 수강신청 상태 메시지
     */
    private String apply_status;

    // 상세한 상태 정보를 위한 필드 추가
    private boolean isCapacityFull;
    private boolean isEnrollDeadlinePassed;
}
