package kr.happyjob.study.domain.student.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MypagePasswordChangeParamDTO {
    private String loginID;
    private String oldPw;
    private String newPw;
}
