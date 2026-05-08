package kr.happyjob.study.domain.instructor.model;

import kr.happyjob.study.domain.homework.model.HomeworkFileVO;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class IHomeworkVO {

    // === 실제 DB 컬럼 ===
    private int homework_code;
    private String title;
    private String content;
    private String start_date;
    private String end_date;
    private String status;
  private String appeal_content;
  private String appeal_reply;
    // FK
    private int course_id;
    private String loginID;


    // === DB에는 없지만 화면에 필요한 값 ===
    private String course_name;   // 추가!
    private String teacher;     // JOIN 값 or 추가 로직
    private String teacher_name;  // 강사 이름 (옵션)

    // === ★ 첨부파일 목록 추가 (중요) ===
    private List<HomeworkFileVO> fileList;
  private Integer file_id;
    }

