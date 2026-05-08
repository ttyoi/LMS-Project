package kr.happyjob.study.domain.student.model;

public class UserInfoVO {
	private String loginID;
	private String user_type;
	private String name;

	private String password;

	private String zipcode;
	private String addr1;
	private String addr2;

	private String birth1;
	private String birth2;
	private String birthday;

	private String phone1;
	private String phone2;
	private String phone3;
	private String phone;

	private String emailFront;
	private String emailDomain;
	private String email;
	private String edu_level;
	private String career;

	private String status;

	private String img_name;
	private String img_logi_path;
	private String img_phy_path;

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

	public String getBirth1() {
		return birth1;
	}

	public void setBirth1(String birth1) {
		this.birth1 = birth1;
	}

	public String getBirth2() {
		return birth2;
	}

	public void setBirth2(String birth2) {
		this.birth2 = birth2;
	}

	public String getBirthday() {
		return birthday;
	}

	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}

	public String getPhone1() {
		return phone1;
	}

	public void setPhone1(String phone1) {
		this.phone1 = phone1;
	}

	public String getPhone2() {
		return phone2;
	}

	public void setPhone2(String phone2) {
		this.phone2 = phone2;
	}

	public String getPhone3() {
		return phone3;
	}

	public void setPhone3(String phone3) {
		this.phone3 = phone3;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmailFront() {
		return emailFront;
	}

	public void setEmailFront(String emailFront) {
		this.emailFront = emailFront;
	}

	public String getEmailDomain() {
		return emailDomain;
	}

	public void setEmailDomain(String emailDomain) {
		this.emailDomain = emailDomain;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getImg_phy_path() {
		return img_phy_path;
	}

	public void setImg_phy_path(String img_phy_path) {
		this.img_phy_path = img_phy_path;
	}

	public String getImg_logi_path() {
		return img_logi_path;
	}

	public void setImg_logi_path(String img_logi_path) {
		this.img_logi_path = img_logi_path;
	}

	public String getImg_name() {
		return img_name;
	}

	public void setImg_name(String img_name) {
		this.img_name = img_name;
	}


	@Override
	public String toString() {
		return "UserInfoVO{" +
				"loginID='" + loginID + '\'' +
				", user_type='" + user_type + '\'' +
				", name='" + name + '\'' +
				", password='" + password + '\'' +
				", zipcode='" + zipcode + '\'' +
				", addr1='" + addr1 + '\'' +
				", addr2='" + addr2 + '\'' +
				", birth1='" + birth1 + '\'' +
				", birth2='" + birth2 + '\'' +
				", birthday='" + birthday + '\'' +
				", phone1='" + phone1 + '\'' +
				", phone2='" + phone2 + '\'' +
				", phone3='" + phone3 + '\'' +
				", phone='" + phone + '\'' +
				", emailFront='" + emailFront + '\'' +
				", emailDomain='" + emailDomain + '\'' +
				", email='" + email + '\'' +
				", edu_level='" + edu_level + '\'' +
				", career='" + career + '\'' +
				", status='" + status + '\'' +
				", img_name='" + img_name + '\'' +
				", img_logi_path='" + img_logi_path + '\'' +
				", img_phy_path='" + img_phy_path + '\'' +
				'}';
	}
}//end class
