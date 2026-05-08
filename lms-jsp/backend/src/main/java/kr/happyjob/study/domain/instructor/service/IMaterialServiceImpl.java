package kr.happyjob.study.domain.instructor.service;

import kr.happyjob.study.common.comnUtils.FileUtilCho;
import kr.happyjob.study.domain.instructor.dao.IFileDAO;
import kr.happyjob.study.domain.instructor.dao.IMaterialDAO;
import kr.happyjob.study.domain.instructor.model.FileVO;
import kr.happyjob.study.domain.instructor.model.ICourseSimpleVO;
import kr.happyjob.study.domain.instructor.model.IMaterialSearchDTO;
import kr.happyjob.study.domain.instructor.model.IMaterialVO;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartHttpServletRequest;


import java.io.File;
import java.io.IOException;
import java.nio.file.NoSuchFileException;
import java.util.List;
import java.util.Map;

@Service
public class IMaterialServiceImpl implements IMaterialService {

    Logger logger = Logger.getLogger(IMaterialServiceImpl.class);

    @Autowired
    private IMaterialDAO iMaterialDAO;

    @Autowired
    private IFileDAO iFileDAO;

    @Value("${file.upload.physical-path-materials}")
    String physicalPath;
    @Value("${fileUpload.logical-path-materials}")
    String logicalPath;

    /**
     * (course_id)/(registerDate + UUID)
     */
    String itemPath;

    @Override
    public int totalCnt(IMaterialSearchDTO imaterialSearchDTO) {
        return iMaterialDAO.totalCnt(imaterialSearchDTO);
    }

    @Override
    public List<ICourseSimpleVO> loadInstCourse(String loginID) {
        return iMaterialDAO.loadInstCourse(loginID);
    }

  @Override
  @Transactional
  public void insertMaterial(IMaterialVO iMaterialVO, MultipartHttpServletRequest request) {
    try {
      // 등록 날짜와 과정 ID를 이용한 하위 경로 생성
      String itemPath = iMaterialVO.getCourse_id() + File.separator + iMaterialVO.getRegister_date() + File.separator;

      // ⚠️ 수정 포인트: root 경로를 Z:/LMSProject 까지만 잡고,
      // 뒤에오는 logicalPath가 materials를 붙여주도록 설정
      FileUtilCho file = new FileUtilCho(
        request,
        "Z:/LMSProject", // materials를 제외한 루트만 전달
        logicalPath,     // 여기서 /materials/ 가 붙음
        itemPath
      );

      Map<String, Object> uploadRes = file.uploadFiles();

      // 업로드 결과 로그 확인 (콘솔창을 꼭 보세요!)
      if (uploadRes == null || uploadRes.get("file_loc") == null) {
        logger.error("❌ 파일 업로드 실패: uploadRes가 null입니다.");
        return;
      }

      FileVO fileVO = new FileVO();
      fileVO.setSize(Integer.parseInt((String) uploadRes.get("file_size")));
      fileVO.setName((String) uploadRes.get("file_nm"));
      fileVO.setType((String) uploadRes.get("fileExtension"));
      fileVO.setPhysical_path((String) uploadRes.get("file_loc"));
      fileVO.setLogical_path((String) uploadRes.get("vrfile_loc"));

      iFileDAO.insertFile(fileVO);
      iMaterialVO.setFile_id(fileVO.getFile_id());
      iMaterialDAO.insertMaterial(iMaterialVO);

    } catch (Exception e) {
      logger.error("❌ 등록 에러 발생: " + e.getMessage());
      e.printStackTrace(); // 에러 전체 내용을 콘솔에 출력
    }
  }

    @Override
    public List<IMaterialVO> loadMaterials(IMaterialSearchDTO iMaterialSearchDTO) {
        return iMaterialDAO.loadMaterials(iMaterialSearchDTO);
    }

    @Override
    public void updateMaterial(IMaterialVO iMaterialVO) {
        iMaterialDAO.updateMaterial(iMaterialVO);
    }

    @Override
    public void deleteMaterial(Long materials_id, Long file_id) throws IOException {

        FileVO fileVO = selectFile(file_id);
        File file = new File(fileVO.getPhysical_path());

        if (!file.exists()) {
            throw new NoSuchFileException("파일을 찾을 수 없습니다: " + fileVO.getPhysical_path());
        }

        boolean deleted = file.delete();
        if (!deleted) {
            throw new IOException("파일 삭제에 실패했습니다: " + fileVO.getPhysical_path());
        }

        else {
            iMaterialDAO.deleteMaterial(materials_id);
            // DB에서도 파일정보 삭제
            iFileDAO.deleteFile(file_id);
        }
    }



    @Override
    public FileVO selectFile(Long fileId) {
        return iFileDAO.selectFile(fileId);
    }



}
