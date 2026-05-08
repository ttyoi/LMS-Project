package kr.happyjob.study.domain.common.model;

public class InstructorVO {
	private String loginID // 사용자ID
	, name // 이름
	, zipcode // 우편번호
	, addr1 // 주소1
	, addr2 // 주소2
	, birthday // 생일
	, phone // 핸드폰
	, email // 이메일
	, edu_level // 학력
	, career // 경력사항
	, img_name // 이미지명
	, img_logi_path // 이미지절대경로(논리경로)
	, img_phy_path // 이미지상대경로(물리경로)
	, reg_date // 등록일
	, ret_date // 탈퇴일
	, status; // 사용자상태구분

	public String getLoginID() {
		return loginID;
	}

	public void setLoginID(String loginID) {
		this.loginID = loginID;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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

	public String getReg_date() {
		return reg_date;
	}

	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}

	public String getRet_date() {
		return ret_date;
	}

	public void setRet_date(String ret_date) {
		this.ret_date = ret_date;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
}
