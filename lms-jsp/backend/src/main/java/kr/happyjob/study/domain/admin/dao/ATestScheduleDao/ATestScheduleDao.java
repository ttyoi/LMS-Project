package kr.happyjob.study.domain.admin.dao.ATestScheduleDao;

import kr.happyjob.study.domain.admin.model.ATestSchedule.ATestSchedule;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class ATestScheduleDao {

    private static final String NAMESPACE = "kr.happyjob.study.mapper.admin.ATestMapper.";

    @Autowired
    private SqlSessionTemplate sqlSession;

    @SuppressWarnings("unchecked")
    public List<ATestSchedule> selectTestScheduleList() {
        return (List<ATestSchedule>) sqlSession.selectList(
                "kr.happyjob.study.mapper.admin.ATestMapper.selectTestScheduleList"
        );
    }

    public ATestSchedule selectTestScheduleDetail(int courseId,int period) {
        Map<String, Object> param = new HashMap<>();
        param.put("courseId", courseId);
        param.put("period", period);

        return (ATestSchedule)  sqlSession.selectOne(
                NAMESPACE + "selectTestScheduleDetail",
                param
        );
    }

    public int updateStatus(int courseId ,int period, int status) {
        Map<String, Object> param = new HashMap<>();
        param.put("courseId", courseId);
        param.put("period", period);
        param.put("status", status);
        return sqlSession.update(NAMESPACE + "updateTestScheduleStatus", param);
    }

}

