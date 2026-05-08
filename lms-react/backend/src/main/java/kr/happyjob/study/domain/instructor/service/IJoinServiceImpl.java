package kr.happyjob.study.domain.instructor.service;

import kr.happyjob.study.common.comnUtils.MypageFileUtil;
import kr.happyjob.study.domain.instructor.dao.IJoinDAO;
import kr.happyjob.study.domain.instructor.model.FileVO;
import kr.happyjob.study.domain.login.service.FindService;
import kr.happyjob.study.domain.login.service.SendMailService;
import kr.happyjob.study.domain.student.model.UserInfoVO;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
public class IJoinServiceImpl implements IJoinService{

	Logger logger = LogManager.getLogger(this.getClass());

	@Autowired
	private IJoinDAO iJoinDAO;

	@Autowired
	private FindService findService;

	@Autowired
	private SendMailService sendMailService;

	@Value("${file.upload.physical-profile-path}")
	private String phyProfilePath;

	@Value("${file.upload.logical-profile}")
	private String logiProfilePath;

	/**
	 * 강사 random 아이디 만들기
	 * @return String (happyjob_6자리 랜덤 숫자)
	 */
	public String makeInstructorID(){
		boolean loopFlag=true;
		String makedIDStr = makeRandomID();

		while(loopFlag){
			if(chkDuplicateID(makedIDStr)==0){
				//이 아이디를 써야함.
				loopFlag=false;
			}else{
				continue;
			}//end if~else
		}//end while

		return makedIDStr;
	}//end makeInstructorID


	/**
	 * 강사 등록을 하기 위해 이메일 보내기 -- react 프론트를 위해 주석처리
	 * @return
	 */
//	public String sendMailForRegisterInstructor(String id, String email){
//		//DB에 아이디, (임시)비밀번호, 이메일 저장
//		String tempPWStr = findService.makeTempPassword(10);
//
//		Map<String, String> instructorInfo = new HashMap<>();
//		instructorInfo.put("id", id);
//		instructorInfo.put("password",tempPWStr);
//		instructorInfo.put("email",email);
//
//		int result = 0;
//		String resultStr="강사 등록에 실패했습니다.\n관리자에게 문의해주세요.";
//
//		try {
//			result = iJoinDAO.insertRegisterInstructor(instructorInfo);
//
//			if(result == 1){
//				String emailTempleteStr = sendMailService.loadHTMLMailTemplate("mailTemplate/registerEmail.html");
//				String ipStr=getPrivateIp();
//
//				if(ipStr == null){
//					resultStr="인터넷 연결이 불확실합니다.\n인터넷 연결을 확인해주세요.";
//				}else{
//					emailTempleteStr=emailTempleteStr.replace("{{REGISTER_URL}}",ipStr);
//					//[회원가입]링크가 포함된 이메일 보내기
//					sendMailService.sendEmail(email, "강사 회원가입", emailTempleteStr);
//					resultStr="강사를 등록했습니다.\n강사에게 아이디 : ["+id+"]와 임시비밀번호 : ["+tempPWStr+"]을 알려주세요.";
//				}//end if~else
//
//			}//end if
//		}catch(Exception e){
//			e.printStackTrace();
//		}//end try~catch
//
//		return resultStr;
//	}//end sendMailForRegisterInstructor

	/**
	 * @param id
	 * @param email
	 * @return
	 */
	public String sendMailForRegisterInstructor(String id, String email){
		//DB에 아이디, (임시)비밀번호, 이메일 저장
		String tempPWStr = findService.makeTempPassword(10);

		Map<String, String> instructorInfo = new HashMap<>();
		instructorInfo.put("id", id);
		instructorInfo.put("password",tempPWStr);
		instructorInfo.put("email",email);

		int result = 0;
		String resultStr="강사 등록에 실패했습니다.\n관리자에게 문의해주세요.";

		try {
			result = iJoinDAO.insertRegisterInstructor(instructorInfo);

			if(result == 1){
				String emailTempleteStr = sendMailService.loadHTMLMailTemplate("mailTemplate/registerEmail.html");
				String encodedId = URLEncoder.encode(id, StandardCharsets.UTF_8);
				String frontendUrl = "http://localhost:3000/register?type=instructor&id=" + encodedId;

				emailTempleteStr=emailTempleteStr.replace("{{REGISTER_URL}}",frontendUrl);
				//[회원가입]링크가 포함된 이메일 보내기
				sendMailService.sendEmailAsync(email, "강사 회원가입", emailTempleteStr);
				resultStr="강사를 등록했습니다.\n회원가입 링크를 이메일로 발송했습니다.";

			}//end if
		}catch(Exception e){
			e.printStackTrace();
		}//end try~catch

		return resultStr;
	}//end sendMailForRegisterInstructor


	/**
	 * 아이디 비밀번호 체크!
	 * @param id
	 * @param password
	 * @return
	 */
	public int checkIDAndPassword(String id, String password){
		Map<String, String> loginInfo = new HashMap<>();
		loginInfo.put("id",id);
		loginInfo.put("password",password);

		return iJoinDAO.chkInstructorIdAndPassword(loginInfo);
	}//end checkIDAndPassword


	/**
	 * 기본 이미지 가져오기
	 * @return
	 */
	public ResponseEntity<Resource> getDefaultImg(){
		String default_photo_path_str="\\\\192.168.0.89\\sharefolder\\LMSProject\\profile\\default_img.png";
		return getImg(default_photo_path_str);
	}//end getDefaultImg


