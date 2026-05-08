package kr.happyjob.study.domain.instructor.dao;

import kr.happyjob.study.domain.instructor.model.ICourseVO;

import java.util.List;
import java.util.Map;

public interface ICourseDAO {
    public List<ICourseVO> courseList(Map<String, Object> paramMap);
    public int totalCntCourse(Map<String, Object> paramMap);
    public ICourseVO courseDetail(Map<String, Object> paramMap);
    public List<ICourseVO> searchCourseList(Map<String, Object> paramMap);
    public List<ICourseVO> weeklySchedule(Map<String, Object> paramMap);

    public List<ICourseVO> allCourseList(Map<String, Object> paramMap);
    public int totalCntAllCourse(Map<String, Object> paramMap);
    public ICourseVO allCourseDetail(Map<String, Object> paramMap);

    public List<ICourseVO> classList(Map<String, Object> paramMap);
    public List<ICourseVO> timeList(Map<String, Object> paramMap);

    public void courseSave(Map<String, Object> paramMap);
    public void courseUpdate(Map<String, Object> paramMap);
    public void courseDelete(Map<String, Object> paramMap);

    public List<ICourseVO> subInstructorList(Map<String, Object> paramMap);


}
