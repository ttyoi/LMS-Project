package kr.happyjob.study.domain.homework.model;

import lombok.Data;

@Data
public class HomeworkFileVO {
  private int file_id;          // 파일 PK
  private String name;          // 원본 파일명 (예: 과제제출.zip)
  private String logical_path;   // 웹 접근 경로 (예: /assignments/uuid.zip)
  private String physical_path;  // 실제 서버 저장 경로
  private int file_size;        // 파일 크기 (바이트 단위)
  private String extension;      // 파일 확장자 (pdf, zip 등)
  private String type;           // 구분 (HW: 강사과제, SUB: 학생제출)
}
