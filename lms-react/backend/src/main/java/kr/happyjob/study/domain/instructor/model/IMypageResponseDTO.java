package kr.happyjob.study.domain.instructor.model;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class IMypageResponseDTO {
    private String loginID;
    private String name;
    private String phone;
    private String email;
    private String birthday;
    private String userType;

    private String zipcode;
    private String addr1;
    private String addr2;

    private String imgName;
    private String imgLogiPath;
    private String imgPhyPath;

    private String eduLevel;   // 학력사항
    private String career;     // 경력사항

    private String chkTemPassword;
    }

