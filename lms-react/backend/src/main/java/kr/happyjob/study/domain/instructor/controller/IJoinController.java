package kr.happyjob.study.domain.instructor.controller;


import kr.happyjob.study.domain.instructor.service.IJoinService;
import kr.happyjob.study.domain.student.model.UserInfoVO;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;


@Controller
public class IJoinController {
	private final Logger logger= LogManager.getLogger(this.getClass());

	@Autowired
	private IJoinService iJoinService;

	/**
	 * 강사 ID 만들어서 제공
	 * @return happyjob_6자리랜덤숫자
	 */
	@RequestMapping("/inst/registerid")
	@ResponseBody
	public String makeRegisterID(){
		return iJoinService.makeInstructorID();
	}//end makeRegisterID

	/**
	 * 관리자 페이지에서 강사등록 버튼을 눌렀을 때.
	 * @param id
	 * @param email
	 * @return
	 */
	@RequestMapping("/inst/registerInstructor")
	@ResponseBody
	public ResponseEntity<String> registerInstructor(@RequestParam("id") String id, @RequestParam("email")String email){
		String resultStr = iJoinService.sendMailForRegisterInstructor(id, email);

		return ResponseEntity
				.ok()
				.header("Content-Type","text/plain; charset=UTF-8")
				.body(resultStr);
	}//end reigsterInstructor


	/**
	 * 강사 회원가입 전 로그인
	 * @return
	 */
	@RequestMapping("/inst/registerInstructorLogin")
	public String registerInstructorLogin(){
		return "instructor/iJoin/registerInstructorLogin";
	}//end registerInstructorLogin


	/**
	 * 강사 이메일에서 회원가입 버튼 누르면 나오는 로그인창
	 * @param id
	 * @param password
	 * @param redirect
	 * @param model
	 * @return
	 */@ResponseBody
	@RequestMapping("/inst/chkRegisterInstructorLogin")
	public Map<String, Object> chkRegisterInstructorLogin(@RequestParam("id") String id, @RequestParam("password") String password, RedirectAttributes redirect, Model model){
		int result=iJoinService.checkIDAndPassword(id,password);
		logger.info("id and password ===="+id+ "---"+password);
		
		Map<String,Object> response = new HashMap<>();
		if(result == 1){
//			redirect.addFlashAttribute("id",id);
//			return "redirect:/inst/registerInstructorInfo";
			response.put("email", iJoinService.getEmailById(id));
			response.put("result", "SUCCESS");
			return response;
		}else{
//			redirect.addFlashAttribute("msg","아이디 또는 비밀번호가 일치하지 않습니다.");
//			return "redirect:/inst/registerInstructorLogin";
			response.put("result", "FAIL");
			return response;
		}//end if~else
	}//end chkRegisterInstructorLogin

	/**
	 * 강사 회원가입 페이지 반환
	 * @return
	 */
	@RequestMapping("/inst/registerInstructorInfo")
	public String registerInstructorInfo(HttpServletResponse response, @ModelAttribute("id") String id, Model model){
		model.addAttribute("id",id);
		//여기서 사진 url도 넣어줍시다.
		model.addAttribute("photoUrl", "/inst/join/getDefaultImg");
		//강사 이메일
		model.addAttribute("email",iJoinService.getEmailById(id));

		response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);

