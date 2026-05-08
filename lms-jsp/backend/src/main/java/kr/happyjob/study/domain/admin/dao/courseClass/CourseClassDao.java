package kr.happyjob.study.domain.admin.dao.courseClass;

import kr.happyjob.study.domain.admin.model.courseClass.CourseClass;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
@Repository
public class CourseClassDao {

    @Autowired
    private SqlSession sqlSession;  // SqlSessionTemplate 대신 SqlSession

    private static final String NAMESPACE = "kr.happyjob.study.mapper.admin.ACourseClassMapper.";

    // 리스트
    public List<Map<String, Object>> listClassrooms(String search) {
        return sqlSession.selectList(NAMESPACE + "listClassrooms", search);
    }
    // 신규
    public List<CourseClass> listClassroomsPaging(int offset, int pageSize, String search) {
        Map<String, Object> param = new HashMap<>();
        param.put("offset", offset);
        param.put("pageSize", pageSize);
        param.put("search", search != null ? search.trim() : null);

        return sqlSession.selectList(
                NAMESPACE + "listClassroomsPaging",
                param
        );
    }

    public int countClassrooms(String search) {
        Map<String, Object> param = new HashMap<>();
        param.put("search", search != null ? search.trim() : null);
        return (Integer) sqlSession.selectOne(
                NAMESPACE + "countClassrooms",
                param
        );
    }

    public List<Map<String, Object>> detailClassroomByName(String className) {
        return sqlSession.selectList(NAMESPACE + "detailClassroomByName", className);
    }

    public int insertClassroom(CourseClass courseClass) {
        return sqlSession.insert(NAMESPACE + "insertClassroom", courseClass);
    }

    public int updateClassroom(CourseClass courseClass) {
        return sqlSession.update(NAMESPACE + "updateClassroom", courseClass);
    }

    public int deleteClassroomByName(String className) {
        return sqlSession.update(NAMESPACE + "deleteClassroomByName", className);
    }

    public int updateClassroomInfo(Map<String, Object> params) {
        return sqlSession.update(NAMESPACE + "updateClassroomInfo", params);
    }

}