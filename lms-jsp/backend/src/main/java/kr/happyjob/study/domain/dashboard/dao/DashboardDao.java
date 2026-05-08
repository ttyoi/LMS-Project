package kr.happyjob.study.domain.dashboard.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.domain.dashboard.model.ClassroomModel;
import kr.happyjob.study.domain.dashboard.model.DashboardModel;
import kr.happyjob.study.domain.dashboard.model.ClassroomModel;
import kr.happyjob.study.domain.dashboard.model.ExamMonthModel;
import kr.happyjob.study.system.model.NoticeModel;

public interface DashboardDao {

/*    List<ClassroomModel> getActiveClassrooms(Map<String, Object> paramMap);

	public DashboardModel goChart(Map<String, Object> paramMap) throws Exception;

	// 엔지니어 수 조회
	public int cntInstructor(Map<String, Object> paramMap)throws Exception ;
	// 기업 수 조회
	public int cntStudent(Map<String, Object> paramMap)throws Exception ;
	// 프로젝트 수 조회
	public int cntCourse(Map<String, Object> paramMap)throws Exception ;*/

	public int cntInstructor(Map<String, Object> paramMap) throws Exception;
	public int cntStudent(Map<String, Object> paramMap) throws Exception;
	public int cntCourse(Map<String, Object> paramMap) throws Exception;

	/** 이번 달 시험 과목 조회 */
	public List<ExamMonthModel> getExamMonth(Map<String, Object> paramMap) throws Exception;

	/** 수업 중인 강의실 목록 조회 */
	public List<ClassroomModel> getActiveClassrooms(Map<String, Object> paramMap) throws Exception;


}
