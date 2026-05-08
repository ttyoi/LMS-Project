package kr.happyjob.study.domain.student.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SMypageUserInfoResponseDTO {
    private String loginID;
    private String name;
    private String phone;
    private String email;
    private String birthday;
    private String userType;
    private String resumeName;
    private int resumeId;
    private String imgName;
    private String imgLogiPath;
    private String imgPhyPath;
    private String zipcode;
    private String addr1;
    private String addr2;

    private String chkTemPassword;

}
