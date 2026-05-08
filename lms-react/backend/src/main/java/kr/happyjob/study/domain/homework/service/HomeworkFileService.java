package kr.happyjob.study.domain.homework.service;

import kr.happyjob.study.domain.homework.model.HomeworkFileVO;
import org.springframework.web.multipart.MultipartFile;

public interface HomeworkFileService {

    HomeworkFileVO selectFile(int fileId);
  HomeworkFileVO saveFile(MultipartFile multiFile, String type) throws Exception;
}


