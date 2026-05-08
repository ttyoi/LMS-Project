package kr.happyjob.study.domain.common.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.domain.common.dao.InstructorDAO;
import kr.happyjob.study.domain.common.model.InstructorVO;

@Service
public class InstructorServiceImpl implements InstructorService {
	@Autowired InstructorDAO instructorDao;
	
	@Override
	public List<InstructorVO> getInstList() {
		return instructorDao.getInstList();
	}

	@Override
	public List<InstructorVO> getDelayedInstList() {
		return instructorDao.getDelayedInstList();
	}

	@Override
	public List<InstructorVO> getRegisteredInstList() {
		return instructorDao.getRegisteredInstList();
	}

	@Override
	public List<InstructorVO> getRegisteredInstList(Map<String, Object> paramMap) {
		return instructorDao.getRegisteredInstList(paramMap);
	}

}
