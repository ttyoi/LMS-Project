package kr.happyjob.study.domain.dashboard.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.happyjob.study.domain.dashboard.service.DashboardService;
import kr.happyjob.study.system.model.NoticeModel;
import kr.happyjob.study.system.service.NoticeService;
import kr.happyjob.study.domain.dashboard.dao.DashboardDao;
import kr.happyjob.study.domain.dashboard.model.ClassroomModel;
import kr.happyjob.study.domain.dashboard.model.ExamMonthModel;

@Controller
public class DashboardController {
	
	@Autowired
	NoticeService noticeService;
	
	@Autowired	
	DashboardService dashboardService;
	
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();

	@RequestMapping("/dashboard/dashboard.do")
	public String initDashboard(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		
		logger.info("+ Start " + className + ".initDashboard");
		/* ############## set input data################# */
		paramMap.put("loginId", session.getAttribute("loginId")); // 제목
		paramMap.put("userType", session.getAttribute("userType")); // 오피스 구분 //
																	// 코드
		paramMap.put("reg_date", session.getAttribute("reg_date")); // 등록 일자
		logger.info("   - paramMap : " + paramMap);

		String returnType = "dashboard/dashboardMgr";

		logger.info("+ end " + className + ".initDashboard");

		return returnType;
	}

	// 공지사항 리스트 출력
	@RequestMapping("/inf/listinf.do")
	public String noticeList(Model model, @RequestParam Map<String, Object> paramMap, 
			HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("   - paramMap : " + paramMap);
//		String title = (String) paramMap.get("title");
		
		int currentPage = Integer.parseInt((String) paramMap.get("currentPage")); // 현재페이지
	    int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
	    int pageIndex = (currentPage - 1) * pageSize;
		
		paramMap.put("pageIndex", pageIndex);
		paramMap.put("pageSize", pageSize);
//		paramMap.put("title", title);
		
		// 공지사항 목록 조회
		List<NoticeModel> noticeList = noticeService.noticeList(paramMap);
		model.addAttribute("notice", noticeList);
		
		// 목록 수 추출해서 보내기
		int noticeCnt = noticeService.noticeCnt(paramMap);
		
	    model.addAttribute("noticeCnt", noticeCnt);
	    model.addAttribute("pageSize", pageSize);
	    model.addAttribute("currentPage",currentPage);
	    
	    return "system/noticeList";
	}
	

