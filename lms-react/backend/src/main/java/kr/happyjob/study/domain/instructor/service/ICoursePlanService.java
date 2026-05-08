package kr.happyjob.study.domain.instructor.service;

import kr.happyjob.study.domain.admin.model.AUserVO;
import kr.happyjob.study.domain.instructor.model.ICourseClassVO;
import kr.happyjob.study.domain.instructor.model.ICourseTimeVO;
import kr.happyjob.study.domain.instructor.model.ICourseVO;

import java.util.List;
import java.util.Map;

public interface ICoursePlanService {
    public List<AUserVO> getInstlist();
    public List<ICourseClassVO> getClassList();
    public List<ICourseTimeVO> getClassTimeList();
    public int saveCoursePlan(Map<String, Object> paramMap);
    public List<ICourseVO> getClassPlanList(Map<String, Object> paramMap);
    public int totalCntCoursePlan(Map<String, Object> paramMap);
    public ICourseVO getCoursPlanDetail(Map<String, Object> paramMap);
    public int updateCoursePlan(Map<String, Object> paramMap);
    public int deleteCoursePlan(Map<String, Object> paramMap);
    public List<ICourseVO> searchCoursePlanList(Map<String, Object> paramMap);
    public int searchCoursePlanCnt(Map<String, Object> paramMap);

    public int checkOverlap(Map<String, Object> paramMap);

}
