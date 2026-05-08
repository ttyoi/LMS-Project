package kr.happyjob.study.domain.instructor.service;

import kr.happyjob.study.domain.instructor.model.ICourseVO;

import java.util.List;
import java.util.Map;

public interface ICourseService {
    public List<ICourseVO> courseList(Map<String, Object> paramMap);
    public int totalCntCourse(Map<String, Object> paramMap);
    public ICourseVO getCourseDetail(Map<String, Object> paramMap);
    public List<ICourseVO> findCourseList(Map<String, Object> paramMap);
    public List<ICourseVO> weeklySchedule(Map<String, Object> paramMap);
}
