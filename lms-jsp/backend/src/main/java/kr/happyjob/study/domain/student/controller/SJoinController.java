package kr.happyjob.study.domain.student.controller;

import kr.happyjob.study.domain.student.model.UserInfoVO;
import kr.happyjob.study.domain.student.service.SJoinService;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Map;

@Controller
public class SJoinController {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	@Autowired
	private SJoinService joinService;

	/**
	 * 회원가입 (학생)
	 * @return
	 */
	@RequestMapping("/join")
	public String joinMember(HttpServletResponse response){

		response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);

		return "student/join/joinMembership";
	}//end joinMember

	/**
	 * ID 중복 확인
	 * @param loginID
	 * @return int
	 */
	@RequestMapping("/join/checkDuplicateID")
	@ResponseBody
	public int checkDuplicateID(@RequestParam("loginID") String loginID){

		return joinService.checkDuplicateID(loginID);
	}//end checkDuplicateID

	/**
	 * 이메일 중복 확인
	 * @param email
	 * @return int
	 */
	@RequestMapping("/join/checkDuplicateEmail")
	@ResponseBody
	public int checkDuplicateEmail(@RequestParam("email") String email){
		return joinService.checkDuplicateEmail(email);
	}//end checkDuplicateEmail

	/**
	 * 학생 회원가입 약관 가져오기.
	 * @param checkboxID
	 * @return
	 */
	@RequestMapping("/join/getUserPolicy")
	@ResponseBody
	public Map<String, String> getUserPolicy(@RequestParam("checkboxID") String checkboxID){
		return joinService.getUserPolicy(checkboxID);
	}//end getUserPolicy


	/**
	 * 학생 회원가입
	 * @param uim
	 * @return
	 */
	@RequestMapping("/join/registerStudent")
	public String registerStudent(UserInfoVO uim, RedirectAttributes redirectModel){
		int resultInt = joinService.registerStudent(uim);

		if(resultInt == 1){
			redirectModel.addFlashAttribute("successMsg","회원가입을 완료했습니다.");
			return "redirect:/login.do";
		}else{
			redirectModel.addFlashAttribute("errorMsg","회원가입에 실패했습니다.");
			return "redirect:/join";
		}//end if~else

	}//end registerStudent



}//end class
