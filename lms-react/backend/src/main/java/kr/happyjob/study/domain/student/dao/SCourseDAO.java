package kr.happyjob.study.domain.student.dao;

import kr.happyjob.study.domain.student.model.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;


public interface SCourseDAO {
    public List<SCourseListDTO> loadAllCourses(SSearchParamsDTO searchParamsDTO);
    public SCourseDetailDTO courseDetail(int course_id);
    List<SEnrollCheckDTO> loadbaseDTO(String loginID);
    void applyCourse(@Param("course_id") Long course_id, @Param("loginID") String loginID);
    void deleteCourse(@Param("course_id") Long course_id, @Param("loginID") String loginID);


    public List<SMyCourseListDTO> myCourseList(SSearchParamsDTO searchParamsDTO);
    public SMyCosDetailDTO myCourseDetail(@Param("loginID") String loginID, @Param("course_id") int courseId);

    List<SSearchKeyDTO> loadSearchKeys(String groupCode);


    int courseTotalCnt(SSearchParamsDTO searchParamsDTO);

    int myCourseTotalCnt(SSearchParamsDTO searchParamsDTO);

    int existsCompletedCourse(@Param("course_id") Long course_id,
                              @Param("loginID") String loginID);

    int existsAppliedCourse(@Param("course_id") Long course_id,
                            @Param("loginID") String loginID);

    List<Map<String, Object>> myCourseAttCalendar(Map<String, Object> params);

  int updateCourseAction(Map<String, Object> data);
}
