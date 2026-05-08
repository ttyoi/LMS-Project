package kr.happyjob.study.domain.admin.service;

import kr.happyjob.study.domain.admin.dao.AUserCoursesListDAO;
import kr.happyjob.study.domain.admin.model.AUserCoursesListVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class AUserCoursesListServiceImpl implements AUserCoursesListService {
    @Autowired
    private AUserCoursesListDAO aUserCoursesListDAO;

    @Override
    public List<AUserCoursesListVO> getUserCoursesList(String loginID){
        return aUserCoursesListDAO.selectUserCoursesList(loginID);
    }

    @Override
    public List<AUserCoursesListVO> getInstCoursesList(String loginID){
        return aUserCoursesListDAO.selectInstCourses(loginID);
    }
}
