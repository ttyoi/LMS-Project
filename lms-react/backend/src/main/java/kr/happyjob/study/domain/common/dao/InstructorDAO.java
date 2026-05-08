package kr.happyjob.study.domain.common.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.domain.common.model.InstructorVO;

public interface InstructorDAO {
	public List<InstructorVO> getInstList();
	public List<InstructorVO> getDelayedInstList();
	public List<InstructorVO> getRegisteredInstList();
	public List<InstructorVO> getRegisteredInstList(Map<String, Object> paramMap);
}
