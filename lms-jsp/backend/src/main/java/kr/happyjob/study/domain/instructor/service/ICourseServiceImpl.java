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
    // Set logger
    private final Logger logger = LogManager.getLogger(this.getClass());

    // Get class name for logger
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

}
