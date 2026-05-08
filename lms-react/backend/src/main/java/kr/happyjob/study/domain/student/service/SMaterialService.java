package kr.happyjob.study.domain.student.service;

import kr.happyjob.study.domain.instructor.model.ICourseSimpleVO;
import kr.happyjob.study.domain.instructor.model.IMaterialVO;
import kr.happyjob.study.domain.student.model.FileVO;
import kr.happyjob.study.domain.student.model.SCourseSimpleVO;
import kr.happyjob.study.domain.student.model.SMaterialSearchDTO;
import kr.happyjob.study.domain.student.model.SMaterialVO;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import java.io.IOException;
import java.util.List;

public interface SMaterialService {
    int totalCnt(SMaterialSearchDTO sMaterialSearchDTO);

    List<SMaterialVO> loadMaterials(SMaterialSearchDTO sMaterialSearchDTO);

    FileVO selectFile(Long fileId);


    List<SCourseSimpleVO> loadStuCourse(String loginID);
}
