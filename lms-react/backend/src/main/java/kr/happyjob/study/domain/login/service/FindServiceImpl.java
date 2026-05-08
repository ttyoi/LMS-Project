package kr.happyjob.study.domain.login.service;

import kr.happyjob.study.domain.login.dao.FindDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.util.HtmlUtils;

import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;

@Service
public class FindServiceImpl implements FindService{

	@Autowired
	private FindDAO findDAO;

	@Autowired
	private SendMailService sendMail;



	/**
	 * 이메일과 matching되는 id 찾기
	 * @param email
	 * @return retStr
	 */
	public String getIDbyEmail(String email){
		String id = findDAO.selectIDbyEmail(email);
		String retStr = "일치하는 이메일이 없습니다.";

		if(id != null){
			retStr="해당 이메일에 일치하는 id는 ["+id+"]입니다.";
		}//end if

		return retStr;
	}//end getIDbyEmail

	/**
	 * 비밀번호 찾기 클릭하면, 정보 있는지 확인 후,
	 * 해당 정보가 존재하지 않으면, 돌려보내고,
	 * 해당 정보가 있다면, 이메일로 임시 비밀번호 발급.
	 * @param id
	 * @param email
	 * @return retStr
	 */
	@Transactional
	public String requestSearchPassword(String id, String email){
		String retStr = "일치하는 정보가 없습니다.";
		Map<String,String> info = new HashMap<>();
		info.put("id",id);
		info.put("email",email);

		int retInt=findDAO.selectCntbyIDAEmail(info);

		if(retInt == 1) {
			//여기서 이메일 보내야함.
			try{
				String loadHTMLStr=sendMail.loadHTMLMailTemplate("mailTemplate/findPassword.html");
				String tmpPW = makeTempPassword(10);
				info.put("tmp_pw",tmpPW);
				String sendHTMLStr=loadHTMLStr.replace("{{TEMP_PW}}", HtmlUtils.htmlEscape(tmpPW));
				//여기서 {{TEMP_PW}} 문자열을 실제 임시비밀번호로 replace 해야함.
				//근데 아마 replaceAll을 해야하지 않나? replace가 아니라

				if(findDAO.updatePasswordByIDAEmail(info)==1){
					sendMail.sendEmailAsync(email,"임시비밀번호 발급",sendHTMLStr);
					retStr="해당 이메일로 임시 비밀번호를 발급했습니다.\n이메일을 확인해주세요.";
				}else{
					retStr="임시 비밀번호 발급이 불가합니다.\n다시 한번 시도해주세요.\n동일한 문제가 계속 발생할 경우 고객센터에 문의주세요.";
				}//end if~else

			}catch(Exception e){
				e.printStackTrace();
			}//end try~catch
		}//end if

		return retStr;
	}//end requestSearchPassword

	/* ============================================================================= */

	/**
	 * 임시 비밀번호 만들기
	 * @return
	 */
	public String makeTempPassword(int length){
		String chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
		StringBuilder sb=new StringBuilder();
		SecureRandom random=new SecureRandom();

		for(int i=0;i<length; i++){
			sb.append(chars.charAt(random.nextInt(chars.length())));
		}//end for

		return sb.toString();
	}//end makeTempPassword




}//end class
