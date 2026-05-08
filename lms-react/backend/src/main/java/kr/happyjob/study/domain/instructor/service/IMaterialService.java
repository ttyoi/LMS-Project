package kr.happyjob.study.domain.instructor.service;

import kr.happyjob.study.domain.instructor.model.FileVO;
import kr.happyjob.study.domain.instructor.model.ICourseSimpleVO;
import kr.happyjob.study.domain.instructor.model.IMaterialSearchDTO;
import kr.happyjob.study.domain.instructor.model.IMaterialVO;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import java.io.IOException;
import java.util.List;

public interface IMaterialService {
    int totalCnt(IMaterialSearchDTO imaterialSearchDTO);
    List<ICourseSimpleVO> loadInstCourse(String loginID);

    void insertMaterial(IMaterialVO iMaterialVO, MultipartHttpServletRequest request) throws Exception;

    List<IMaterialVO> loadMaterials(IMaterialSearchDTO iMaterialSearchDTO);

    void updateMaterial(IMaterialVO iMaterialVO);

    void deleteMaterial(Long materials_id, Long file_id) throws IOException;

    FileVO selectFile(Long fileId);


}
