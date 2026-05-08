package kr.happyjob.study.domain.common.dao;

import java.util.List;

import kr.happyjob.study.domain.common.model.AttendanceStatusVO;
import kr.happyjob.study.domain.common.model.CourseClassVO;
import kr.happyjob.study.domain.common.model.CourseStatusVO;
import kr.happyjob.study.domain.common.model.CourseTimeVO;
import kr.happyjob.study.domain.common.model.DetailCodeVO;
import kr.happyjob.study.domain.common.model.QnaCategoryVO;
import kr.happyjob.study.domain.common.model.SCourseStatusVO;

public interface CommonDAO {
	public List<AttendanceStatusVO> attendanceStatusList();
	public List<CourseClassVO> courseClassList();
	public List<CourseStatusVO> courseStatusList();
	public List<CourseTimeVO> courseTimeList();
	public List<DetailCodeVO> detailCodeList();
	public List<QnaCategoryVO> qnaCategoryList();
	public List<SCourseStatusVO> sCourseStatusList();
}
