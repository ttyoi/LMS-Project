package kr.happyjob.study.domain.student.model;

import lombok.Data;
import java.util.List;  // ★ 추가 필수
import java.util.Map;   // ★ 추가 필수

@Data
public class SHomeworkVO {

    // --- homework ---
    private int homework_code;
    private int course_id;
    private String course_name;
    private String homework_title;     // ★ 과제 제목 (title→homework_title로 통일)
    private String content;            // 과제 내용
    private String start_date;
    private String end_date;
    private String appeal_content;  // ★ 이의제기 내용을 담을 필드 추가
    private String appeal_reply;


  // --- teacher ---
    private String teacher_name;       // 강사 이름

    // --- submission ---
    private int submission_code;
    private String loginID;            // 학생 ID
    private String submit_date;
    private Integer file_id;

    // --- file ---
    private String file_name;
    private String file_path;


//    과제
    private Integer score;
    private String feedback;
    private Integer status;
    private String submissiondate;

    // ★ 이 부분을 추가하세요 ★
    private List<Map<String, Object>> fileList;

    // Getter
    public List<Map<String, Object>> getFileList() {
        return fileList;
    }

    // Setter (이 메서드가 있어야 서비스의 .setFileList 빨간줄이 사라집니다)
    public void setFileList(List<Map<String, Object>> fileList) {
        this.fileList = fileList;
    }
}
