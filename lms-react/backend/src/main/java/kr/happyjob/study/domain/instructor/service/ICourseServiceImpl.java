package kr.happyjob.study.domain.instructor.service;

import kr.happyjob.study.domain.instructor.dao.ICourseDAO;
import kr.happyjob.study.domain.instructor.model.ICourseVO;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ICourseServiceImpl implements ICourseService {

    private final Logger logger = LogManager.getLogger(this.getClass());
    private final String className = this.getClass().toString();

    @Autowired
    private ICourseDAO courseDao;

    @Override
    public List<ICourseVO> courseList(Map<String, Object> paramMap) {
        return courseDao.courseList(paramMap);
    }

    @Override
    public int totalCntCourse(Map<String, Object> paramMap) {
        return courseDao.totalCntCourse(paramMap);
    }

    @Override
    public ICourseVO getCourseDetail(Map<String, Object> paramMap) {
        return courseDao.courseDetail(paramMap);
    }

    @Override
    public List<ICourseVO> findCourseList(Map<String, Object> paramMap) {
        return courseDao.searchCourseList(paramMap);
    }

    @Override
    public List<ICourseVO> weeklySchedule(Map<String, Object> paramMap) {
        return courseDao.weeklySchedule(paramMap);
    }

    @Override
    public List<ICourseVO> allCourseList(Map<String, Object> paramMap) {
        return courseDao.allCourseList(paramMap);
    }

    @Override
    public int totalCntAllCourse(Map<String, Object> paramMap) {
        return courseDao.totalCntAllCourse(paramMap);
    }

    @Override
    public ICourseVO getAllCourseDetail(Map<String, Object> paramMap) {
        return courseDao.allCourseDetail(paramMap);
    }

    @Override
    public List<ICourseVO> classList(Map<String, Object> paramMap) {
        return courseDao.classList(paramMap);
    }

    @Override
    public List<ICourseVO> timeList(Map<String, Object> paramMap) {
        return courseDao.timeList(paramMap);
    }

    @Override
    public void courseSave(Map<String, Object> paramMap) {
        courseDao.courseSave(paramMap);
    }

    @Override
    public void courseUpdate(Map<String, Object> paramMap) {
        courseDao.courseUpdate(paramMap);
    }

    @Override
    public void courseDelete(Map<String, Object> paramMap) {
        courseDao.courseDelete(paramMap);
    }

    @Override
    public List<ICourseVO> subInstructorList(Map<String, Object> paramMap) {
        return courseDao.subInstructorList(paramMap);
    }
}