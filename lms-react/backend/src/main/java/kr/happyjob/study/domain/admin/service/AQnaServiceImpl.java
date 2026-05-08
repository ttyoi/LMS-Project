package kr.happyjob.study.domain.admin.service;

import kr.happyjob.study.common.comnUtils.MypageFileUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import kr.happyjob.study.domain.admin.dao.AQnaDAO;
import kr.happyjob.study.domain.admin.model.AQnaVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;


@Service
public class AQnaServiceImpl implements AQnaService {

    @Autowired
    private AQnaDAO qnaDao;

  @Value("${file.upload.physical-path}") // properties의 Z:/LMSProject/
  private String phyRootPath;

  @Value("${file.upload.logical-qna}") // qna01/
  private String logiQnaPath;

    @Override
    public List<AQnaVO> selectQnaList(Map<String, Object> paramMap) throws Exception {
        return qnaDao.selectQnaList(paramMap);
    }

    @Override
    public int selectQnaListCnt(Map<String, Object> paramMap) throws Exception {
        return qnaDao.selectQnaListCnt(paramMap);
    }

    @Override
    public List<Map<String, Object>> selectCategoryList() throws Exception {
        return qnaDao.selectCategoryList();
    }

    @Override
    public AQnaVO selectQnaDetail(int postId) throws Exception {
        return qnaDao.selectQnaDetail(postId);
    }

    @Override
    public int insertQnaPost(AQnaVO vo, MultipartFile file) throws Exception {
      if (file != null && !file.isEmpty()) {
        processFile(vo, file); // 파일 처리 공통 메서드 호출
      }
      return qnaDao.insertQnaPost(vo);
    }

    @Override
    public int updateQnaPost(AQnaVO vo, MultipartFile file) throws Exception {
      if (file != null && !file.isEmpty()) {
        // 1. 기존 파일이 있다면 삭제 (팀원 마이페이지 방식)
        AQnaVO oldPost = qnaDao.selectQnaDetail(vo.getPostId());
        if (oldPost != null && oldPost.getFilSavName() != null) {
          MypageFileUtil.delete(oldPost.getPhysicalPath() + oldPost.getFilSavName());
        }
        // 2. 새 파일 저장
        processFile(vo, file);
      }
      return qnaDao.updateQnaPost(vo);
    }

    /**
     * 파일 저장 및 VO 세팅 공통 로직
     */
    private void processFile(AQnaVO vo, MultipartFile file) throws Exception {
      String original = file.getOriginalFilename();
      String ext = original.substring(original.lastIndexOf("."));
      String newFileName = java.util.UUID.randomUUID().toString() + ext;

      // 물리 경로 조합: Z:/LMSProject/qna01/
      String physicalPath = phyRootPath + logiQnaPath;

      // MypageFileUtil을 사용하여 저장 (알아서 IP 경로로 변환하여 저장함)
      MypageFileUtil.save(file, physicalPath + newFileName);

      // DB 저장을 위한 VO 세팅
      vo.setFilOriName(original);
      vo.setFilSavName(newFileName);
      vo.setExtendsName(ext.replace(".", ""));
      vo.setSize((int) file.getSize());
      vo.setLogicalPath("/" + logiQnaPath);
      vo.setPhysicalPath(phyRootPath + logiQnaPath);
    }

    @Override
    public int deleteQnaPost(int postId) throws Exception {
        return qnaDao.deleteQnaPost(postId);
    }

    @Override
    public int updateAnswerStatus(Map<String, Object> paramMap) throws Exception {
        return qnaDao.updateAnswerStatus(paramMap);
    }

    @Override
    public List<Map<String, Object>> selectTeacherList() throws Exception {
        return qnaDao.selectTeacherList();
    }
}
