package kr.happyjob.study.domain.student.model;

import lombok.Data;

import java.time.LocalDate;

@Data
public class SCourseListDTO {
    private Long course_id;
    private String title;
    private String name;
    private String start_time;
    private String end_time;
    private String class_name;
    private int people_limit;
    private int stu_num;

    private LocalDate start_date;
    private LocalDate end_date;
    private int cos_sta_code;
    private Long class_id;
    private int time_code;

    /** 수강신청 상태 (신청 가능, 신청 완료, 정원 초과 등) */
    private String apply_status;

    // 상세한 상태 정보를 위한 필드 추가
    private boolean isCapacityFull;
    private boolean isEnrollDeadlinePassed;

  public void setEnrollable(String enrollableStatus) {
  }
}
