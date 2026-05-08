package kr.happyjob.study.domain.dashboard.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.domain.dashboard.dao.DashboardDao;
import kr.happyjob.study.domain.dashboard.model.DashboardModel;
import kr.happyjob.study.domain.dashboard.model.ClassroomModel;
import kr.happyjob.study.domain.dashboard.model.ExamMonthModel;


@Service
public class DashboardServiceImpl implements DashboardService {
	
   // Set logger
   private final Logger logger = LogManager.getLogger(this.getClass());
   
   // Get class name for logger
   private final String className = this.getClass().toString();
   
   @Autowired
   DashboardDao dashboardDao;

   @Override
	public int cntInstructor(Map<String, Object> paramMap) throws Exception {
		int cntInstructor = dashboardDao.cntInstructor(paramMap);
		return cntInstructor;
	}

	@Override
	public int cntStudent(Map<String, Object> paramMap) throws Exception {
		int cntStudent = dashboardDao.cntStudent(paramMap);
		return cntStudent;
	}

	@Override
	public int cntCourse(Map<String, Object> paramMap) throws Exception {
		int cntCourse = dashboardDao.cntCourse(paramMap);
		return cntCourse;
	}

	/** 이번 달 시험 과목 조회 */
	@Override
	public List<ExamMonthModel> getExamMonth(Map<String, Object> paramMap) throws Exception {
		return dashboardDao.getExamMonth(paramMap);
	}

	/** 수업 중인 강의실 목록 조회 */
	@Override
	public List<ClassroomModel> getActiveClassrooms(Map<String, Object> paramMap) throws Exception {
		return dashboardDao.getActiveClassrooms(paramMap);
	}
	   
   /*@Override
   public DashboardModel goChart(Map<String, Object> paramMap) throws Exception {
      
	   DashboardModel goChart = dashboardDao.goChart(paramMap);
      
      return goChart;
   }
   
	@Override
	public int cntEngineer(Map<String, Object> paramMap) throws Exception {
		int cntEngineer = dashboardDao.cntEngineer(paramMap);
		return cntEngineer;
	}
	
	@Override
	public int cntCompany(Map<String, Object> paramMap) throws Exception {
		int cntCompany = dashboardDao.cntCompany(paramMap);
		return cntCompany;
	}
	
	@Override
	public int cntProject(Map<String, Object> paramMap) throws Exception {
		int cntProject = dashboardDao.cntProject(paramMap);
		return cntProject;
	}*/

}
