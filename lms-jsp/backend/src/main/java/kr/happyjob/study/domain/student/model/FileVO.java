package kr.happyjob.study.domain.student.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FileVO {
    private Long file_id;
    private int Size;
    private String name;
    private String logical_path;
    private String physical_path;
    private String type;  // 확장자
}
