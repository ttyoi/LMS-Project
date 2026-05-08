package kr.happyjob.study.domain.admin.service;

import kr.happyjob.study.domain.admin.model.AUserCoursesListVO;


import java.util.List;

public interface AUserCoursesListService {

    List<AUserCoursesListVO> getUserCoursesList(String loginID);
    List<AUserCoursesListVO> getInstCoursesList(String loginID);
}