	/**
	 * 아이디 가지고 이메일 가져오기
	 * status = 'W' user_type='I'
	 * @return email String
	 */
	public String getEmailById(String loginID){
		return iJoinDAO.selectEmailById(loginID);
	}//end getEmailById

	/**
	 * (강사 초기 등록) 강사 정보 등록 창에서 정보 등록
	 * @param file
	 * @param uVO
	 * @return int 강사 정보 update 성공 : 1 return
	 */
	public int registerInstructor(MultipartFile file, UserInfoVO uVO){
		FileVO fileVO;
		try{
			fileVO = uploadFileProcess(file, uVO.getLoginID());
			if (fileVO != null) {
				uVO.setImg_name(fileVO.getName());
				uVO.setImg_logi_path(fileVO.getLogical_path());
				uVO.setImg_phy_path(fileVO.getPhysical_path());
			}

		}catch(Exception e){
			e.printStackTrace();
		}//end try~catch
		if (uVO.getBirth1() != null && uVO.getBirth2() != null) {
			uVO.setBirthday(uVO.getBirth1()+uVO.getBirth2());
		}
		if (uVO.getPhone1() != null && !uVO.getPhone1().isEmpty()) {
			uVO.setPhone(uVO.getPhone1()+"-"+uVO.getPhone2()+"-"+uVO.getPhone3());
		}//end if

		return iJoinDAO.updateInstructorInfo(uVO);
	}//end registerInstructor

	/**
	 * 파일 업로드 기능
	 * @param file
	 * @return FileVO (name, logical_path, physical_path 사용)
	 */
	private FileVO uploadFileProcess(MultipartFile file, String loginId) throws Exception{
		FileVO fileVO = new FileVO();

		if(file == null || file.isEmpty()) return null;

		String originalFileName = file.getOriginalFilename();
		String ext = originalFileName.substring(originalFileName.lastIndexOf("."));

		String savedName = (loginId == null ? "" : loginId + "_") + UUID.randomUUID() + ext;
		String basePath = phyProfilePath;
		String physicalPath = basePath + savedName;

		MypageFileUtil.save(file, physicalPath);

		String logiPath = logiProfilePath.startsWith("/") ? logiProfilePath : "/" + logiProfilePath;

		fileVO.setName(savedName);
		fileVO.setType(ext);
		fileVO.setLogical_path(logiPath);
		fileVO.setPhysical_path(basePath);

		return fileVO;
	}//end uploadFileProcess
/* ---------------------------------------------------------------------  */

	/**
	 * 랜덤 아이디 생성 (happyjob_6자리 랜덤 숫자)
	 * @return
	 */
	private String makeRandomID(){
		String pre_idStr="happyjob_";
		int randomNum=0;
		String randomNumStr=null;

		boolean loopFlag = true;


		StringBuilder sb=new StringBuilder();

		while(loopFlag) {
			randomNum = (int) ((Math.random()) * 1000000);
			randomNumStr = randomNum + "";

			if (randomNumStr.length() != 6) {
				continue;
			}else{
				loopFlag=false;
			}
		}//end while

		return pre_idStr+randomNumStr;
	}//end makeInstructorID

	/**
	 * 중복된 아이디가 있는지 확인
	 * @return
	 */
	private int chkDuplicateID(String id){
		return iJoinDAO.selectInstrucDuplicateIDCnt(id);
	}//end chkDuplicateID


	/**
	 * 지금 내 컴퓨터가 사용하고 있는 사설 IP 가져오기
	 * @return String 사설 IP
	 */
	private String getPrivateIp() {
		try {
			Enumeration<NetworkInterface> nics = NetworkInterface.getNetworkInterfaces();
			while (nics.hasMoreElements()) {
				NetworkInterface ni = nics.nextElement();

				// 비활성화된 NIC, 루프백(127.0.0.1) 제외
				if (!ni.isUp() || ni.isLoopback() || ni.isVirtual()) continue;

				Enumeration<InetAddress> addrs = ni.getInetAddresses();
				while (addrs.hasMoreElements()) {
					InetAddress addr = addrs.nextElement();

					// IPv4만 선택
					if (addr instanceof Inet4Address) {

						String ip = addr.getHostAddress();

						// 사설 IP 범위인지 체크
						if (ip.startsWith("192.168.") || ip.startsWith("10.") || ip.startsWith("172.16.")) {
							return ip; // 사설 IPv4 반환
						}//end if
					}//end if
				}//end while
			}//end while
		} catch (Exception e) {
			e.printStackTrace();
		}//end try~catch
		return null;
	}//end getPrivateIp


	/**
	 * 사진 가져오기
	 * @param imgPhysicalPathStr String 사진 경로
	 * @return ResponseEntity<Resource>
	 */
	private ResponseEntity<Resource> getImg(String imgPhysicalPathStr){
		Path photo_path = Paths.get(imgPhysicalPathStr);

		if(!Files.exists(photo_path)){
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
		}//end if

		Resource resource = null;
		String contentType;
		
		try{
			resource = new UrlResource(photo_path.toUri());
			contentType=Files.probeContentType(photo_path);
			if(contentType==null) contentType="application/octet-stream";
		}catch(IOException e){
			contentType="application/octet-stream";
		}//end try~catch

		return ResponseEntity.ok()
				.contentType(MediaType.parseMediaType(contentType))
				.body(resource);
	}//end getImg


}//end class
