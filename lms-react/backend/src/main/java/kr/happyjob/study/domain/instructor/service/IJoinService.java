package kr.happyjob.study.domain.instructor.service;

import kr.happyjob.study.domain.student.model.UserInfoVO;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

public interface IJoinService {
	/*강사 ID 만들기*/
	public String makeInstructorID();

	/* 강사 등록을 위해, 이메일 보내기 */
	public String sendMailForRegisterInstructor(String id, String email);

	/* 아이디 비밀번호 체크 */
	public int checkIDAndPassword(String id, String password);
	/* 기본 이미지 가져오기 */
	public ResponseEntity<Resource> getDefaultImg();

	/* id 가지고 이메일 가져오기 */
	public String getEmailById(String loginID);
	public int registerInstructor(MultipartFile file, UserInfoVO userInfoVO);

}//end interface
