package kr.happyjob.study.domain.student.controller;

import kr.happyjob.study.domain.student.model.*;
import kr.happyjob.study.domain.student.service.SMaterialService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/stu")
public class SMaterialController {

  @Autowired
  SMaterialService sMaterialService;

  Logger logger = LoggerFactory.getLogger(SMaterialController.class);

  @RequestMapping("/materials")
  public String materials() {
    return "student/smaterialList";
  }

  // 학생용 수강 강의 목록 조회
  @PostMapping("/loadStuCourse")
  @ResponseBody
  public List<SCourseSimpleVO> loadStuCourse(HttpSession session) {
    String loginID = (String) session.getAttribute("loginId");
    return sMaterialService.loadStuCourse(loginID);
  }

  // 학생용 학습 자료 목록 조회
  @PostMapping("/loadMaterials")
  @ResponseBody
  public Map<String, Object> loadMaterials(@RequestBody SMaterialSearchDTO dto, HttpSession session) {
    String loginID = (String) session.getAttribute("loginId");
    dto.setLoginID(loginID);

    int totalCnt = sMaterialService.totalCnt(dto);
    dto.setStart((dto.getCurrentPage() - 1) * dto.getPageSize());
    dto.setLimit(dto.getPageSize());

    List<SMaterialVO> materialList = sMaterialService.loadMaterials(dto);

    Map<String, Object> result = new HashMap<>();
    result.put("status", 200);
    result.put("materialList", materialList);
    result.put("totalCnt", totalCnt);
    return result;
  }

  /**
   * ⭐ 학생용 다운로드 로직 (강사 쪽 IMaterialController와 100% 동일화)
   */
  @RequestMapping("/downloadMaterial")
  public void downloadMaterial(@RequestParam("file_id") Long file_id, HttpServletResponse response) {
    try {
      // 1. 강사 쪽과 동일한 서비스 메서드 호출 (selectFile)
      FileVO file = sMaterialService.selectFile(file_id);

      if (file == null) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND, "File record not found.");
        return;
      }

      // 2. 강사 쪽처럼 DB의 physical_path를 직접 사용하여 파일 객체 생성
      File fileObj = new File(file.getPhysical_path());

      logger.info("👉 학생 다운로드 시도 경로(DB기반): " + file.getPhysical_path());

      if (!fileObj.exists()) {
        logger.error("❌ 실제 파일 없음: " + file.getPhysical_path());
        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Physical file not found.");
        return;
      }

      // 3. 강사 쪽과 동일한 헤더 및 스트림 전송 방식 적용
      String encodedFileName = URLEncoder.encode(file.getName(), "UTF-8").replaceAll("\\+", "%20");
      response.setContentType("application/octet-stream");
      response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"; filename*=UTF-8''" + encodedFileName);
      response.setContentLength((int) fileObj.length());

      try (FileInputStream fis = new FileInputStream(fileObj)) {
        FileCopyUtils.copy(fis, response.getOutputStream());
        response.getOutputStream().flush();
      }

    } catch (Exception e) {
      logger.error("❌ 다운로드 처리 중 에러: " + e.getMessage());
      e.printStackTrace();
    }
  }
}