	@RequestMapping("/inf/listinfvue.do")
	@ResponseBody
	public Map<String, Object> noticeListVue(Model model, @RequestParam Map<String, Object> paramMap, 
			HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("   - paramMap : " + paramMap);
//			String title = (String) paramMap.get("title");
		
		int currentPage = Integer.parseInt((String) paramMap.get("currentPage")); // 현재페이지
	    int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
	    int pageIndex = (currentPage - 1) * pageSize;
		
		paramMap.put("pageIndex", pageIndex);
		paramMap.put("pageSize", pageSize);
//			paramMap.put("title", title);
		
		// 공지사항 목록 조회
		List<NoticeModel> noticeList = noticeService.noticeList(paramMap);
		
		// 목록 수 추출해서 보내기
		int noticeCnt = noticeService.noticeCnt(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("notice", noticeList); // success 용어 담기 
		resultMap.put("noticeCnt", noticeCnt); // 리턴 값 해쉬에 담기 
		

		resultMap.put("pageSize", pageSize);
		resultMap.put("currentPage",currentPage);
	    
	    return resultMap;
	}
	
	@RequestMapping("/inf/listinfvuetest.do")
	@ResponseBody
	public Map<String, Object> listinfvuetest(Model model, @RequestParam Map<String, Object> paramMap, 
			HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("   - paramMap : " + paramMap);
//			String title = (String) paramMap.get("title");
		
		int currentPage = 1; // 현재페이지
	    int pageSize = 5;
	    int pageIndex = 0;
		
		paramMap.put("pageIndex", pageIndex);
		paramMap.put("pageSize", pageSize);
//			paramMap.put("title", title);
		
		// 공지사항 목록 조회
		List<NoticeModel> noticeList = noticeService.noticeList(paramMap);
		
		// 목록 수 추출해서 보내기
		int noticeCnt = noticeService.noticeCnt(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("notice", noticeList); // success 용어 담기 
		resultMap.put("noticeCnt", noticeCnt); // 리턴 값 해쉬에 담기 
		

		resultMap.put("pageSize", pageSize);
		resultMap.put("currentPage",currentPage);
	    
	    return resultMap;
	}	

	// 공지사항 상세 조회
	@RequestMapping("detailNotice.do")
	@ResponseBody
	public Map<String,Object> detailNotice(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		//System.out.println("상세정보 보기를 위한 param에서 넘어온 값을 찍어봅시다.: " + paramMap);
		  logger.info("+ Start " + className + ".detailNotice");
		  logger.info("   - paramMap : " + paramMap);
		  
		String result="";
		
		// 선택된 게시판 1건 조회 
		NoticeModel detailNotice = noticeService.noticeDetail(paramMap);
		
		if(detailNotice != null) {
			result = "SUCCESS";  // 성공시 찍습니다. 
		}else {
			result = "FAIL / 불러오기에 실패했습니다.";  // null이면 실패입니다.
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultMsg", result); // success 용어 담기 
		resultMap.put("result", detailNotice); // 리턴 값 해쉬에 담기 
		//resultMap.put("resultComments", comments);
		System.out.println(detailNotice);
		
		logger.info("+ End " + className + ".detailNotice");
	    
	    return resultMap;
	}
	
	//간이 차트
	@RequestMapping("/dashboard/goChart.do")
	@ResponseBody
	public Map<String,Object> goChart(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		  logger.info("+ Start " + className + ".goChart");
		  logger.info("   - paramMap : " + paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();	
		//List<DashboardModel> goChart = dashboardService.goChart(paramMap);
		//model.addAttribute("goChart", goChart);

		// 값 가져오기
		int cntInstructor = dashboardService.cntInstructor(paramMap);
		int cntStudent = dashboardService.cntStudent(paramMap);
		int cntCourse = dashboardService.cntCourse(paramMap);

		resultMap.put("cntInstructor", cntInstructor);
		resultMap.put("cntStudent", cntStudent);
		resultMap.put("cntCourse", cntCourse);

		/*int cntEngineer = dashboardService.cntEngineer(paramMap);
		int cntCompany = dashboardService.cntCompany(paramMap); 
		int cntProject = dashboardService.cntProject(paramMap);*/
//		int cntApplicant = dashboardService.cntApplicant(paramMap);

		/*resultMap.put("cntEngineer", cntEngineer);
		resultMap.put("cntCompany", cntCompany);
		resultMap.put("cntProject", cntProject);*/
//		resultMap.put("cntApplicant", cntApplicant);
		
		logger.info("+ End " + className + ".goChart");
	    
	    return resultMap;
	}

	/** new */
	/** 최근 공지사항 조회 (대시보드 전용 - 실제 notice 테이블 조회) */
	@RequestMapping("/admin/notices/recent")
	@ResponseBody
	public Map<String, Object> getRecentNotices(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".getRecentNotices (Dashboard Specific)");

		if(paramMap.get("limit") != null) {
			paramMap.put("limitCount", Integer.parseInt(paramMap.get("limit").toString()));
		} else {
			paramMap.put("limitCount", 5);
		}

		List<NoticeModel> noticeList = noticeService.dashboardNoticeList(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", noticeList);
		resultMap.put("success", (noticeList != null));

		logger.info("+ End " + className + ".getRecentNotices - Count: " + (noticeList != null ? noticeList.size() : 0));

		return resultMap;
	}

	/** 이번 달 시험 과목 조회 */
	@RequestMapping("/admin/exam/month/current")
	@ResponseBody
	public Map<String, Object> getExamMonth(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".getExamMonth");
		logger.info("   - paramMap : " + paramMap);

		List<ExamMonthModel> examList = dashboardService.getExamMonth(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();

		if (examList != null && !examList.isEmpty()) {
			resultMap.put("list", examList);
			resultMap.put("success", true);
		} else {
			resultMap.put("list", new java.util.ArrayList<>());
			resultMap.put("success", false);
			resultMap.put("message", "이번 달 시험 일정이 없습니다.");
		}

		logger.info("+ End " + className + ".getExamMonth - Count: " + (examList != null ? examList.size() : 0));

		return resultMap;
	}

	/** 수업 중인 강의실 조회 */
	@RequestMapping("/admin/classrooms/active")
	@ResponseBody
	public Map<String, Object> getActiveClassrooms(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".getActiveClassrooms");
		logger.info("   - paramMap : " + paramMap);

		// 현재 수업 중인 강의실 목록 조회
		List<ClassroomModel> classroomList = dashboardService.getActiveClassrooms(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", classroomList);
		resultMap.put("success", true);

		logger.info("+ End " + className + ".getActiveClassrooms");

		return resultMap;
	}
	
//---------------------------------------------------------------------------------------------------------------------------------------------

	/** 수업 중인 강의실 조회 */
	@RequestMapping("api/admin/classrooms/active")
	@ResponseBody
	public Map<String, Object> getActiveClassrooms11(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".getActiveClassrooms");
		logger.info("   - paramMap : " + paramMap);

		// 현재 수업 중인 강의실 목록 조회
		List<ClassroomModel> classroomList = dashboardService.getActiveClassrooms(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", classroomList);
		resultMap.put("success", true);

		logger.info("+ End " + className + ".getActiveClassrooms");

		return resultMap;
	}
	
//---------------------------------------------------------------------------------------------------------------------------------------------

}
