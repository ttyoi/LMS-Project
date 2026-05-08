package kr.happyjob.study.domain.login.controller;

import kr.happyjob.study.common.comnUtils.ComnCodUtil;
import kr.happyjob.study.domain.login.model.LgnInfoModel;
import kr.happyjob.study.domain.login.model.UsrMnuAtrtModel;
import kr.happyjob.study.domain.login.service.LoginService;
import kr.happyjob.study.domain.login.service.MailSendService;
import kr.happyjob.study.system.model.ComnCodUtilModel;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;



@Controller

public class LoginController {

   // 커밋 테스트 됌 -동철
   
   
   // Set logger
   private final Logger logger = LogManager.getLogger(this.getClass());

   // Get class name for logger
   private final String className = this.getClass().toString();
   
   @Autowired
   LoginService loginService;

   @Autowired
   MailSendService mailSendService;

   /**
* index 접속 시 로그인 페이지로 이동한다.
* 
* @param   result Model- Spring model object
* @param   paramMap Map - Request Param object
* @param   request HttpServletRequest - Servlet request object
* @param   response HttpServletResponse - Servlet response object
* @param    session HttpSession - Http session Object
* @return   String - page navigator
* @throws Exception 예외발생시
*/
   @RequestMapping("login.do")
   public String index(Model result, @RequestParam Map<String, String> paramMap, HttpServletRequest request,
         HttpServletResponse response, HttpSession session) throws Exception {

  logger.info("+ Start LoginController.login.do");
  List<ComnCodUtilModel> listOfcDvsCod = ComnCodUtil.getComnCod("OFC_DVS_COD","M");   // 오피스 구분 코드 (M제외)
  Collections.reverse(listOfcDvsCod); // 오피스 구분 역순으로

/*  List<LgnInfoModel> cdList = loginService.selectBankList();	//select박스 은행 목록
  request.setAttribute("cdListobj", cdList);					//select박스 은행 목록
*/  result.addAttribute("listOfcDvsCod", listOfcDvsCod);   // 오피스 구분 코드
  //result.addAttribute("listCtrCod", listCtrCod);            // 국가 코드
  //result.addAttribute("listPnnCtr", listPnnCtr);            // 전화번호 국가
      logger.info("+ End LoginController.login.do");

  return "login/login";
   }

