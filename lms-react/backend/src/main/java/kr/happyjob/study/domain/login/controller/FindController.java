package kr.happyjob.study.domain.login.controller;

import kr.happyjob.study.domain.login.service.FindService;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class FindController {

	Logger logger = LogManager.getLogger(this.getClass());

	@Autowired
	private FindService findService;

	/**
	 * 아이디/비밀번호 찾기
	 * @return
	 */
	@RequestMapping("/searchidApw")
	public String searchIDAndPassword(){
		return "login/find";
	}//end searchIDAndPassword

	/**
	 * 메일로 아이디 찾기
	 * @param email
	 * @return
	 */
	@RequestMapping("/findID")
	@ResponseBody
	public ResponseEntity<String> findID(@RequestParam("email") String email){
		String resultStr = findService.getIDbyEmail(email);
		return ResponseEntity
				.ok()
				.header("Content-Type","text/plain; charset=UTF-8")
				.body(resultStr);
	}//end findID


	/**
	 * 아이디, 이메일이 있을 경우 임시비밀번호 발급
	 * @param id
	 * @param email
	 * @return
	 */
	@RequestMapping({"/searchPassword", "/searchPassword.do"})
	@ResponseBody
	public ResponseEntity<String> searchPassword(@RequestParam("id") String id, @RequestParam("email") String email) {
		String resultStr = findService.requestSearchPassword(id,email);
		return ResponseEntity
				.ok()
				.header("Content-Type","text/plain; charset=UTF-8")
				.body(resultStr);
	}//end searchPassword



}//end class
