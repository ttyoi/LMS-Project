package kr.happyjob.study.domain.admin.dao;

import kr.happyjob.study.domain.admin.model.AUserCoursesListVO;

import java.util.List;

public interface AUserCoursesListDAO {
    // 목록
    List<AUserCoursesListVO> selectUserCoursesList(String loginID);

    // 강사 강의 목록
    List<AUserCoursesListVO> selectInstCourses(String loginID);

}
