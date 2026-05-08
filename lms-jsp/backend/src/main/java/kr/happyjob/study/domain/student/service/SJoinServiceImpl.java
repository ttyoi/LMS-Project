package kr.happyjob.study.domain.student.service;

import kr.happyjob.study.domain.login.dao.LoginDao;
import kr.happyjob.study.domain.student.dao.SJoinDAO;
import kr.happyjob.study.domain.student.model.UserInfoVO;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

@Service
public class SJoinServiceImpl implements  SJoinService{
	//로그 확인
	private final Logger logger = LogManager.getLogger(this.getClass());

	@Autowired
	private SJoinDAO joinDAO;

	/**
	 * 아이디 중복 체크
	 * @param loginID
	 * @return int
	 */
	public int checkDuplicateID(String loginID){
		return joinDAO.checkDuplicateID(loginID);
	}//end checkDuplicateID


	/**
	 * 이메일 중복 체크
	 * @param email
	 * @return int
	 */
	public int checkDuplicateEmail(String email){
		return joinDAO.checkDuplicateEmail(email);
	}//end checkDuplicateEmail


	/**
	 * 약관 제목, 약관 내용 가져오기
	 * @param checkboxID 체크박스 아이디
	 * @return Map<String, String>
	 */
	public Map<String, String> getUserPolicy(String checkboxID){
		Map<String, String> retPolicyMap = new HashMap<>();

		if("termsChk".equals(checkboxID)){
			retPolicyMap = getUserPolicyOne();
		}else{
			retPolicyMap = getUserPolicyTwo();
		}//end if~else

		return retPolicyMap;
	}//end getUserPolicy


	/**
	 * 학생 회원가입
	 * - 생년월일,이메일, 핸드폰 번호 데이터 조립 필요!
	 * @param uim
	 * @return
	 */
	public int registerStudent(UserInfoVO uim){

		uim.setBirthday(uim.getBirth1()+uim.getBirth2());

		if(!uim.getPhone1().isEmpty()){
			uim.setPhone(uim.getPhone1()+"-"+uim.getPhone2()+"-"+uim.getPhone3());
		}//end if

		uim.setEmail(uim.getEmailFront()+"@"+uim.getEmailDomain());
		return joinDAO.insertStudentInfo(uim);
	}//end registerStudent
	/*  ******************************************************************** */

	/**
	 * 첫번째 약관 가져오기
	 * @return Map<String, String>
	 */
	private Map<String, String> getUserPolicyOne(){
		String policyPathStr="\\\\192.168.0.89\\sharefolder\\LMSProject\\policy\\HappyJobPolicy1.txt";
		String title="HappyJob LMS 이용약관";

		Map<String, String> retPolicy = new HashMap<>();
		retPolicy.put("title",title);
		retPolicy.put("content",readPolicy(policyPathStr));

		return retPolicy;
	}//end getUserPolicyOne

	/**
	 * 두번째 약관 가져오기
	 * @return Map<String, String>
	 */
	private Map<String, String> getUserPolicyTwo(){
		String policyPathStr="\\\\192.168.0.89\\sharefolder\\LMSProject\\policy\\HappyJobPolicy2.txt";
		String title="개인정보 수집 및 이용 동의 (HappyJob LMS)";

		Map<String, String> retPolicy=new HashMap<>();
		retPolicy.put("title",title);
		retPolicy.put("content",readPolicy(policyPathStr));

		return retPolicy;
	}//end getUserPolicyTwo


	/**
	 * 파일 가져오기
	 * @param policyPathStr String
	 * @return
	 */
	private String readPolicy(String policyPathStr){
		Path policyPath = Paths.get(policyPathStr);

		try {
			if (!Files.exists(policyPath)) {
				logger.error("파일없음" + policyPath);
				return null;
			}//end if

			return new String(Files.readAllBytes(policyPath), StandardCharsets.UTF_8);
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}//end try~catch
	}//end getPolicy
}//end class
