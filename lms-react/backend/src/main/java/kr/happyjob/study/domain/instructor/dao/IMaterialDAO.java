package kr.happyjob.study.domain.instructor.dao;

import kr.happyjob.study.domain.instructor.model.ICourseSimpleVO;
import kr.happyjob.study.domain.instructor.model.IMaterialSearchDTO;
import kr.happyjob.study.domain.instructor.model.IMaterialVO;

import java.util.List;

public interface IMaterialDAO {

    int totalCnt(IMaterialSearchDTO imaterialSearchDTO);
    List<ICourseSimpleVO> loadInstCourse(String loginID);

    void insertMaterial(IMaterialVO iMaterialVO);

    List<IMaterialVO> loadMaterials(IMaterialSearchDTO iMaterialSearchDTO);

    void updateMaterial(IMaterialVO iMaterialVO);

    int deleteMaterial(Long materials_id);

  IMaterialVO selectMaterialDetail(Long materialsId);
}
