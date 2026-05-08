package kr.happyjob.study.domain.instructor.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class IUpdateEduCareerDTO {
    private String loginID;
    private String eduLevel;
    private String career;
}
