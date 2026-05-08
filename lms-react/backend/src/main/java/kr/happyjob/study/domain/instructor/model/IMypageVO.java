package kr.happyjob.study.domain.instructor.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class IMypageVO {

    private String loginID;
    private String userType; // S(학생), I(강사), A(관리자)
    private String name;
    private String phone;
    private String email;
    private String birthday;
    private String imgName;
    private String imgLogiPath;
    private String imgPhyPath;

    private String zipcode;
    private String addr1;
    private String addr2;

    private String chkTemPassword;
}