   /**
* 사용자 로그인을 처리한다.
* 
* @param   model Model - Spring model object
* @param   paramMap Map - Request Param object
* @param   request - HttpServletRequest Servlet request object
* @param   response HttpServletResponse - Servlet response object
* @param   session - HttpSession Http session Object
* @return   String - page navigator
* @throws Exception
*/
   @RequestMapping("loginProc.do")
   @ResponseBody
   public Map<String, Object> loginProc(
           Model model,
           @RequestParam Map<String, Object> paramMap,
           HttpServletRequest request,
           HttpServletResponse response,
           HttpSession session) throws Exception {

       logger.info("+ Start LoginController.loginProc.do");
       logger.info("   - ParamMap : " + paramMap);

       Map<String, Object> resultMap = new HashMap<String, Object>();
       String result = "FALSE";
       String resultMsg = "사용자 로그인 정보가 일치하지 않습니다.";

       // 사용자 로그인
       LgnInfoModel lgnInfoModel = loginService.loginProc(paramMap);

       if (lgnInfoModel != null
               && ("R".equals(lgnInfoModel.getStatus()) || "D".equals(lgnInfoModel.getStatus()))) {

           result = "SUCCESS";
           resultMsg = "사용자 로그인 정보가 일치 합니다.";

           if ("Y".equals(lgnInfoModel.getChk_tem_password())) {
               resultMap.put("chk_tem_password", "Y");
               resultMsg = "현재 임시비밀번호 입니다. 비밀번호를 변경해주세요.";
           }

           // 사용자 메뉴 권한 조회용 파라미터 세팅
           paramMap.put("usr_sst_id", lgnInfoModel.getUsr_sst_id());
           paramMap.put("userType", lgnInfoModel.getMem_author());

           // 메뉴 목록 조회 0depth
           List<UsrMnuAtrtModel> listUsrMnuAtrtModel = loginService.listUsrMnuAtrt(paramMap);

           // 메뉴 목록 조회 1depth
           for (UsrMnuAtrtModel list : listUsrMnuAtrtModel) {
               Map<String, Object> resultMapSub = new HashMap<String, Object>();
               resultMapSub.put("lgn_Id", paramMap.get("lgn_Id"));
               resultMapSub.put("hir_mnu_id", list.getMnu_id());
               resultMapSub.put("userType", lgnInfoModel.getMem_author());

               list.setNodeList(loginService.listUsrChildMnuAtrt(resultMapSub));
           }

           // 세션 저장
           session.setAttribute("loginId", lgnInfoModel.getLgn_id());          // 로그인 ID
           session.setAttribute("userNm", lgnInfoModel.getUsr_nm());           // 사용자 성명
           session.setAttribute("userimg", lgnInfoModel.getLogicalpath());     // 사용자 이미지(추후 개선 가능)
           session.setAttribute("usrMnuAtrt", listUsrMnuAtrtModel);            // 메뉴 권한 목록
           session.setAttribute("userType", lgnInfoModel.getMem_author());     // 사용자 권한
           session.setAttribute("serverName", request.getServerName());

           // 응답값 저장
           resultMap.put("loginId", lgnInfoModel.getLgn_id());
           resultMap.put("userNm", lgnInfoModel.getUsr_nm());
           resultMap.put("usrMnuAtrt", listUsrMnuAtrtModel);
           resultMap.put("userType", lgnInfoModel.getMem_author());
           resultMap.put("serverName", request.getServerName());
       }

       resultMap.put("result", result);
       resultMap.put("resultMsg", resultMsg);

       logger.info("+ End LoginController.loginProc.do");

       return resultMap;
   }
   
   
   /**
* 로그아웃
* @param request
* @param response
* @param session
* @return
*/
   @RequestMapping(value = "/loginOut.do")
   public ModelAndView loginOut(HttpServletRequest request, HttpServletResponse response, HttpSession session) {
                  
      ModelAndView mav = new ModelAndView();
      session.invalidate();
      mav.setViewName("redirect:/login.do");
      
      return mav;
   }
   /*회원가입*/
   @RequestMapping("register.do")
   @ResponseBody
   public Map<String, Object> registerUser(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception{
	   logger.info("+ Start " + className + ".registerUser");
	   logger.info("   - paramMap : " + paramMap);
		
	   String action = (String)paramMap.get("action");
	   String result = "SUCCESS";
	   String resultMsg;
	   
	   if("I".equals(action)) {
		   
		   loginService.registerUser(paramMap);
		   resultMsg = "가입 요청 완료";
	   } else {
		   
		   result = "FAIL";
		   resultMsg = "가입 요청 실패";
	   }
	   
	   
	   // login ID 스킬 delete
	   
	   // insert
	   
	   //paramMap
	   
	   
	   //전문기술
	   List<ComnCodUtilModel> lg = ComnCodUtil.getComnCod("LanguageCD");
	   
	   for(ComnCodUtilModel lgitem : lg) {
		   String groupitem = lgitem.getGrp_cod();
		   String dtlitem = lgitem.getDtl_cod();
		   
		   try {
			   String paramitem = (String) paramMap.get(dtlitem);
			   
			   paramMap.put("skillgrpcd", groupitem);
			   paramMap.put("skilldtlcd", dtlitem);
			   
			   //insert 
			   
		   } catch (Exception e) {
			   
		   }
	   }   
	   
	   List<ComnCodUtilModel> web = ComnCodUtil.getComnCod("webCD");
	   
	   for(ComnCodUtilModel webitem : web) {
		   String groupitem = webitem.getGrp_cod();
		   String dtlitem = webitem.getDtl_cod();
		   
		   try {
			   String paramitem = (String) paramMap.get(dtlitem);
			   
			   paramMap.put("skillgrpcd", groupitem);
			   paramMap.put("skilldtlcd", dtlitem);
			   
			   //insert 
			   
		   } catch (Exception e) {
			   
		   }
	   }   
	   
	   List<ComnCodUtilModel> db = ComnCodUtil.getComnCod("DBCD");
	   
	   for(ComnCodUtilModel dbitem : db) {
		   String groupitem = dbitem.getGrp_cod();
		   String dtlitem = dbitem.getDtl_cod();
		   
		   try {
			   String paramitem = (String) paramMap.get(dtlitem);
			   
			   paramMap.put("skillgrpcd", groupitem);
			   paramMap.put("skilldtlcd", dtlitem);
			   
			   //insert 
			   
		   } catch (Exception e) {
			   
		   }
	   }
	   
	   
	   List<ComnCodUtilModel> ws = ComnCodUtil.getComnCod("WSCD");
	   
	   for(ComnCodUtilModel wsitem : ws) {
		   String groupitem = wsitem.getGrp_cod();
		   String dtlitem = wsitem.getDtl_cod();
		   
		   try {
			   String paramitem = (String) paramMap.get(dtlitem);
			   
			   paramMap.put("skillgrpcd", groupitem);
			   paramMap.put("skilldtlcd", dtlitem);
			   
			   //insert 
			   
		   } catch (Exception e) {
			   
		   }
	   }
	   
	   
	   
	   
	   Map<String, Object> resultMap = new HashMap<String, Object>();
	   resultMap.put("result", result);
	   resultMap.put("resultMsg", resultMsg);
	   
	   logger.info("+ End " + className + ".registerUser");
	   
	   return resultMap;
   }
   
   
   /*loginID 중복체크*/
   @RequestMapping(value={"check_loginID", "check_loginID.do"}, method=RequestMethod.POST)
   @ResponseBody
   public int check_loginID(LgnInfoModel model) throws Exception{
	   
	   logger.info("+ Start " + className + ".loginID_check");
	   int result = loginService.check_loginID(model);
	   logger.info("+ End " + className + ".loginID_check");
	   return result;
   }
   
   /*이메일 중복체크*/
   @RequestMapping(value="check_email", method=RequestMethod.POST)
   @ResponseBody
   public int check_email(LgnInfoModel model) throws Exception{
	   logger.info("+ Start " + className + ".loginID_check");
	   int result = loginService.check_email(model);
	   logger.info("+ End " + className + ".loginID_check");
	   return result;
   }
   /**
*  사용자 id 찾기
*/
   @RequestMapping("selectFindInfo.do")
   @ResponseBody
   public Map<String, Object> selectFindInfoId(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
         HttpServletResponse response, HttpSession session) throws Exception {
      
      logger.info("+ Start " + className + ".selectFindInfoId");
  
  logger.info("   - paramMap : " + paramMap);
//      if(!paramMap.get("cpn_ctr").toString().equals("") && !paramMap.get("cpn_ctr").toString().equals("000")){
//         paramMap.put("type", "P");
//      }else if(!paramMap.get("eml").toString().equals("")){
//         paramMap.put("type", "E");
//      }
  String result;
  String resultMsg;
  LgnInfoModel resultModel= loginService.selectFindId(paramMap);
  
/*  	if(paramMap.get("lgn_id") == null){
		// 사용자 id 조회        
		System.out.println(loginService.selectFindId(paramMap));
		System.out.println("id조회!!!!!!!");
	}else{
		// 사용자 pw 조회
		System.out.println(loginService.selectFindPw(paramMap));
		System.out.println("pw조회!!!!!!!");
	}*/
  
  if (resultModel != null) {  
  result = "SUCCESS";
  resultMsg = "조회 성공";

  	
  }else {
      result = "FALSE";
      resultMsg = "조회 실패";
   }
  

  Map<String, Object> resultMap = new HashMap<String, Object>();

  resultMap.put("result", result);
  resultMap.put("resultMsg", resultMsg);
  resultMap.put("resultModel", resultModel);
  
  System.out.println(result);
  System.out.println(resultMsg);
  System.out.println(resultModel);
  System.out.println(resultMap);
  
  logger.info("+ End " + className + ".selectFindInfoId");
      
      return resultMap;
     
   }
   
   
   
   //사용자 pw 조회
   @RequestMapping("selectFindInfoPw.do")
   @ResponseBody
   public Map<String, Object> selectFindInfoPw(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
         HttpServletResponse response, HttpSession session) throws Exception {
      
      logger.info("+ Start " + className + ".selectFindInfoPw");
  
      logger.info("   - paramMap : " + paramMap);

  String result;
  String resultMsg;
  LgnInfoModel resultModelPw= loginService.selectFindPw(paramMap);
  
  if (resultModelPw != null) {  
  result = "SUCCESS";
  resultMsg = "조회 성공";

  }else {
      result = "FALSE";
      resultMsg = "조회 실패";
   }

  Map<String, Object> resultMap = new HashMap<String, Object>();

  resultMap.put("result", result);
  resultMap.put("resultMsg", resultMsg);
  resultMap.put("resultModel", resultModelPw);
  
/*  System.out.println(result);
  System.out.println(resultMsg);
  System.out.println(resultModelPw);
  System.out.println(resultMap);*/
  
  logger.info("+ End " + className + ".selectFindInfoPw");
      
     return resultMap;
     
   }
   
   
   /**사용자 PW 찾기 ID 체크*/
   @RequestMapping("registerIdCheck.do")
   @ResponseBody
   public Map<String, Object> registerIdCheck(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
	         HttpServletResponse response, HttpSession session) throws Exception {
	   
	   logger.info("+ Start " + className + ".registerIdCheck");
	   
	   logger.info("   - paramMap : " + paramMap);

	  String result;
	  String resultMsg;
	  LgnInfoModel registerIdCheck= loginService.registerIdCheck(paramMap);
	  
	  if (registerIdCheck != null) {  
		  result = "SUCCESS";
		  resultMsg = "조회 성공";

		}else {
		      result = "FALSE";
		      resultMsg = "조회 실패";
		  	  }
	  
	  Map<String, Object> resultMap = new HashMap<String, Object>();

	  resultMap.put("result", result);
	  resultMap.put("resultMsg", resultMsg);
	  resultMap.put("resultModel", registerIdCheck);
	  
/*	  System.out.println(result);
	  System.out.println(resultMsg);
	  System.out.println(registerIdCheck);
	  System.out.println(resultMap);*/
	  
	  logger.info("+ End " + className + ".registerIdCheck");
	   
	   return resultMap;
   }
   

   /**메일 발송*/
   @RequestMapping("sendmail.do")
   @ResponseBody
   public Map<String, Object> emailSendAuth(Model model, HttpServletRequest request, HttpServletResponse response, 
		   	HttpSession session) throws Exception {
	   logger.info("+ Start " + className + ".emailSendAuth");

	   String emailNum = request.getParameter("email");
	   Map<String, Object> resultMap = new HashMap<String, Object>();
	   String authNumId = mailSendService.RandomNum();

	   try {
		   mailSendService.sendEmailAsync(emailNum, authNumId);
		   resultMap.put("result", "SUCCESS");
		   resultMap.put("resultMsg", "인증번호를 전송했습니다.");
		   resultMap.put("authNumId", authNumId);
	   } catch (Exception e) {
		   logger.error("인증번호 메일 발송 실패", e);
		   resultMap.put("result", "FAIL");
		   resultMap.put("resultMsg", "인증번호 메일 전송에 실패했습니다. 잠시 후 다시 시도해주세요.");
	   }

	   resultMap.put("emailNum", emailNum);
	   logger.info("+ End " + className + ".emailSendAuth");
   
	   return resultMap;
   }

   @RequestMapping("checklist.do")
   @ResponseBody
   public Map<String, Object> checklist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
         HttpServletResponse response, HttpSession session) throws Exception {

      logger.info("+ Start LoginController.checklist.do");
      logger.info("   - ParamMap : " + paramMap);
   
      //전문기술 공통코드 
      List<ComnCodUtilModel> listlistCod = ComnCodUtil.getComnCod("LanguageCD");
      List<ComnCodUtilModel> weblistCod = ComnCodUtil.getComnCod("webCD");
      List<ComnCodUtilModel> dblistCod = ComnCodUtil.getComnCod("DBCD");
      List<ComnCodUtilModel> wslistCod = ComnCodUtil.getComnCod("WSCD");
      List<ComnCodUtilModel> sklcdlistCod = ComnCodUtil.getComnCod("SKLCD"); //등급
      List<ComnCodUtilModel> areacdlistCod = ComnCodUtil.getComnCod("areaCD"); //희망근무지역
      
      Map<String, Object> resultMap = new HashMap<String, Object>();
      resultMap.put("listlistCod", listlistCod);
      resultMap.put("weblistCod", weblistCod);
      resultMap.put("dblistCod", dblistCod);
      resultMap.put("wslistCod", wslistCod);
      resultMap.put("sklcdlistCod", sklcdlistCod);
      resultMap.put("areacdlistCod", areacdlistCod);
  
      logger.info("+ End LoginController.checklist.do");
      logger.info("확인 weblistCod:"+weblistCod);
      logger.info("확인 sklcdlistCod:"+sklcdlistCod);
      return resultMap;
   }   
   
/*	@RequestMapping("saveFileTest.do")
	@ResponseBody
	public Map<String, Object> saveFileTest(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start saveFileTest");
		logger.info("   - paramMap : " + paramMap);
		
		String action = (String)paramMap.get("action");
		String result = "SUCCESS";
		String resultMsg = "저장 되었습니다.";
		
		
		
		if ("I".equals(action)) {
			//CmntBbsService.insertCmntBbs(paramMap, request); // 게시글 신규 저장 
			logger.info("  action  :  " + action);
			LoginService.insertFile(paramMap,request);
		} else if("U".equals(action)) {
			//CmntBbsService.updateCmntBbs(paramMap, request); // 게시글 수정 저장
			logger.info("  action  :  " + action);
			LoginService.updateFile(paramMap,request);
		} else {
			logger.info("  action  :  " + action);
			result = "FALSE";
			resultMsg = "알수 없는 요청 입니다.";
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result", result);
		resultMap.put("resultMsg", resultMsg);
		
		logger.info("+ End saveFileTest");
		
		return resultMap;
	}*/
   
}
