package kr.happyjob.study.domain.admin.controller;

import kr.happyjob.study.domain.admin.model.AResumeVO;
import kr.happyjob.study.domain.admin.model.AUserVO;
import kr.happyjob.study.domain.admin.service.AUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class AUserController {

    @Autowired
    private AUserService AUserService;

    @GetMapping("/admin/inst")
    public String instructorListController(@RequestParam Map<String, Object> paramMap, HttpSession session, Model model) {

        String loginID = (String) session.getAttribute("loginID");
        // String userType = (String) session.getAttribute("user_type");

        // 페이지네이션
        int currentPage = 1;
        int pageSize    = 10;

        Object cpObj = paramMap.get("currentPage");
        if (cpObj != null && !"".equals(cpObj.toString())) {
            currentPage = Integer.parseInt(cpObj.toString());
        }

        Object psObj = paramMap.get("pageSize");
        if (psObj != null && !"".equals(psObj.toString())) {
            pageSize = Integer.parseInt(psObj.toString());
        }

        int startNum = (currentPage - 1) * pageSize;

        // 쿼리 파라미터 세팅
        paramMap.put("loginID", loginID);
        paramMap.put("startNum", startNum);
        paramMap.put("pageSize", pageSize);
        // 강사만 조회
        paramMap.put("user_type", "I");

        // 서비스 호출
        List<AUserVO> instructorList = AUserService.getInstructorList(paramMap);
        int instructorCnt           = AUserService.getInstructorListCount(paramMap);

        // JSP로 보낼 데이터
        model.addAttribute("instructorList", instructorList);
        model.addAttribute("instructorCnt", instructorCnt);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("pageSize", pageSize);

        // 검색값
        model.addAttribute("sname", paramMap.get("sname"));
        model.addAttribute("searchType", paramMap.get("searchType"));
        model.addAttribute("statusFilter", paramMap.get("statusFilter"));

        return "admin/studentList";
    }

    @GetMapping("/admin/stu")
    public String studentListController(@RequestParam Map<String, Object> paramMap, HttpSession session, Model model) {

        String loginID = (String) session.getAttribute("loginID");
        // String userType = (String) session.getAttribute("user_type");

        int currentPage = 1;
        int pageSize    = 10;

        Object cpObj = paramMap.get("currentPage");
        if (cpObj != null && !"".equals(cpObj.toString())) {
            currentPage = Integer.parseInt(cpObj.toString());
        }

        Object psObj = paramMap.get("pageSize");
        if (psObj != null && !"".equals(psObj.toString())) {
            pageSize = Integer.parseInt(psObj.toString());
        }

        int startNum = (currentPage - 1) * pageSize;

        // 쿼리 파라미터 세팅
        paramMap.put("loginID", loginID);
        paramMap.put("startNum", startNum);
        paramMap.put("pageSize", pageSize);
        // 학생만 조회
        paramMap.put("user_type", "S");

        // 서비스 호출
        List<AUserVO> studentList = AUserService.getStudentList(paramMap);
        int studentCnt = AUserService.getStudentListCount(paramMap);

        // JSP로 보낼 데이터
        model.addAttribute("studentList", studentList);
        model.addAttribute("studentCnt", studentCnt);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("pageSize", pageSize);

        // 검색값
        model.addAttribute("sname", paramMap.get("sname"));
        model.addAttribute("searchType", paramMap.get("searchType"));

        return "admin/studentList";
    }

    @PostMapping("/admin/inst/instDetail")
    @ResponseBody
    public Map<String, Object> getInstDetail(@RequestParam("loginID") String loginID ) {

        AUserVO stuVO = AUserService.getInstructorDetail(loginID);

        // Date 날짜 포멧(등록일, 탈퇴일)
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        Map<String,Object > result = new HashMap<>();

        // 생일과 성별 분리
        String raw = stuVO.getBirthday();
        String birthday = "-";
        String y=null;
        String m = null;
        String d = null;
        String genderInt = null;
        String gender = "-";
        if(raw != null){
            y=raw.substring(0,4);
            m=raw.substring(4,6);
            d=raw.substring(6,8);
            birthday= y+"-"+m+"-"+d;
            genderInt=raw.substring(8);
        }
        if("1".equals(genderInt)){
            gender = "남";
        }else{
            gender="여";
        }

        result.put("result", "SUCCESS");
        result.put("loginID", stuVO.getLoginID());
        result.put("name", stuVO.getName());
        result.put("zipcode", stuVO.getZipcode());
        result.put("addr1", stuVO.getAddr1());
        result.put("addr2",  stuVO.getAddr2());
        result.put("email", stuVO.getEmail());
        result.put("phone", stuVO.getPhone());
        /* 날짜 String으로 받기*/
        result.put("birthday", birthday);
        result.put("gender", gender);
        if(stuVO.getReg_date() != null){
            result.put("reg_date", sdf.format(stuVO.getReg_date()));
        }else{
            result.put("reg_date","-");
        }
        if(stuVO.getRet_date() != null) {
            result.put("ret_date", sdf.format(stuVO.getRet_date()));
        }else{
            result.put("ret_date", "-");
        }
        result.put("edu_level", stuVO.getEdu_level());
        result.put("career",stuVO.getCareer());
        result.put("status", stuVO.getStatus());
        result.put("img_logi_path", stuVO.getImg_logi_path());
        result.put("img_name", stuVO.getImg_name());

        return result;
    }

    @PostMapping("/admin/stu/stuDetail")
    @ResponseBody
    public Map<String, Object> getStuDetail(@RequestParam("loginID") String loginID ) {

        // 학생 정보 조회
        AUserVO stuVO = AUserService.getStudentDetailByLogin(loginID);
        // 이력서 조회
        AResumeVO resumeVO = AUserService.getResumeByLoginID(loginID);

        // Date 날짜 포멧(등록일, 탈퇴일)
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        
        Map<String,Object > result = new HashMap<>();

        // 생일과 성별 분리
        String raw = stuVO.getBirthday();
        String birthday = "-";
        String y=null;
        String m = null;
        String d = null;
        String genderInt = null;
        String gender = "-";
        if(raw != null){
            y=raw.substring(0,4);
            m=raw.substring(4,6);
            d=raw.substring(6,8);
            birthday= y+"-"+m+"-"+d;
            genderInt=raw.substring(8);
        }
        if("1".equals(genderInt)){
            gender = "남";
        }else{
            gender="여";
        }

        result.put("result", "SUCCESS");
        result.put("loginID", stuVO.getLoginID());
        result.put("name", stuVO.getName());
        result.put("zipcode", stuVO.getZipcode());
        result.put("addr1", stuVO.getAddr1());
        result.put("addr2",  stuVO.getAddr2());
        result.put("email", stuVO.getEmail());
        result.put("phone", stuVO.getPhone());
        /* 날짜 String으로 받기*/
        result.put("birthday", birthday);
        result.put("gender", gender);
        if(stuVO.getReg_date() != null){
            result.put("reg_date", sdf.format(stuVO.getReg_date()));
        }else{
            result.put("reg_date","-");
        }
        if(stuVO.getRet_date() != null) {
            result.put("ret_date", sdf.format(stuVO.getRet_date()));
        }else{
            result.put("ret_date", "-");
        }
        result.put("status", stuVO.getStatus());
        result.put("img_logi_path", stuVO.getImg_logi_path());
        result.put("img_name", stuVO.getImg_name());

        // 학생 이력서
        if(resumeVO != null){
            result.put("hasResume",true);
            result.put("resumeName",resumeVO.getName());
        } else{
            result.put("hasResume",false);
            result.put("resumeName","");
        }

        return result;
    }

    @PostMapping({"/admin/stu/updateStudentStatus","/admin/inst/updateInstructorStatus"})
    @ResponseBody
    public Map<String, Object> getStudentStatus(@RequestParam("loginID") String loginID, @RequestParam("status") String status) {
        Map<String, Object> result = new HashMap<>();
        //int updated  = AUserService.updateStudentStatus(loginID,status);
        try{
            int updated = AUserService.updateStudentStatus(loginID, status);
            if(updated > 0){
                result.put("result", "SUCCESS");
            }else{
                result.put("result", "FAIL");
                result.put("message","업데이트 놉");
            }
        }catch (Exception e){
            result.put("result", "FAIL");
            result.put("message",e.getMessage());
        }


        return result;
    }

    // 학생 이력서 다운로드
    @GetMapping("/admin/stu/resumeDownload")
    public void downloadResume(@RequestParam("loginID") String loginID,
                               HttpServletResponse response) throws IOException {

        AResumeVO resume = AUserService.getResumeByLoginID(loginID);

        // 이력서 정보 자체가 없거나, 물리 경로가 없는 경우
        if (resume == null || resume.getPhysical_path() == null) {
            response.setContentType("text/html;charset=UTF-8");
            try(PrintWriter out = response.getWriter()) {
                out.println("<script>alert('등록된 이력서가 없습니다.'); history.back();</script>");
                out.flush();
            }
            return;
        }

        File file = new File(resume.getPhysical_path());

        // DB에는 경로가 있는데 실제 파일이 없는 경우
        if (!file.exists()) {
            response.setContentType("text/html;charset=UTF-8");
            try(PrintWriter out = response.getWriter()){
                out.println("<script>alert('이력서 파일을 찾을 수가 없습니다.');history.back();</script>");
                out.flush();
            }
            return;
        }

        String fileName = resume.getName(); // DB에 저장된 파일명
        String encodedName = URLEncoder.encode(fileName, "UTF-8").replace("+", "%20");

        // pdf
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedName + "\"");

        try (InputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            FileCopyUtils.copy(in, out);
        }
    }

    /**
     * ----------------------------------------------------------------------------------------------------
     * --------------------------- 프론트 JSP -> React로 변형하기 위한 컨트롤러 매핑
     * 기존 화면 뷰 반환하는 맵핑 JSON 형태로 변형
     */

    @GetMapping("/api/admin/stu")
    @ResponseBody
    public Map<String, Object> getStudentListApi(@RequestParam Map<String, Object> paramMap, HttpSession session) {

        // 기존 로직 그대로 사용
        int currentPage = Integer.parseInt(paramMap.getOrDefault("currentPage", "1").toString());
        int pageSize = Integer.parseInt(paramMap.getOrDefault("pageSize", "10").toString());
        if (pageSize > 100) {
            pageSize = 100;
        }

        int startNum = (currentPage - 1) * pageSize;

        paramMap.put("startNum", startNum);
        paramMap.put("pageSize", pageSize);
        paramMap.put("user_type", "S");

        // 서비스 호출
        List<AUserVO> studentList = AUserService.getStudentList(paramMap);
        int studentCnt = AUserService.getStudentListCount(paramMap);

        // Model 대신 Map에 데이터를 담아서 리턴합니다.
        Map<String, Object> result = new HashMap<>();
        result.put("studentList", studentList);
        result.put("studentCnt", studentCnt);
        result.put("currentPage", currentPage);
        result.put("pageSize", pageSize);

        return result; // 5. 이제 객체를 리턴하면 리액트가 읽을 수 있는 JSON이 됩니다.
    }

    @GetMapping("/api/admin/inst")
    @ResponseBody
    public Map<String, Object> instructorListControllerReact(@RequestParam Map<String, Object> paramMap, HttpSession session, Model model) {

        // 페이지네이션
        // 기존 로직 그대로 사용
        int currentPage = Integer.parseInt(paramMap.getOrDefault("currentPage", "1").toString());
        int pageSize = Integer.parseInt(paramMap.getOrDefault("pageSize", "10").toString());
        if (pageSize > 100) {
            pageSize = 100;
        }


        int startNum = (currentPage - 1) * pageSize;

        // 쿼리 파라미터 세팅
        paramMap.put("startNum", startNum);
        paramMap.put("pageSize", pageSize);
        // 강사만 조회
        paramMap.put("user_type", "I");

        // 서비스 호출
        List<AUserVO> instructorList = AUserService.getInstructorList(paramMap);
        int instructorCnt           = AUserService.getInstructorListCount(paramMap);

        Map<String, Object> result = new HashMap<>();

        result.put("instructorList", instructorList);
        result.put("instructorCnt", instructorCnt);
        result.put("currentPage", currentPage);
        result.put("pageSize", pageSize);

        // 검색값
        result.put("sname", paramMap.get("sname"));
        result.put("searchType", paramMap.get("searchType"));
        result.put("statusFilter", paramMap.get("statusFilter"));

        return result;
    }

    @PostMapping("/api/admin/stu/stuDetail")
    @ResponseBody
    public Map<String, Object> getStuDetailReact(@RequestParam("loginID") String loginID ) {

        // 학생 정보 조회
        AUserVO stuVO = AUserService.getStudentDetailByLogin(loginID);
        // 이력서 조회
        AResumeVO resumeVO = AUserService.getResumeByLoginID(loginID);

        // Date 날짜 포멧(등록일, 탈퇴일)
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        Map<String,Object > result = new HashMap<>();

        // 생일과 성별 분리
        String raw = stuVO.getBirthday();
        String birthday = "-";
        String y=null;
        String m = null;
        String d = null;
        String genderInt = null;
        String gender = "-";
        if(raw != null){
            y=raw.substring(0,4);
            m=raw.substring(4,6);
            d=raw.substring(6,8);
            birthday= y+"-"+m+"-"+d;
            genderInt=raw.substring(8);
        }
        if("1".equals(genderInt)){
            gender = "남";
        }else{
            gender="여";
        }

        result.put("result", "SUCCESS");
        result.put("loginID", stuVO.getLoginID());
        result.put("name", stuVO.getName());
        result.put("zipcode", stuVO.getZipcode());
        result.put("addr1", stuVO.getAddr1());
        result.put("addr2",  stuVO.getAddr2());
        result.put("email", stuVO.getEmail());
        result.put("phone", stuVO.getPhone());
        /* 날짜 String으로 받기*/
        result.put("birthday", birthday);
        result.put("gender", gender);
        if(stuVO.getReg_date() != null){
            result.put("reg_date", sdf.format(stuVO.getReg_date()));
        }else{
            result.put("reg_date","-");
        }
        if(stuVO.getRet_date() != null) {
            result.put("ret_date", sdf.format(stuVO.getRet_date()));
        }else{
            result.put("ret_date", "-");
        }
        result.put("status", stuVO.getStatus());
        result.put("img_logi_path", stuVO.getImg_logi_path());
        result.put("img_name", stuVO.getImg_name());

        // 학생 이력서
        if(resumeVO != null){
            result.put("hasResume",true);
            result.put("resumeName",resumeVO.getName());
        } else{
            result.put("hasResume",false);
            result.put("resumeName","");
        }

        return result;
    }

    @PostMapping("/api/admin/inst/instDetail")
    @ResponseBody
    public Map<String, Object> getInstDetailReact(@RequestParam("loginID") String loginID ) {

        AUserVO stuVO = AUserService.getInstructorDetail(loginID);

        // Date 날짜 포멧(등록일, 탈퇴일)
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        Map<String,Object > result = new HashMap<>();

        // 생일과 성별 분리
        String raw = stuVO.getBirthday();
        String birthday = "-";
        String y=null;
        String m = null;
        String d = null;
        String genderInt = null;
        String gender = "-";
        if(raw != null){
            y=raw.substring(0,4);
            m=raw.substring(4,6);
            d=raw.substring(6,8);
            birthday= y+"-"+m+"-"+d;
            genderInt=raw.substring(8);
        }
        if("1".equals(genderInt)){
            gender = "남";
        }else{
            gender="여";
        }

        result.put("result", "SUCCESS");
        result.put("loginID", stuVO.getLoginID());
        result.put("name", stuVO.getName());
        result.put("zipcode", stuVO.getZipcode());
        result.put("addr1", stuVO.getAddr1());
        result.put("addr2",  stuVO.getAddr2());
        result.put("email", stuVO.getEmail());
        result.put("phone", stuVO.getPhone());
        /* 날짜 String으로 받기*/
        result.put("birthday", birthday);
        result.put("gender", gender);
        if(stuVO.getReg_date() != null){
            result.put("reg_date", sdf.format(stuVO.getReg_date()));
        }else{
            result.put("reg_date","-");
        }
        if(stuVO.getRet_date() != null) {
            result.put("ret_date", sdf.format(stuVO.getRet_date()));
        }else{
            result.put("ret_date", "-");
        }
        result.put("edu_level", stuVO.getEdu_level());
        result.put("career",stuVO.getCareer());
        result.put("status", stuVO.getStatus());
        result.put("img_logi_path", stuVO.getImg_logi_path());
        result.put("img_name", stuVO.getImg_name());

        return result;
    }

    @PostMapping({"/api/admin/stu/updateStudentStatus","/api/admin/inst/updateInstructorStatus"})
    @ResponseBody
    public Map<String, Object> getStudentStatusReact(@RequestParam("loginID") String loginID, @RequestParam("status") String status) {
        Map<String, Object> result = new HashMap<>();
        //int updated  = AUserService.updateStudentStatus(loginID,status);
        try{
            int updated = AUserService.updateStudentStatus(loginID, status);
            if(updated > 0){
                result.put("result", "SUCCESS");
            }else{
                result.put("result", "FAIL");
                result.put("message","업데이트 놉");
            }
        }catch (Exception e){
            result.put("result", "FAIL");
            result.put("message",e.getMessage());
        }


        return result;
    }

    @GetMapping("/api/admin/stu/resumeDownload")
    public void downloadResumeReact(@RequestParam("loginID") String loginID,
                               HttpServletResponse response) throws IOException {

        AResumeVO resume = AUserService.getResumeByLoginID(loginID);

        // 이력서 정보 자체가 없거나, 물리 경로가 없는 경우
        if (resume == null || resume.getPhysical_path() == null) {
            response.setContentType("text/html;charset=UTF-8");
            try(PrintWriter out = response.getWriter()) {
                out.println("<script>alert('등록된 이력서가 없습니다.'); history.back();</script>");
                out.flush();
            }
            return;
        }

        File file = new File(resume.getPhysical_path());

        // DB에는 경로가 있는데 실제 파일이 없는 경우
        if (!file.exists()) {
            response.setContentType("text/html;charset=UTF-8");
            try(PrintWriter out = response.getWriter()){
                out.println("<script>alert('이력서 파일을 찾을 수가 없습니다.');history.back();</script>");
                out.flush();
            }
            return;
        }

        String fileName = resume.getName(); // DB에 저장된 파일명
        String encodedName = URLEncoder.encode(fileName, "UTF-8").replace("+", "%20");

        // pdf
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedName + "\"");

        try (InputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            FileCopyUtils.copy(in, out);
        }
    }


}
