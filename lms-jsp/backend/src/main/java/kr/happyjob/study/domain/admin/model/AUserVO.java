package kr.happyjob.study.domain.admin.model;

import java.util.Date;

public class AUserVO {
    private String loginID;
    private String user_type;
    private String name;
    private String password;
    private char chk_tem_password;
    private String zipcode;
    private String addr1;
    private String addr2;
    private String birthday;
    private String phone;
    private String email;
    private String edu_level;
    private String career;
    private String img_name;
    private String img_logi_path;
    private String img_phy_path;
    private Date reg_date;
    private Date ret_date;
    private String status;
    private String logicalpath;

    public String getLoginID() {
        return loginID;
    }

    public void setLoginID(String loginID) {
        this.loginID = loginID;
    }

    public String getUser_type() {
        return user_type;
    }

    public void setUser_type(String user_type) {
        this.user_type = user_type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public char getChk_tem_password() {
        return chk_tem_password;
    }

    public void setChk_tem_password(char chk_tem_password) {
        this.chk_tem_password = chk_tem_password;
    }

    public String getZipcode() {
        return zipcode;
    }

    public void setZipcode(String zipcode) {
        this.zipcode = zipcode;
    }

    public String getAddr1() {
        return addr1;
    }

    public void setAddr1(String addr1) {
        this.addr1 = addr1;
    }

    public String getAddr2() {
        return addr2;
    }

    public void setAddr2(String addr2) {
        this.addr2 = addr2;
    }

    public String getBirthday() {
        return birthday;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getEdu_level() {
        return edu_level;
    }

    public void setEdu_level(String edu_level) {
        this.edu_level = edu_level;
    }

    public String getCareer() {
        return career;
    }

    public void setCareer(String career) {
        this.career = career;
    }

    public String getImg_name() {
        return img_name;
    }

    public void setImg_name(String img_name) {
        this.img_name = img_name;
    }

    public String getImg_logi_path() {
        return img_logi_path;
    }

    public void setImg_logi_path(String img_logi_path) {
        this.img_logi_path = img_logi_path;
    }

    public String getImg_phy_path() {
        return img_phy_path;
    }

    public void setImg_phy_path(String img_phy_path) {
        this.img_phy_path = img_phy_path;
    }

    public Date getReg_date() {
        return reg_date;
    }

    public void setReg_date(Date reg_date) {
        this.reg_date = reg_date;
    }

    public Date getRet_date() {
        return ret_date;
    }

    public void setRet_date(Date ret_date) {
        this.ret_date = ret_date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getLogicalpath() {
        return logicalpath;
    }

    public void setLogicalpath(String logicalpath) {
        this.logicalpath = logicalpath;
    }
}
