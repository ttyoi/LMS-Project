package kr.happyjob.study.domain.homework.controller;

import kr.happyjob.study.domain.homework.model.HomeworkFileVO;
import kr.happyjob.study.domain.homework.service.HomeworkFileService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

@Controller
@Slf4j
@RequestMapping("/homeworkfile") // 기존 /file에서 충돌 방지를 위해 변경
public class HomeworkFileController {

  @Autowired
  private HomeworkFileService homeworkFileService;

  @ResponseBody
  @PostMapping("/upload")
  public ResponseEntity<?> uploadFile(
    @RequestParam("file") MultipartFile multiFile,
    @RequestParam(value = "type", required = false, defaultValue = "HW") String type) {

    try {
      if (multiFile == null || multiFile.isEmpty()) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("파일이 없습니다.");
      }

      HomeworkFileVO savedFile = homeworkFileService.saveFile(multiFile, type);

      Map<String, Object> result = new HashMap<String, Object>();
      result.put("file_id", savedFile.getFile_id());
      result.put("file_name", savedFile.getName());

      return ResponseEntity.ok(result);

    } catch (Exception e) {
      log.error("❌ 파일 업로드 에러: " + e.getMessage());
      return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
        .body("서버 에러: " + e.getMessage());
    }
  }

  /**
   * 과제 파일 다운로드 (강사/학생 공통)
   * DB의 physical_path를 사용하여 Z: 드라이브 등 실제 경로에서 파일을 읽어옵니다.
   */
  @GetMapping(value = {"/download", "/download.do"})
  public void downloadHomeworkFile(
    @RequestParam(value = "fileId", required = false) Integer fileId,
    @RequestParam(value = "file_id", required = false) Integer file_id,
    HttpServletResponse response
  ) throws Exception {

    if (fileId == null) fileId = file_id;
    if (fileId == null) {
      response.sendError(400, "파일 ID가 누락되었습니다.");
      return;
    }

    // 1. DB에서 파일 정보 조회
    HomeworkFileVO fileVO = homeworkFileService.selectFile(fileId);
    if (fileVO == null || fileVO.getPhysical_path() == null) {
      log.error("❌ DB에 파일 정보가 없음. fileId: {}", fileId);
      response.sendError(404, "파일 정보를 찾을 수 없습니다.");
      return;
    }

    // 2. DB의 physical_path를 사용하여 파일 객체 생성
    File fileObj = new File(fileVO.getPhysical_path());
    log.info("👉 과제 다운로드 시도 경로(Physical): " + fileObj.getAbsolutePath());

    // 3. 물리 파일 존재 여부 확인
    if (!fileObj.exists()) {
      log.error("❌ 실제 서버에 파일이 없음: " + fileVO.getPhysical_path());
      response.sendError(404, "서버에 물리적 파일이 존재하지 않습니다.");
      return;
    }

    // 4. 응답 헤더 설정 (한글 파일명 깨짐 방지 및 강제 다운로드)
    String encodedFileName = URLEncoder.encode(fileVO.getName(), "UTF-8").replaceAll("\\+", "%20");

    response.setContentType("application/octet-stream");
    response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"; filename*=UTF-8''" + encodedFileName);
    response.setContentLength(fileVO.getFile_size());

    // 5. 스트림 전송
    try (FileInputStream fis = new FileInputStream(fileObj)) {
      FileCopyUtils.copy(fis, response.getOutputStream());
      response.getOutputStream().flush();
    } catch (Exception e) {
      log.error("❌ 파일 전송 중 에러: " + e.getMessage());
    }
  }
}
