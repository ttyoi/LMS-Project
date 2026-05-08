package kr.happyjob.study.domain.homework.service;

import kr.happyjob.study.domain.homework.dao.HomeworkFileDAO;
import kr.happyjob.study.domain.homework.model.HomeworkFileVO;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.UUID;

@Service
@Log4j
public class HomeworkFileServiceImpl implements HomeworkFileService {

  @Autowired
  HomeworkFileDAO homeworkFileDAO;

  // application.properties에 설정된 루트 경로 (없으면 직접 경로 입력 가능)
  @Value("${fileUpload.rootPath:C:\\homework_files}")
  private String rootPath;

  @Override
  public HomeworkFileVO selectFile(int fileId) {
    return homeworkFileDAO.selectFile(fileId);
  }

  @Override
  public HomeworkFileVO saveFile(MultipartFile multiFile, String type) throws Exception {

    // 1. 저장 디렉토리 생성 (HW: 강사과제, SUB: 학생제출)
    String subPath = type.equals("HW") ? "\\assignments\\" : "\\submissions\\";
    String saveDirectory = rootPath + subPath;
    File dir = new File(saveDirectory);
    if (!dir.exists()) dir.mkdirs();

    // 2. 파일명 중복 방지를 위한 UUID 처리
    String originalFileName = multiFile.getOriginalFilename();
    String ext = originalFileName.substring(originalFileName.lastIndexOf("."));
    String serverFileName = UUID.randomUUID().toString() + ext;

    // 3. 물리적 파일 저장
    String physicalPath = saveDirectory + serverFileName;
    File dest = new File(physicalPath);
    multiFile.transferTo(dest);

    // 4. DB 저장을 위한 VO 생성
    HomeworkFileVO fileVO = new HomeworkFileVO();
    fileVO.setName(originalFileName);           // 원본 파일명
    fileVO.setLogical_path(subPath + serverFileName); // 논리 경로 (웹 접근용)
    fileVO.setPhysical_path(physicalPath);       // 물리 경로 (서버 내부용)
    fileVO.setFile_size((int) multiFile.getSize());
    fileVO.setExtension(ext.replace(".", ""));

    // 5. DB Insert (MyBatis에서 selectKey 등을 통해 file_id가 채워져야 함)
    homeworkFileDAO.insertFile(fileVO);

    log.info("파일 저장 완료: " + physicalPath);
    return fileVO;
  }
}
