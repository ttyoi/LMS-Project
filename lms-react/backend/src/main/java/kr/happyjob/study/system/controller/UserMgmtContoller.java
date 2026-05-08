package kr.happyjob.study.system.controller;

import java.io.File;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.happyjob.study.common.comnUtils.ComnCodUtil;
import kr.happyjob.study.system.model.UserMgmtModel;
import kr.happyjob.study.system.service.UserMgmtService;

@Controller
@RequestMapping("/system/")
public class UserMgmtContoller {
	
	@Autowired
	UserMgmtService userMgmtService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	
	
	/**
	 * 사용자 관리 초기화면
	 */
	@RequestMapping("userMgmt.do")
	public String userMgmt(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".userMgmt");
		logger.info("   - paramMap : " + paramMap);
		
		logger.info("+ End " + className + ".userMgmt");
  
		return "system/usermgr";   
	}
	
	/**
	 * 사용자 관리 초기화면
	 */
	@RequestMapping("userlist.do")
	public String userlist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".userlist");
		logger.info("   - paramMap : " + paramMap);
		// 쿼리문 수정 !!!!!!!!!!
		int currentpage = Integer.parseInt((String)paramMap.get("currentpage"));
		int pagesize = Integer.parseInt((String)paramMap.get("pagesize"));
		int startpos = (currentpage - 1) * pagesize;
		
		paramMap.put("currentpage", currentpage);
		paramMap.put("pagesize", pagesize);
		paramMap.put("startpos", startpos);
		
		List<UserMgmtModel> userlist = userMgmtService.userlist(paramMap);
		int usertotalcnt = userMgmtService.userlisttotalcnt(paramMap);
		
		model.addAttribute("userlist",userlist);
		model.addAttribute("usertotalcnt",usertotalcnt);
		model.addAttribute("currentpage",currentpage);
		model.addAttribute("pagesize",pagesize);
		
		logger.info("+ End " + className + ".userlist");
  
		return "system/userlist";   
	}
	
	/**
	 * 특정 사용자 조회
	 */
	@RequestMapping("userselect.do")
	@ResponseBody
	public Map<String,Object> userselect(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".userselect");
		logger.info("   - paramMap : " + paramMap);
				
		Map<String,Object> returnmap = new HashMap<String,Object>();
				
		UserMgmtModel userdata = userMgmtService.userselect(paramMap);
		
		returnmap.put("userdata", userdata);
		
		logger.info("+ End " + className + ".userselect");
  
		return returnmap;   
	}	
	
	/**
	 * ID 중복체크
	 */
	@RequestMapping("iddupcheck.do")
	@ResponseBody
	public Map<String,Object> iddupcheck(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".iddupcheck");
		logger.info("   - paramMap : " + paramMap);
				
		Map<String,Object> returnmap = new HashMap<String,Object>();
				
		int idcnt= userMgmtService.iddupcheck(paramMap);
		
		if(idcnt > 0) {
			returnmap.put("idcheck", "N");
			returnmap.put("idcheckmsg", "중복 되었습니다.");
		} else {
			returnmap.put("idcheck", "Y");
			returnmap.put("idcheckmsg", "사용 가능 합니다.");
		}
		
		logger.info("+ End " + className + ".iddupcheck");
  
		return returnmap;   
	}
	
	@RequestMapping("usersave.do")
	@ResponseBody
	public Map<String,Object> usersave(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".usersave");
		logger.info("   - paramMap : " + paramMap);
				
		Map<String,Object> returnmap = new HashMap<String,Object>();
				
		String action = (String) paramMap.get("action");
		
		String result = "N";
		String resultmsg = "저장 실패 했습니다.";
		
		int prores = -1;
		
		if("I".equals(action)) {
			// 등록
			prores = userMgmtService.insertuser(paramMap, request);
		} else if("U".equals(action)) {
			// 수정 
			prores = userMgmtService.updateuser(paramMap, request);
		} else {
			// 삭제
			prores = userMgmtService.deleteuser(paramMap);
			
		}
		
		if(prores >= 0) {
			if("D".equals(action)) {
				resultmsg = "삭제 완료 되었습니다.";
			} else {
				resultmsg = "저징 완료 되었습니다.";
			}
			
			result = "Y";
			
		}
		
		returnmap.put("result", result);
		returnmap.put("resultmsg", resultmsg);	
		
		
		logger.info("+ End " + className + ".usersave");
  
		return returnmap;   
	}
	
   @RequestMapping("downloaduserfile.do")
   public void downloaduserfile(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
	   
	    logger.info("+ Start " + className + ".downloaduserfile");
		logger.info("   - paramMap : " + paramMap);
		
		// 첨부파일 조회
		UserMgmtModel fileinfo = userMgmtService.selectuserfile(paramMap);  // file 이름    , 물리경로
		
		byte fileByte[] = FileUtils.readFileToByteArray(new File(fileinfo.getPygicalpath()));
		
		response.setContentType("application/octet-stream");
	    response.setContentLength(fileByte.length);
	    response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(fileinfo.getFilename(),"UTF-8")+"\";");
	    response.setHeader("Content-Transfer-Encoding", "binary");
	    response.getOutputStream().write(fileByte);
	     
	    response.getOutputStream().flush();
	    response.getOutputStream().close();

		logger.info("+ End " + className + ".downloaduserfile");		   
   }	
	
	
	
	
}
