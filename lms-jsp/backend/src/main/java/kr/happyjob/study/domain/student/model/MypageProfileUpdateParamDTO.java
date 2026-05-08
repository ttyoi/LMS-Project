package kr.happyjob.study.domain.student.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MypageProfileUpdateParamDTO {
    private String loginID;
    private String imgName;
    private String imgLogiPath;
    private String imgPhyPath;
}
