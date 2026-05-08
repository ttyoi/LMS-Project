package kr.happyjob.study.domain.student.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class SMypageUpdateDTO {

    private String loginID;

    private String phone;
    private String email;
    private String birthday;
    private String zipcode;
    private String addr1;
    private String addr2;

    private String imgName;
    private String imgLogiPath;
    private String imgPhyPath;
}
