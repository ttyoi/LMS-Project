package kr.happyjob.study.domain.instructor.controller;

import kr.happyjob.study.domain.instructor.model.ICourseAttDtlVO;
import kr.happyjob.study.domain.instructor.model.ICourseAttRatioVO;
import kr.happyjob.study.domain.instructor.model.ICourseAttendanceVO;
import kr.happyjob.study.domain.instructor.model.ICourseVO;
import kr.happyjob.study.domain.instructor.service.IAttendanceService;
import kr.happyjob.study.domain.instructor.service.ICourseService;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/inst/")
public class IAttendanceController {
    // Set logger
    private final Logger logger = LogManager.getLogger(this.getClass());

    // Get class name for logger
    private final String className = this.getClass().toString();

    @Autowired
    private ICourseService courseService;
    @Autowired
    private IAttendanceService attendanceService;
    String path = "instructor/icourse/couratt";

    @GetMapping("attendance")
    public String attendance(HttpServletRequest request) {
        logger.info(className + ": attendance");

        logger.info("+ End " + className + ".coursePlan");
        return path+"/attendanceView";
    }

    @PostMapping("allCourseList.do")
    @ResponseBody
    public Map<String, Object> courseListJson(HttpServletRequest request,
                                              @RequestBody Map<String, Object> paramMap) {

        logger.info("+ Start " + className + ".courseListJson");
        logger.info("   - paramMap : " + paramMap);

        HttpSession session = request.getSession();
        String loginId = session.getAttribute("loginId").toString().trim();
        String userType = session.getAttribute("userType").toString().trim();

        paramMap.put("loginID", loginId);

        if (!paramMap.containsKey("title")) {
            paramMap.put("title", "");
        }

        int currentPage = Integer.parseInt(String.valueOf(paramMap.get("currentPage")));
        int pageSize = Integer.parseInt(String.valueOf(paramMap.get("pageSize")));
        int pageIndex = (currentPage - 1) * pageSize;

        paramMap.put("pageIndex", pageIndex);
        paramMap.put("pageSize", pageSize);

        List<ICourseVO> courseList = courseService.courseList(paramMap);
        int totalCount = courseService.totalCntCourse(paramMap);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", courseList);
        resultMap.put("totalCount", totalCount);
        resultMap.put("currentPage", currentPage);
        resultMap.put("pageSize", pageSize);
        resultMap.put("loginID", loginId);
        resultMap.put("userType", userType);

        logger.info("+ End " + className + ".courseListJson");
        return resultMap;
    }
    @PostMapping("courseStudentList.do")
    @ResponseBody
    public Map<String, Object> courseStudentListJson(HttpServletRequest request,
                                                     @RequestBody Map<String, Object> paramMap) {

        HttpSession session = request.getSession();
        String loginId = session.getAttribute("loginId").toString();
        String userType = session.getAttribute("userType").toString();

        paramMap.put("loginID", loginId);

        int currentPage = Integer.parseInt((String) paramMap.get("currentPage"));
        int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
        int pageIndex = (currentPage - 1) * pageSize;

        paramMap.put("pageIndex", pageIndex);
        paramMap.put("pageSize", pageSize);

        List<ICourseAttRatioVO> list = attendanceService.getCourseStudentList(paramMap);
        int totalCount = attendanceService.studentAttendanceCnt(paramMap);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", list);
        resultMap.put("totalCount", totalCount);
        resultMap.put("currentPage", currentPage);
        resultMap.put("pageSize", pageSize);
        resultMap.put("loginID", loginId);
        resultMap.put("userType", userType);

        return resultMap;
    }

