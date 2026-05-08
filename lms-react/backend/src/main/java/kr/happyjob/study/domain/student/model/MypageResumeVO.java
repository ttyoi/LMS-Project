package kr.happyjob.study.domain.student.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class MypageResumeVO {
    private Long resumeId;
    private String loginID;
    private String name;
    private String logicalPath;
    private String physicalPath;
    private String extend;
    private Long size;
}
