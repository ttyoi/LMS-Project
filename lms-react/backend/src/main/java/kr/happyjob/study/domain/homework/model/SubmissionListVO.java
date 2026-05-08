package kr.happyjob.study.domain.homework.model;


import lombok.Data;

@Data
public class SubmissionListVO {
    private int submission_code;
    private int homework_code;
    private String start_date;
    private String end_date;
    private String student_id;
    private String student_name;
  private String appeal_content; // ★ 이 필드가 있어야 MyBatis가 데이터를 담아줍니다.
  private String appeal_reply; // 이 필드가 있고, Lombok이 작동해야 함
    private String submit_date;
    private Integer score;
    private String feedback;

    private String homework_title;
    private String course_name;

    private Long file_id;
    private String file_name;

    private String status;

}