    @PostMapping("stuAttDtlList.do")
    @ResponseBody
    public Map<String, Object> stuAttDtlListJson(HttpServletRequest request,
                                                 @RequestBody Map<String, Object> paramMap) {

        HttpSession session = request.getSession();
        String loginId = session.getAttribute("loginId").toString();
        String userType = session.getAttribute("userType").toString();

        paramMap.put("loginID", loginId);

        int currentPage = Integer.parseInt((String) paramMap.get("currentPage"));
        int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
        int pageIndex = (currentPage - 1) * pageSize;

        paramMap.put("pageIndex", pageIndex);
        paramMap.put("pageSize", pageSize);

        List<ICourseAttDtlVO> list = attendanceService.getStuAttDtlList(paramMap);
        int totalCount = attendanceService.getStuAttDtlCnt(paramMap);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", list);
        resultMap.put("totalCount", totalCount);
        resultMap.put("currentPage", currentPage);
        resultMap.put("pageSize", pageSize);
        resultMap.put("loginID", loginId);
        resultMap.put("userType", userType);

        return resultMap;
    }

        @PostMapping("modifyStuAtt.do")
    @ResponseBody
    public Map<String, Object> modifyStuAtt(Model model, HttpServletRequest request, @RequestBody Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".modifyStuAtt");
        logger.info("   - paramMap : " + paramMap);
        HttpSession session = request.getSession();
//        String loginId =  session.getAttribute("loginId").toString();
//        String profId = session.getAttribute("loginId").toString();
        String userType =  session.getAttribute("userType").toString();
//        logger.info("   - loginId : " + loginId);
        logger.info("   - userType : " + userType);
//        paramMap.put("loginID", loginId);
//        int currentPage = Integer.parseInt((String)paramMap.get("currentPage"));
//        int pageSize = Integer.parseInt((String)paramMap.get("pageSize"));
//        int pageIndex = (currentPage-1)*pageSize;
//        logger.info("   - currentPage : " + currentPage);
//        logger.info("   - pageSize : " + pageSize);
//        logger.info("   - pageIndex : " + pageIndex);
//        paramMap.put("pageIndex", pageIndex);
//        paramMap.put("loginID", loginId);
//        paramMap.put("writerID", profId);
        paramMap.put("userType", userType);

        Map<String, Object> resultMap = new HashMap<>();
//        resultMap.put("loginID", loginId);
//        resultMap.put("userType", userType);
//        resultMap.put("currentPage", currentPage);
//        resultMap.put("pageSize", pageSize);
        int updateCnt = attendanceService.updateStuAtt(paramMap);

        if(updateCnt > 0) {
            resultMap.put("resultMsg", "SUCCESS");
        }else{
            resultMap.put("resultMsg", "FAIL");
        }

        logger.info("+ End " + className + ".modifyStuAtt");
        return resultMap;
    }

    @PostMapping("stuAttDtlRegList.do")
    @ResponseBody
    public Map<String, Object> stuAttDtlRegListJson(HttpServletRequest request,
                                                    @RequestBody Map<String, Object> paramMap) {

        HttpSession session = request.getSession();
        String loginId = session.getAttribute("loginId").toString();
        String userType = session.getAttribute("userType").toString();

        paramMap.put("loginID", loginId);
        paramMap.put("userType", userType);

        List<ICourseAttRatioVO> list = attendanceService.getStdAttDtlRegList(paramMap);
        int totalCount = attendanceService.studentAttendanceCnt(paramMap);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", list);
        resultMap.put("totalCount", totalCount);
        resultMap.put("loginID", loginId);
        resultMap.put("userType", userType);

        return resultMap;
    }


    @PostMapping("stuAttDtlRegList")
    public String stuAttDtlRegList(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".stuAttDtlRegList");
        logger.info("   - paramMap : " + paramMap);
        HttpSession session = request.getSession();
        String loginId =  session.getAttribute("loginId").toString();
        String userType =  session.getAttribute("userType").toString();
        logger.info("   - loginId : " + loginId);
        logger.info("   - userType : " + userType);
        paramMap.put("loginID", loginId);
        paramMap.put("loginID", loginId);
        paramMap.put("userType", userType);

        List<ICourseAttRatioVO> stdAttDtlRegList = attendanceService.getStdAttDtlRegList(paramMap);
        int totalCnt = attendanceService.studentAttendanceCnt(paramMap);
        logger.info("   - stdAttDtlRegList : " + stdAttDtlRegList);
        logger.info("   - totalCnt : " + totalCnt);

        model.addAttribute("loginID", loginId);
        model.addAttribute("userType", userType);
        model.addAttribute("stdAttDtlRegList", stdAttDtlRegList);
        model.addAttribute("totalCount", totalCnt);
        logger.info("+ End " + className + ".stuAttDtlRegList");
        return path+"/studentAttDtlRegList";
    }

