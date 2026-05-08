package kr.happyjob.study.domain.student.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MypageResumeInsertParamDTO {
    private String loginID;
    private String name;
    private String logicalPath;
    private String physicalPath;
    private String extend;
    private long size;
}
