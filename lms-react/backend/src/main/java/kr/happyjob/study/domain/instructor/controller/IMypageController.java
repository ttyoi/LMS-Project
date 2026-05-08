package kr.happyjob.study.domain.instructor.controller;

import kr.happyjob.study.common.comnUtils.MypageFileUtil;
import kr.happyjob.study.domain.instructor.model.*;
import kr.happyjob.study.domain.instructor.service.IMypageService;
import kr.happyjob.study.domain.student.model.MypagePasswordChangeParamDTO;
import kr.happyjob.study.domain.student.model.MypageProfileUpdateParamDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/inst")
public class IMypageController {

    @Value("${file.upload.logical-profile}")
    private String logiProfilePath;

    private static final String DEFAULT_PROFILE_IMG = "default_profile.jpg";

    @Autowired
    IMypageService instructorMypageService;

    @RequestMapping({"/my-page", "/my-page.do"})
    public String mypage(HttpSession session, Model model) throws Exception {

        String loginId = (String) session.getAttribute("loginId");

        IMypageVO userInfo = instructorMypageService.getInstructorMypage(loginId);
        model.addAttribute("userInfo", userInfo);

        model.addAttribute("isTempPw", userInfo.getChkTemPassword());

        return "instructor/my-page";
    }

    @ResponseBody
    @RequestMapping({"/userInfoAjax", "/userInfoAjax.do"})
    public IMypageResponseDTO userInfoAjax(
            HttpSession session) throws Exception {

        String loginId = (String) session.getAttribute("loginId");

        IMypageVO userInfo = instructorMypageService.getInstructorMypage(loginId);

        IMypageResponseDTO responseDTO = new IMypageResponseDTO();

        responseDTO.setLoginID(userInfo.getLoginID());
        responseDTO.setName(userInfo.getName());
        responseDTO.setPhone(userInfo.getPhone());
        responseDTO.setEmail(userInfo.getEmail());
        responseDTO.setBirthday(userInfo.getBirthday());
        responseDTO.setUserType(userInfo.getUserType());

        responseDTO.setZipcode(userInfo.getZipcode());
        responseDTO.setAddr1(userInfo.getAddr1());
        responseDTO.setAddr2(userInfo.getAddr2());

        String imgName = userInfo.getImgName();
        if (imgName == null || imgName.isEmpty()) {
            imgName = DEFAULT_PROFILE_IMG;
        }

        responseDTO.setImgName(imgName);
        responseDTO.setImgLogiPath("/" + logiProfilePath);
        responseDTO.setImgPhyPath(userInfo.getImgPhyPath());

        responseDTO.setChkTemPassword(userInfo.getChkTemPassword());


        return responseDTO;
    }

    @ResponseBody
    @RequestMapping({"/updateUserInfo", "/updateUserInfo.do"})
    public Map<String, Object> updateUserInfo(
            @ModelAttribute IUpdateDTO dto,
            HttpSession session) throws Exception {

        String loginId = (String) session.getAttribute("loginId");

        dto.setLoginID(loginId);

        int result =instructorMypageService.updateInstructorMypage(dto);

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

        int result = instructorMypageService.changePassword(paramDTO);

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

    @ResponseBody
    @RequestMapping({"/uploadProfileImage", "/uploadProfileImage.do"})
    public Map<String, Object> uploadProfileImage(
            HttpSession session,
            MultipartFile file) throws Exception {

        String loginId = (String) session.getAttribute("loginId");
        return instructorMypageService.uploadProfileImage(loginId, file);
    }


    @ResponseBody
    @RequestMapping({"/getEduCareer", "/getEduCareer.do"})
    public Map<String, Object> getEduCareer(HttpSession session) {

        String loginId = (String) session.getAttribute("loginId");

        IEduCareerVO vo = instructorMypageService.getEduCareer(loginId);

        Map<String, Object> result = new HashMap<>();
        result.put("eduLevel", vo != null ? vo.getEduLevel() : "");
        result.put("career", vo != null ? vo.getCareer() : "");

        return result;
    }

    @ResponseBody
    @RequestMapping({"/updateEduCareer", "/updateEduCareer.do"})
    public Map<String, Object> updateEduCareer(
            HttpSession session,
            String eduLevel,
            String career) throws Exception {

        String loginId = (String) session.getAttribute("loginId");

        IUpdateEduCareerDTO dto = new IUpdateEduCareerDTO();
        dto.setLoginID(loginId);
        dto.setEduLevel(eduLevel);
        dto.setCareer(career);

        int result = instructorMypageService.updateEduCareer(dto);

        Map<String, Object> map = new HashMap<>();
        map.put("result", result > 0 ? "SUCCESS" : "FAIL");
        return map;
    }

    //내 강의 목록
    @RequestMapping({"/getMyCourseList", "/getMyCourseList.do"})
    @ResponseBody
    public Map<String, Object> getMyCourseList(@RequestParam Map<String, Object> paramMap, HttpSession session) {

        String loginId = (String) session.getAttribute("loginId");
        paramMap.put("loginId", loginId);

        int currentPage = Integer.parseInt(paramMap.get("currentPage").toString());
        int pageSize = Integer.parseInt(paramMap.get("pageSize").toString());

        int startRow = (currentPage - 1) * pageSize;

        paramMap.put("startRow", startRow);
        paramMap.put("pageSize", pageSize);

        List<IMyCourseVO> list = instructorMypageService.getMyCourseList(paramMap);
        int totalCount = instructorMypageService.getMyCourseListCnt(paramMap);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", list);
        resultMap.put("totalCount", totalCount);

        return resultMap;
    }

}