//    @PostMapping("stuAttDtlReg.do")
//    @ResponseBody
//    public Map<String, Object> stuAttDtlReg(Model model, HttpServletRequest request, @RequestBody List<ICourseAttendanceVO> paramList, ServletResponse servletResponse) {
//        logger.info("+ Start " + className + ".stuAttDtlReg");
//        logger.info("   - paramList : " + paramList);
//        HttpSession session = request.getSession();
//        String loginId =  session.getAttribute("loginId").toString();
//        String userType =  session.getAttribute("userType").toString();
//        logger.info("   - loginId : " + loginId);
//        logger.info("   - userType : " + userType);
//        Map<String, Object> resultMap = new HashMap<>();
//        resultMap.put("loginID", loginId);
//        resultMap.put("userType", userType);
//        int dupCnt = attendanceService.stuAttDtlDupRegCnt(paramList);
//        if(dupCnt != 0) {
//            logger.info("   - dupCnt : " + dupCnt);
//            resultMap.put("resultMsg", "duplicated");
//            return resultMap;
//        }
//        for(ICourseAttendanceVO list : paramList){
//            logger.info("   - list : " + list.getCourse_id());
//        }
//        int regCnt = attendanceService.stuAttDtlReg(paramList);
//
//        if(regCnt > 0) {
//            resultMap.put("resultMsg", "SUCCESS");
//        }else{
//            resultMap.put("resultMsg", "ERROR");
//        }
//
//        return resultMap;
//    }
@PostMapping("stuAttDtlReg.do")
@ResponseBody
public Map<String, Object> stuAttDtlReg(Model model, HttpServletRequest request, @RequestBody List<ICourseAttendanceVO> paramList, ServletResponse servletResponse) {
    logger.info("+ Start " + className + ".stuAttDtlReg");

    HttpSession session = request.getSession();
    String loginId = session.getAttribute("loginId").toString();
    String userType = session.getAttribute("userType").toString();

    Map<String, Object> resultMap = new HashMap<>();
    int totalCount = 0;

    // 1. 리스트를 돌면서 한 명씩 처리합니다.
    for (ICourseAttendanceVO vo : paramList) {

        // 2. [중복체크용] 리스트 만들기 (서비스가 List를 원하니까)
        List<ICourseAttendanceVO> listForDup = new ArrayList<>();
        listForDup.add(vo);
        int dupCnt = attendanceService.stuAttDtlDupRegCnt(listForDup);

        if (dupCnt > 0) {
            // 3. [업데이트용] 맵 만들기 (서비스가 Map을 원하니까)
            Map<String, Object> mapForUpdate = new HashMap<>();
            mapForUpdate.put("course_id", vo.getCourse_id());
            mapForUpdate.put("att_sta_code", vo.getAtt_sta_code());
            mapForUpdate.put("stu_loginID", vo.getLoginID()); // XML 쿼리의 #{stu_loginID}와 이름 맞춤
            mapForUpdate.put("att_code", vo.getAttendance_code()); // XML 쿼리의 #{att_code}와 이름 맞춤
            mapForUpdate.put("date", vo.getDate());

            totalCount += attendanceService.updateStuAtt(mapForUpdate);
            logger.info("   - [Update] 학생: " + vo.getLoginID());
        } else {
            // 4. [신규등록용] 리스트 만들기 (서비스가 List를 원하니까)
            List<ICourseAttendanceVO> listForReg = new ArrayList<>();
            listForReg.add(vo);

            totalCount += attendanceService.stuAttDtlReg(listForReg);
            logger.info("   - [Insert] 학생: " + vo.getLoginID());
        }
    }

    if (totalCount > 0) {
        resultMap.put("resultMsg", "SUCCESS");
    } else {
        resultMap.put("resultMsg", "ERROR");
    }

    return resultMap;
}
}
