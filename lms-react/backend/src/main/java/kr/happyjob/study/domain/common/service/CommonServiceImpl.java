package kr.happyjob.study.domain.common.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.domain.common.dao.CommonDAO;
import kr.happyjob.study.domain.common.model.AttendanceStatusVO;
import kr.happyjob.study.domain.common.model.CourseClassVO;
import kr.happyjob.study.domain.common.model.CourseStatusVO;
import kr.happyjob.study.domain.common.model.CourseTimeVO;
import kr.happyjob.study.domain.common.model.DetailCodeVO;
import kr.happyjob.study.domain.common.model.QnaCategoryVO;
import kr.happyjob.study.domain.common.model.SCourseStatusVO;

@Service
public class CommonServiceImpl implements CommonService {
	@Autowired private CommonDAO commonDao;

	@Override
	public List<AttendanceStatusVO> attendanceStatusList() {
		return commonDao.attendanceStatusList();
	}

	@Override
	public List<CourseClassVO> courseClassList() {
		return commonDao.courseClassList();
	}

	@Override
	public List<CourseStatusVO> courseStatusList() {
		return commonDao.courseStatusList();
	}

	@Override
	public List<CourseTimeVO> courseTimeList() {
		return commonDao.courseTimeList();
	}

	@Override
	public List<DetailCodeVO> detailCodeList() {
		return commonDao.detailCodeList();
	}

	@Override
	public List<QnaCategoryVO> qnaCategoryList() {
		return commonDao.qnaCategoryList();
	}

	@Override
	public List<SCourseStatusVO> sCourseStatusList() {
		return commonDao.sCourseStatusList();
	}
}
