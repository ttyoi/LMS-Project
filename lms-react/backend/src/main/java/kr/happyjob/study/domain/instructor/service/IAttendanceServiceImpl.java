package kr.happyjob.study.domain.instructor.service;

import kr.happyjob.study.domain.instructor.dao.IAttendanceDAO;
import kr.happyjob.study.domain.instructor.model.ICourseAttDtlVO;
import kr.happyjob.study.domain.instructor.model.ICourseAttRatioVO;
import kr.happyjob.study.domain.instructor.model.ICourseAttendanceVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@Service
public class IAttendanceServiceImpl implements IAttendanceService {
    @Autowired
    IAttendanceDAO attendanceDAO;

    @Override
    public List<ICourseAttRatioVO> getCourseStudentList(Map<String, Object> paramMap) {
        return attendanceDAO.getCourseStudentList(paramMap);
    }

    @Override
    public int studentAttendanceCnt(Map<String, Object> paramMap) {
        return attendanceDAO.studentAttendanceCnt(paramMap);
    }

    @Override
    public List<ICourseAttDtlVO> getStuAttDtlList(Map<String, Object> paramMap) {
        return attendanceDAO.getStuAttDtlList(paramMap);
    }

    @Override
    public int getStuAttDtlCnt(Map<String, Object> paramMap) {
        return attendanceDAO.getStuAttDtlCnt(paramMap);
    }

    @Override
    public int updateStuAtt(Map<String, Object> paramMap) {
        return attendanceDAO.updateStuAtt(paramMap);
    }

    @Override
    public List<ICourseAttRatioVO> getStdAttDtlRegList(Map<String, Object> paramMap) {
        return attendanceDAO.getStdAttDtlRegList(paramMap);
    }

    @Override
    public int stuAttDtlReg(List<ICourseAttendanceVO> paramList) {
        int stuAttDtlRegCnt = 0;
        for(ICourseAttendanceVO courseAttendanceVO : paramList) {
            stuAttDtlRegCnt += attendanceDAO.stuAttDtlReg(courseAttendanceVO);
        }
        return stuAttDtlRegCnt;
    }

    @Override
    public int stuAttDtlDupRegCnt(List<ICourseAttendanceVO> paramList) {
        int stuAttDtlRegCnt = 0;
        for(ICourseAttendanceVO courseAttendanceVO : paramList) {
            stuAttDtlRegCnt += attendanceDAO.stuAttDtlDupRegCnt(courseAttendanceVO);
        }
        return stuAttDtlRegCnt;
    }
}
