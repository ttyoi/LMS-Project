package kr.happyjob.study.domain.admin.model.courseManagement;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
@Setter
@Getter
public class CourseManagement {
    // Getter & Setter
    private int course_id;           // course_id
    private String title;           // 강의명
    private String professor;       // 강사
    private String name;
    private String subName;
    private int class_id;           // 강의실 (201호 등)
    private String class_name;   // 여기에 추가
    private String start_date;       // 개강일
    private String end_date;         // 종강일
    private String cos_sta_code;      // 강의신청상태코드 (0=요청중, null=수락, 1=거절)
    private String content;        // 수업내용
    private String notice;         // 강의 공지사항
    private String plan;           // 강의 계획
    private String sub_prof;        // 보조강사명
    private int time_code;       // 시간
    private String start_time;
    private String end_time;
    private int status;


    // 생성자
    public CourseManagement() {
    }

    public CourseManagement(int course_id, String title, String professor,
                            int class_id, String class_name, String start_date,
                            String end_date, String cos_sta_code) {
        this.course_id = course_id;
        this.title = title;
        this.professor = professor;
        this.class_id = class_id;
        this.class_name = class_name;
        this.start_date = start_date;
        this.end_date = end_date;
        this.cos_sta_code = cos_sta_code;
    }

    @Override
    public String toString() {
        return "CourseManagement{" +
                "course_id=" + course_id +
                ", title='" + title + '\'' +
                ", professor='" + professor + '\'' +
                ", class_id=" + class_id +
                ", class_name='" + class_name + '\'' +
                ", start_date='" + start_date + '\'' +
                ", end_date='" + end_date + '\'' +
                ", cos_sta_code='" + cos_sta_code + '\'' +
                '}';
    }


}
