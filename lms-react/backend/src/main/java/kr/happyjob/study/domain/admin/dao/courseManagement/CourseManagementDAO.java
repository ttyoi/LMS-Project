package kr.happyjob.study.domain.admin.dao.courseManagement;

import kr.happyjob.study.domain.admin.model.courseManagement.CourseManagement;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class CourseManagementDAO {

    @Autowired
    private SqlSessionTemplate sqlSession;

    private static final String NAMESPACE = "kr.happyjob.study.mapper.admin.ACourseManagementMapper";


    /**
     * 강의 목록 조회 (상태 포함)
     */
    public List<CourseManagement> selectCourseList() {
        List list = sqlSession.selectList(NAMESPACE + ".selectCourseList");
        return list;
    }

    /**
     * 강의 목록 페이징 조회 (검색 및 필터 포함)
     */
    public List<CourseManagement> selectCourseListPaging(Map<String, Object> params) {
        // selectList<타입명>을 명시하거나 자동으로 추론하게 둡니다.
        return (List<CourseManagement>) sqlSession.selectList(NAMESPACE + ".selectCourseListPaging", params);
    }

    /**
     * 강의 전체 개수 조회 (필터링된 개수 포함)
     */
    public int countCourses(Map<String, Object> params) {
        // selectOne은 기본적으로 Object를 리턴하므로 Integer로 형변환(Casting)이 꼭 필요합니다.
        return (int) sqlSession.selectOne(NAMESPACE + ".countCourses", params);
    }


    /**
     * 강의 상세 조회
     */
    public CourseManagement selectCourseDetail(int courseId) {
        Object obj = sqlSession.selectOne(NAMESPACE + ".selectCourseDetail", courseId);
        return (CourseManagement) obj;
    }

    /**
     * 강의 정보 수정
     */
    public int updateCourse(CourseManagement course) {
        return sqlSession.update(NAMESPACE + ".updateCourse", course);
    }

    /**
     * 강의 삭제
     */
    public int deleteCourse(int courseId) {
        return sqlSession.delete(NAMESPACE + ".deleteCourse", courseId);
    }

    /**
     * 강의신청 상태 변경 (승인/거절/취소)
     */
    public int updateCourseStatus(int courseId, String cosStaCode) {
        java.util.HashMap<String, Object> params = new java.util.HashMap<>();

        // XML의 #{course_id}와 일치시켜야 함
        params.put("course_id", courseId);

        // XML의 #{cos_sta_code}와 일치시켜야 함
        params.put("cos_sta_code", cosStaCode);

        return sqlSession.update(NAMESPACE + ".updateCourseStatus", params);
    }
}
