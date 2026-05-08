package kr.happyjob.study.domain.admin.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ATestListVO {
    private int courseId;
    private String title; // 강의명
    private int period;
    private String professor; // 담당 강사 Id
    private String professorName; // 담당 강사명
    private int status;

}
