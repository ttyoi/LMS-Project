package kr.happyjob.study.domain.instructor.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonProperty;

import kr.happyjob.study.domain.homework.model.SubmissionListVO;
import kr.happyjob.study.domain.instructor.model.ICourseVO;
import kr.happyjob.study.domain.instructor.model.IHomeworkVO;
import kr.happyjob.study.domain.instructor.service.IHomeworkService;
import lombok.extern.slf4j.Slf4j;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import javax.servlet.http.HttpServletResponse;

@Slf4j
@Controller
@RequestMapping("/inst")
public class IHomeworkController {

	@Autowired
	IHomeworkService IHomeworkService;

	@Value("${fileUpload.rootPath}")
	private String rootPath;

	@Value("${fileUpload.homeworkPath}")
	private String homeworkPath;

	@JsonProperty("homework_code")
	private int homeworkCode;
	@JsonProperty("fileList")
	private List<IHomeworkVO> fileList;

	// 과제 목록 페이지
	@GetMapping("/assignments")
	public String instructorAssignments(Model model, HttpSession session) {

		// ★ 로그인 여부 체크
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) {
			return "redirect:/login.do";
		}

		List<IHomeworkVO> list = IHomeworkService.listHomework(loginId);
		model.addAttribute("list", list);

		return "instructor/assignments";
	}

	@ResponseBody
	@GetMapping(value = {"/homeworklist", "/homeworklist.do"})
	public List<IHomeworkVO> homeworkList(HttpSession session) {

		String loginId = (String) session.getAttribute("loginId");
		// 로그인 체크 (필요시)
		return IHomeworkService.listHomework(loginId);
	}

	// 과제 등록 폼 이동
	@GetMapping("/homeworkWriteForm")
	public String homeworkWriteForm(Model model, HttpSession session) throws Exception {

		// ★ 로그인 여부 체크
		String loginId = (String) session.getAttribute("loginId");
		log.info("★★ homeworkWriteForm loginId = {}", loginId);

		if (loginId == null) {
			return "redirect:/login.do";
		}

		// 강사 담당 과정 목록 조회
		List<ICourseVO> courseList = IHomeworkService.getCourseListByTeacher(loginId);
		model.addAttribute("courseList", courseList);

		return "instructor/homeworkWriteForm";
	}

	// 강사 담당과정 목록 조회
	@ResponseBody
	@GetMapping(value = {"/getcourselist", "/getcourselist.do"})
	public List<ICourseVO> getCourseList(HttpSession session) throws Exception {
		String loginId = (String) session.getAttribute("loginId");
		return IHomeworkService.getCourseListByTeacher(loginId);
	}
	
	@ResponseBody
    @GetMapping("/getInstName")
    public String getInstName(HttpSession session) throws Exception {
    	// 세션에서 직접 이름을 꺼내옵니다.
        String userName = (String) session.getAttribute("userNm");

        // 만약 이름이 없다면(세션 만료 등) "강사 미확인" 등의 기본값을 줄 수도 있습니다.
        return (userName != null) ? userName : "Unknown";
    }

	// 등록 처리
	@PostMapping(value = {"/homeworkInsert", "/homeworkInsert.do"})
	public String homeworkInsert(IHomeworkVO vo, @RequestParam("course_id") int courseId, @RequestParam(value = "files", required = false) List<MultipartFile> files, HttpSession session) throws Exception {

		// ★ 강사 ID 세팅 (loginId 사용)
		vo.setLoginID((String) session.getAttribute("loginId"));

		// 강사 이름 세팅
		vo.setTeacher((String) session.getAttribute("userNm"));

		// 과정 설정
		vo.setCourse_id(courseId);

		List<MultipartFile> safeFiles = (files != null) ? files : new ArrayList<>();
		IHomeworkService.registerHomework(vo, safeFiles);
		return "redirect:/inst/assignments";
	}

	// 등록 처리 리액트용
	@ResponseBody
	@PostMapping(value = {"/assignmentinsertreact", "/assignmentinsertreact.do"}, consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
	public ResponseEntity<?> assignmentInsert(@RequestPart("data") IHomeworkVO vo, @RequestParam(value = "files", required = false) List<MultipartFile> files, HttpSession session) throws Exception {
		try {
			// ★ 강사 ID 세팅 (loginId 사용)
			vo.setLoginID((String) session.getAttribute("loginId"));

			// 강사 이름 세팅
			vo.setTeacher_name((String) session.getAttribute("userNm"));

			List<MultipartFile> safeFiles = (files != null) ? files : new ArrayList<>();
			IHomeworkService.registerHomework(vo, safeFiles);
			return ResponseEntity.ok("파일 개수: " + safeFiles.size());

		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed");
		}
	}

	// 상세 보기
	@GetMapping("/homeworkDetail")
	public String homeworkDetail(int homework_code, Model model) {
		IHomeworkVO detail = IHomeworkService.detailHomework(homework_code);
		model.addAttribute("detail", detail);
		return "instructor/homeworkDetail";
	}

	// 상세보기 데이터반환
	@ResponseBody
	@GetMapping("/assignmentdetailreturn/{homework_code}")
	public IHomeworkVO homeworkDetailReturn(@PathVariable int homework_code, Model model) {
		return IHomeworkService.detailHomework(homework_code);
	}

	// 수정
    @PostMapping("/homeworkUpdate")
    public String homeworkUpdate(IHomeworkVO vo,
                                 // required=false를 넣어야 파일 첨부를 안 해도 400 에러가 안 납니다.
                                 @RequestParam(value="files", required=false) List<MultipartFile> files) {

        // 파일이 넘어오지 않았을 때 null 방지
        if (files == null) {
            files = new java.util.ArrayList<>();
        }

        IHomeworkService.updateHomework(vo, files);

        // 수정 후 다시 목록 페이지로 이동
        return "redirect:/inst/assignments";
    }

	// 수정react용
	@Transactional
	@PostMapping(value = "/assignmentupdate", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
	public int assignmentUpdate(@RequestPart IHomeworkVO data, @RequestParam(value = "files", required = false) List<MultipartFile> files) {
		List<MultipartFile> file = new ArrayList<>();
		if (files != null) file.addAll(files);

		return IHomeworkService.updateHomework(data, file);
	}

	// 삭제
	@ResponseBody
	@GetMapping("/homeworkDelete")
	public int homeworkDelete(int homework_code) {
		return IHomeworkService.deleteHomework(homework_code);
	}

	// 삭제 react용
	@Transactional
	@DeleteMapping("/assignmentDelete")
	public int assignmentDelete(@RequestParam(value = "homework_code") int homework_code) {
		return IHomeworkService.deleteHomework(homework_code);
	}

	// 제출된 과제 목록 페이지
	@GetMapping("/submissions")
	public String submissionPage(@RequestParam(required = false) Integer homeworkCode, Model model) {
		model.addAttribute("homeworkCode", homeworkCode);
		return "instructor/submissions";
	}

	// 제출 목록 데이터(Json)
	@ResponseBody
	@GetMapping("/submissions/list")
	public List<SubmissionListVO> submissionList(@RequestParam int homeworkCode) {
		return IHomeworkService.listSubmissions(homeworkCode);
	}

	// 전체 제출 목록(JSON) - homeworkCode 없이 조회
	@ResponseBody
	@GetMapping("/submissions/listAll")
	public List<SubmissionListVO> submissionListAll(HttpSession session) {

		String loginId = (String) session.getAttribute("loginId");  // 강사 ID
		if (loginId == null) {
			return null; // 또는 빈 리스트
		}

		return IHomeworkService.listAllSubmissions(loginId);
	}

  @ResponseBody
  @PostMapping("/submissions/update")
  public int updateSubmission(@RequestBody Map<String, Object> data) {

    // 1. 기본 정보 추출
    int submissionCode = Integer.parseInt(data.get("submissionCode").toString());

    Integer score = data.get("score") != null && !data.get("score").toString().equals("")
      ? Integer.parseInt(data.get("score").toString())
      : null;

    String feedback = data.get("feedback") != null ? data.get("feedback").toString() : null;

    // 2. ★ 추가: Vue에서 보낸 appealReply(이의제기 답변) 추출
    // 프론트에서 appealReply라는 키로 보내고 있으므로 그대로 꺼냅니다.
    String appealReply = data.get("appealReply") != null ? data.get("appealReply").toString() : null;

    // 3. ★ 서비스 호출 시 appealReply를 추가로 전달
    // (앞서 Service 인터페이스와 Impl에 파라미터를 추가하셨어야 에러가 안 납니다!)
    return IHomeworkService.updateSubmission(submissionCode, score, feedback, appealReply);
  }

  // InstructorController.java (또는 해당 컨트롤러)

    // ★ 이 위치(클래스 내부 맨 아래)에 추가하세요!

    // 파일 다운로드
    @RequestMapping("/downloadFile")
    public void downloadFile(@RequestParam("file_id") int fileId, HttpServletResponse response) throws Exception {

        // 1. DB에서 파일 정보 조회
        // (Service 인터페이스와 Impl에 getFileDetail이 구현되어 있어야 합니다)
        Map<String, Object> fileInfo = IHomeworkService.getFileDetail(fileId);

        if (fileInfo == null) {
            log.error("파일 정보를 찾을 수 없습니다. file_id : {}", fileId);
            return;
        }

        String physicalPath = (String) fileInfo.get("physical_path");
        String originalName = (String) fileInfo.get("name");

        File file = new File(physicalPath);
        if (!file.exists()) {
            log.error("물리적 파일이 존재하지 않습니다. 경로 : {}", physicalPath);
            return;
        }

        // 2. 브라우저 헤더 설정 (다운로드 창 호출)
        response.setContentType("application/octet-stream");

        // 한글 파일명 깨짐 방지 인코딩
        String encodedName = java.net.URLEncoder.encode(originalName, "UTF-8").replaceAll("\\+", "%20");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedName + "\"");

        // 3. 파일 스트림 복사 (Spring의 FileCopyUtils 사용 - IOUtils보다 안전)
        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {
            org.springframework.util.FileCopyUtils.copy(fis, os);
            os.flush();
        } catch (Exception e) {
            log.error("파일 스트림 복사 중 오류 발생 : {}", e.getMessage());
        }
    }

} // 클래스 닫는 괄호


