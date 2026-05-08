package kr.happyjob.study.domain.instructor.service;

import kr.happyjob.study.domain.admin.model.AUserVO;
import kr.happyjob.study.domain.instructor.dao.ICoursePlanDAO;
import kr.happyjob.study.domain.instructor.model.ICourseClassVO;
import kr.happyjob.study.domain.instructor.model.ICourseTimeVO;
import kr.happyjob.study.domain.instructor.model.ICourseVO;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@Service
public class ICoursePlanServiceImpl implements ICoursePlanService {
    // Set logger
    private final Logger logger = LogManager.getLogger(this.getClass());

    // Get class name for logger
    private final String className = this.getClass().toString();

    @Autowired
    ICoursePlanDAO coursePlanDao;

    @Override
    public List<AUserVO> getInstlist() {
        return coursePlanDao.getInstlist();
    }
    @Override
    public List<ICourseClassVO> getClassList() {
        return coursePlanDao.getClassList();
    }
    @Override
    public List<ICourseTimeVO> getClassTimeList() {
        return coursePlanDao.getClassTimeList();
    }
    @Override
    public int saveCoursePlan(Map<String, Object> paramMap) {
        return coursePlanDao.saveCoursePlan(paramMap);
    }
    @Override
    public List<ICourseVO> getClassPlanList(Map<String, Object> paramMap) {
        return coursePlanDao.getClassPlanList(paramMap);
    }

    @Override
    public int totalCntCoursePlan(Map<String, Object> paramMap) {
        return coursePlanDao.totalCntCoursePlan(paramMap);
    }
    @Override
    public ICourseVO getCoursPlanDetail(Map<String, Object> paramMap) {
        return coursePlanDao.getCoursPlanDetail(paramMap);
    }
    //강의계획 수정
    @Override
    public int updateCoursePlan(Map<String, Object> paramMap) {
        return coursePlanDao.updateCoursePlan(paramMap);
    }

    @Override
    public int deleteCoursePlan(Map<String, Object> paramMap) {
        return coursePlanDao.deleteCoursePlan(paramMap);
    }

    @Override
    public List<ICourseVO> searchCoursePlanList(Map<String, Object> paramMap) {
        return coursePlanDao.searchCoursePlanList(paramMap);
    }

    @Override
    public int searchCoursePlanCnt(Map<String, Object> paramMap) {
        return coursePlanDao.searchCoursePlanCnt(paramMap);
    }

    @Override
    public int checkOverlap(Map<String, Object> paramMap) {
        return coursePlanDao.checkOverlap(paramMap);
    }

}


