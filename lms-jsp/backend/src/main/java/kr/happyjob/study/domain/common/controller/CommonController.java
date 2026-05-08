package kr.happyjob.study.domain.common.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import kr.happyjob.study.domain.common.model.AttendanceStatusVO;
import kr.happyjob.study.domain.common.model.CourseClassVO;
import kr.happyjob.study.domain.common.model.CourseStatusVO;
import kr.happyjob.study.domain.common.model.CourseTimeVO;
import kr.happyjob.study.domain.common.model.DetailCodeVO;
import kr.happyjob.study.domain.common.model.QnaCategoryVO;
import kr.happyjob.study.domain.common.model.SCourseStatusVO;
import kr.happyjob.study.domain.common.service.CommonService;

@RestController
@RequestMapping("/common/")
public class CommonController {
	@Autowired
	private CommonService commonService;
	
	@GetMapping("attendancestatuslist")
	public List<AttendanceStatusVO> attendanceStatusList(){
		return commonService.attendanceStatusList();
	};
	
	@GetMapping("courseclasslist")
	public List<CourseClassVO> courseClassList(){
		return commonService.courseClassList();
	};
	
	@GetMapping("coursestatuslist")
	public List<CourseStatusVO> courseStatusList(){
		return commonService.courseStatusList();
	};
	
	@GetMapping("coursetimelist")
	public List<CourseTimeVO> courseTimeList(){
		return commonService.courseTimeList();
	};
	
	@GetMapping("detailcodelist")
	public List<DetailCodeVO> detailCodeList(){
		return commonService.detailCodeList();
	};
	
	@GetMapping("qnacategorylist")
	public List<QnaCategoryVO> qnaCategoryList(){
		return commonService.qnaCategoryList();
	};
	
	@GetMapping("scoursestatuslist")
	public List<SCourseStatusVO> sCourseStatusList(){
		return commonService.sCourseStatusList();
	};
}
