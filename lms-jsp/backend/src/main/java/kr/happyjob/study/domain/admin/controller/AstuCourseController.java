package kr.happyjob.study.domain.admin.controller;

import kr.happyjob.study.domain.admin.model.AUserCoursesListVO;
import kr.happyjob.study.domain.admin.service.AUserCoursesListService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class AstuCourseController {

    @Autowired
    private AUserCoursesListService aUserCoursesListService;

    // 학생(개인) 수강 내역
    @PostMapping("/admin/stu/courses")
    @ResponseBody
    public Map<String,Object > getStudentCourses(@RequestParam("loginID") String loginID){
        List<AUserCoursesListVO> list = aUserCoursesListService.getUserCoursesList(loginID);
        Map<String, Object> result= new HashMap<>();
        result.put("result","SUCCESS");
        result.put("list",list);

        return result;
    }

    // 강사(개인) 강의 목록
    @PostMapping("/admin/inst/courses")
    @ResponseBody
    public Map<String,Object > getInstCourses(@RequestParam("loginID") String loginID){
        List<AUserCoursesListVO> list = aUserCoursesListService.getInstCoursesList(loginID);
        Map<String, Object> result= new HashMap<>();
        result.put("result","SUCCESS");
        result.put("list",list);
        return result;
    }


    // 학생(개인) 수강 내역 -- 리액트용
    @PostMapping("/api/admin/stu/courses")
    @ResponseBody
    public Map<String,Object > getStudentCoursesReact(@RequestParam("loginID") String loginID){
        List<AUserCoursesListVO> list = aUserCoursesListService.getUserCoursesList(loginID);
        Map<String, Object> result= new HashMap<>();
        result.put("result","SUCCESS");
        result.put("list",list);

        return result;
    }

    // 강사(개인) 강의 목록 -- 리액트용
    @PostMapping("/api/admin/inst/courses")
    @ResponseBody
    public Map<String,Object > getInstCoursesReact(@RequestParam("loginID") String loginID){
        List<AUserCoursesListVO> list = aUserCoursesListService.getInstCoursesList(loginID);
        Map<String, Object> result= new HashMap<>();
        result.put("result","SUCCESS");
        result.put("list",list);
        return result;
    }

}
