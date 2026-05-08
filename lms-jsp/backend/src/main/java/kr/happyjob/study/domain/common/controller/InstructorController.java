package kr.happyjob.study.domain.common.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.happyjob.study.domain.common.model.InstructorVO;
import kr.happyjob.study.domain.common.service.InstructorService;

@RestController
@RequestMapping("/common/")
public class InstructorController {
	@Autowired
	InstructorService instructorService;
	// user_stats
	// D: 유예, Q: 탈퇴, R: 등록

	// 전체 리스트 (등록 + 유예 + 탈퇴 포함)
	@GetMapping("instlist")
	public List<InstructorVO> getInstList() {
		return instructorService.getInstList();
	};

	// 유예 리스트
	@GetMapping("delayedinstlist")
	public List<InstructorVO> getDelayedInstList() {
		return instructorService.getDelayedInstList();
	};

	// 등록 리스트
	// * 참고: 보조강사 리스트 용
	// 따로 지침이 없어 course와 무관하게 R인 강사 전부로 뽑음
	// 필요시 나중에 InstructorService.getRegisteredInstList(paramMap) 수정할 것
	@GetMapping("registeredinstlist")
	public List<InstructorVO> getRegisteredInstList(
			@RequestParam(value = "paramMap", required = false) Map<String, Object> paramMap) {
		if (paramMap == null || paramMap.size() == 0)
			return instructorService.getRegisteredInstList();
		else
			return instructorService.getRegisteredInstList(paramMap);
	};

}
