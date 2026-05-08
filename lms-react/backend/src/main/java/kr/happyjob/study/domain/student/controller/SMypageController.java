package kr.happyjob.study.domain.student.controller;

import kr.happyjob.study.domain.student.model.*;
import kr.happyjob.study.domain.student.service.SMypageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;


import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/stu")
public class SMypageController {

    @Value("${file.upload.logical-profile}")
    private String logiProfilePath;

    private static final String DEFAULT_PROFILE_IMG = "default_img.jpg";

    @Autowired
    SMypageService studentMypageService;

    @RequestMapping({"/my-page", "/my-page.do"})
    public String mypage(HttpSession session, Model model) throws Exception {

        String loginId = (String) session.getAttribute("loginId");

        SMypageVO userInfo = studentMypageService.getStudentMypage(loginId);
        model.addAttribute("userInfo", userInfo);

        model.addAttribute("isTempPw", userInfo.getChkTemPassword());

        return "student/my-page";
    }


    @ResponseBody
    @RequestMapping({"/userInfoAjax", "/userInfoAjax.do"})
    public SMypageUserInfoResponseDTO userInfoAjax(
            HttpSession session) throws Exception {

        String loginId = (String) session.getAttribute("loginId");

        SMypageVO userInfo = studentMypageService.getStudentMypage(loginId);


        String imgName = userInfo.getImgName();
        if (imgName == null || imgName.isEmpty()) {
            imgName = DEFAULT_PROFILE_IMG;
        }

        SMypageUserInfoResponseDTO responseDTO = new SMypageUserInfoResponseDTO();

        responseDTO.setLoginID(userInfo.getLoginID());
        responseDTO.setName(userInfo.getName());
        responseDTO.setPhone(userInfo.getPhone());
        responseDTO.setEmail(userInfo.getEmail());
        responseDTO.setBirthday(userInfo.getBirthday());
        responseDTO.setUserType(userInfo.getUserType());
        responseDTO.setResumeName(userInfo.getResumeName());
        responseDTO.setResumeId(userInfo.getResumeId());
        responseDTO.setZipcode(userInfo.getZipcode());
        responseDTO.setAddr1(userInfo.getAddr1());
        responseDTO.setAddr2(userInfo.getAddr2());

        responseDTO.setImgName(imgName);

        responseDTO.setImgLogiPath("/" + logiProfilePath);
        responseDTO.setImgPhyPath(userInfo.getImgPhyPath());

        responseDTO.setChkTemPassword(userInfo.getChkTemPassword());

        return responseDTO;

    }

    @ResponseBody
    @PostMapping({"/updateUserInfo", "/updateUserInfo.do"})
    public Map<String, Object> updateUserInfo(
            @RequestBody SMypageUpdateDTO dto,
            HttpSession session) throws Exception {

        String loginId = (String) session.getAttribute("loginId");

        dto.setLoginID(loginId);

        int result = studentMypageService.updateStudentMypage(dto);

        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("result", result > 0 ? "SUCCESS" : "FAIL");

        return returnMap;
    }

    @ResponseBody
    @RequestMapping({"/changePassword", "/changePassword.do"})
    public Map<String, Object> changePassword(
            HttpSession session, String oldPassword,
            String newPassword) throws Exception {

        String loginId = (String) session.getAttribute("loginId");

        MypagePasswordChangeParamDTO paramDTO = new MypagePasswordChangeParamDTO();
        paramDTO.setLoginID(loginId);
        paramDTO.setOldPw(oldPassword);
        paramDTO.setNewPw(newPassword);

        int result = studentMypageService.changePassword(paramDTO);

        Map<String, Object> map = new HashMap<>();

        if (result > 0) {
            map.put("result", "SUCCESS");
        } else if (result == -1) {
            map.put("result", "WRONG_OLD_PASSWORD");
        } else if (result == -2) {
            map.put("result", "SAME_PASSWORD");
        } else {
            map.put("result", "FAIL");
        }

        return map;

    }

    @PostMapping({"/uploadProfileImage", "/uploadProfileImage.do"})
    @ResponseBody
    public Map<String, Object> uploadProfileImage(
            HttpSession session,
            MultipartFile file) throws Exception {

        String loginId = (String) session.getAttribute("loginId");

        return studentMypageService.uploadProfileImage(loginId, file);
    }

    @PostMapping({"/resume", "/resume.do"})
    @ResponseBody
    public Map<String,Object> resumeUpload(
            @RequestParam("uploadFile") MultipartFile uploadFile,
            HttpSession session) throws Exception {

        String loginId = (String) session.getAttribute("loginId");
        return studentMypageService.uploadResume(loginId, uploadFile);
    }

    @PostMapping({"/resume/delete", "/resume/delete.do"})
    @ResponseBody
    public Map<String, Object> deleteResume(HttpSession session) throws Exception {
        String loginId = (String) session.getAttribute("loginId");

        int result = studentMypageService.deleteResume(loginId);

        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("result", result > 0 ? "SUCCESS" : "FAIL");
        return returnMap;
    }



    @GetMapping({"/resume/download", "/resume/download.do"})
    public void downloadResume(@RequestParam long resumeId, HttpServletResponse response) throws Exception {
        studentMypageService.downloadResume(resumeId, response);
    }





    @ResponseBody
    @RequestMapping({"/getCourseStatus", "/getCourseStatus.do"})
    public Map<String, Object> getCourseStatus(HttpSession session) {

        String loginId = (String) session.getAttribute("loginId");

        SMypageCourseStatusParamDTO param = new SMypageCourseStatusParamDTO();
        param.setLoginID(loginId);

        List<SMypageCourseStatusVO> list = studentMypageService.getStudentCourseStatus(param);


        Map<String, Object> res = new HashMap<>();
        res.put("list", list);

        return res;
    }

    @PostMapping({"/getPeriodScores", "/getPeriodScores.do"})
    @ResponseBody
    public Map<String, Object> getPeriodScores(
            @RequestParam int courseId,
            HttpSession session) {

        String loginId = (String) session.getAttribute("loginId");

        List<SMypagePeriodScoreVO> list = studentMypageService.getCoursePeriodScores(loginId, courseId);

        Map<String, Object> res = new HashMap<>();
        res.put("periodScores", list);
        return res;
    }

}
