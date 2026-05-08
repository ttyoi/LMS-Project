package kr.happyjob.study.domain.instructor.dao;

import kr.happyjob.study.domain.instructor.model.ICourseAttDtlVO;
import kr.happyjob.study.domain.instructor.model.ICourseAttRatioVO;
import kr.happyjob.study.domain.instructor.model.ICourseAttendanceVO;

import java.util.List;
import java.util.Map;

public interface IAttendanceDAO {
    public List<ICourseAttRatioVO> getCourseStudentList(Map<String, Object> paramMap);
    public int studentAttendanceCnt(Map<String, Object> paramMap);
    public List<ICourseAttDtlVO> getStuAttDtlList(Map<String, Object> paramMap);
    public int getStuAttDtlCnt(Map<String, Object> paramMap);
    public int updateStuAtt(Map<String, Object> paramMap);
    public List<ICourseAttRatioVO> getStdAttDtlRegList(Map<String, Object> paramMap);
    public int stuAttDtlReg(ICourseAttendanceVO courseAttendanceVO);
    public int stuAttDtlDupRegCnt(ICourseAttendanceVO courseAttendanceVO);

}