		return "instructor/iJoin/registerInstructor";
	}//end registerInstructorInfo


	/**
	 * 기본 Default image 가져오기
	 * @return
	 */
	@RequestMapping("/inst/join/getDefaultImg")
	@ResponseBody
	public ResponseEntity<Resource> getDefaultImg(){
		return iJoinService.getDefaultImg();
	}//end getDefaultImg


	@RequestMapping("/inst/join/registerInstructor")
	public String registerInstructor(RedirectAttributes redirectModel, @RequestParam("profileImg")MultipartFile file, UserInfoVO userInfoVO){


		int resultInt=iJoinService.registerInstructor(file,userInfoVO);
		if(resultInt == 1){
			redirectModel.addFlashAttribute("successMsg","강사 정보 등록에 성공하였습니다. 로그인해주세요.");
			return "redirect:/login.do";
		}else{
			redirectModel.addFlashAttribute("errorMsg","강사 정보 등록에 실패하였습니다. 같은 증상이 반복될 경우 관리자에게 문의해주세요.");
			return "redirect:/inst/registerInstructorLogin";
		}//end if~else
	}//end registerInstructor

	/**
	 *   ----------------------------- 리액트용 전환 --------------------------------------
	 */

	/**
	 * 강사 ID 만들어서 제공
	 * @return happyjob_6자리랜덤숫자
	 */
	@RequestMapping("/api/inst/registerid")
	@ResponseBody
	public String makeRegisterIDReact(){
		return iJoinService.makeInstructorID();
	}//end makeRegisterID

	/**
	 * 관리자 페이지에서 강사등록 버튼을 눌렀을 때.
	 * @param id
	 * @param email
	 * @return
	 */
	@RequestMapping("/api/inst/registerInstructor")
	@ResponseBody
	public ResponseEntity<String> registerInstructorReact(@RequestParam("id") String id, @RequestParam("email")String email){
		String resultStr = iJoinService.sendMailForRegisterInstructor(id, email);

		return ResponseEntity
				.ok()
				.header("Content-Type","text/plain; charset=UTF-8")
				.body(resultStr);
	}//end reigsterInstructor

	@ResponseBody
	@RequestMapping("/api/inst/chkRegisterInstructorLogin")
	public ResponseEntity<Map<String,Object>> chkRegisterInstructorLoginReact(@RequestBody Map<String, String> paramMap){

		String id = paramMap.get("id");
		String password = paramMap.get("password");

		logger.info("ID: " + id);

		int result = iJoinService.checkIDAndPassword(id, password);

		Map<String,Object> response = new HashMap<>();

		if (result == 1){
			response.put("result", "SUCCESS");
			response.put("id",id);
			return  ResponseEntity.ok(response);
		} else {
			response.put("result", "FAIL");
			response.put("msg","아이디 또는 비밀번호가 일치하지 않습니다.");
			return ResponseEntity.ok(response);
		}
	}//end chkRegisterInstructorLogin

	/**
	 * 강사 회원가입 페이지 반환
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/api/inst/registerInstructorInfo")
	public ResponseEntity<Map<String, Object>> registerInstructorInfoReact(@RequestBody Map<String, String> paramMap){

		String id = paramMap.get("id");

		String email = iJoinService.getEmailById(id);
		Map<String,Object> response = new HashMap<>();

		if(email == null || email.trim().isEmpty()){
			response.put("result", "FAIL");
			response.put("msg", "강사 가입 정보를 찾을 수 없습니다.");
			return ResponseEntity.ok(response);
		}

		String photoUrl = "/inst/join/getDefaultImg";

		response.put("result", "SUCCESS");
		response.put("email",email);
		response.put("photoUrl",photoUrl);

		return ResponseEntity.ok(response);
	}//end registerInstructorInfo

	@PostMapping("/api/inst/join/registerInstructor")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> registerInstructorReact(
			@RequestParam(value = "profileImg", required = false)MultipartFile file,
			UserInfoVO userInfoVO
	){ 


		int resultInt=iJoinService.registerInstructor(file,userInfoVO);

		Map<String,Object> response = new HashMap<>();

		if(resultInt == 1){
			response.put("result", "SUCCESS");
			response.put("msg","강사 정보 등록에 성공하였습니다. 로그인해주세요.");
			return ResponseEntity.ok(response);
		}else{
			response.put("result", "FAIL");
			response.put("msg","강사 정보 등록에 실패하였습니다. 같은 증상이 반복될 경우 관리자에게 문의해주세요.");
			return ResponseEntity.ok(response);
		}//end if~else
	}//end registerInstructor


}//end class


