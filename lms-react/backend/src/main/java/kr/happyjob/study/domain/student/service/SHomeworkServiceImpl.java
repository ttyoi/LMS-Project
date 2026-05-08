package kr.happyjob.study.domain.student.service;

import kr.happyjob.study.domain.instructor.dao.IHomeworkFileDAO;
import kr.happyjob.study.domain.instructor.model.FileVO;
import kr.happyjob.study.domain.student.dao.SHomeworkDAO;
import kr.happyjob.study.domain.student.model.SHomeworkVO;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.io.File;
import java.util.*;

@Service
public class SHomeworkServiceImpl implements SHomeworkService {

    @Resource(name = "SHomeworkDAO")
    SHomeworkDAO sHomeworkDAO;

    @Resource(name = "homeworkFileDao")
    private IHomeworkFileDAO homeworkFileDao;

    // [수정] 파일이 실제로 저장될 물리적 경로 직접 지정
    private final String physicalPath = "C:\\jquery_img";

    // [수정] 논리적 경로는 필요에 따라 설정 (보통 다운로드나 이미지 호출용)
    private final String logicalPath = "/jquery_img/";

    @Override
    public int updateAppeal(SHomeworkVO vo) throws Exception {
        return sHomeworkDAO.updateAppeal(vo);
    }

    @Override
    public List<SHomeworkVO> getStudentHomeworkList(String loginId) {
        return sHomeworkDAO.getStudentHomeworkList(loginId);
    }

    // 1. 등록 모드 (처음 과제 클릭했을 때)
    @Override
    public SHomeworkVO getHomeworkDetail(int homework_code, String loginId) {
        // 기본 과제 정보 조회
        SHomeworkVO detail = sHomeworkDAO.getHomeworkDetail(homework_code, loginId);

        if (detail != null) {
            // [추가] 해당 과제 번호(homework_code)로 연결된 모든 파일(강사 양식 등) 조회
            List<Map<String, Object>> fileList = homeworkFileDao.selectFilesByHomework(homework_code);
            detail.setFileList(fileList); // VO의 fileList 필드에 담아줍니다.
        }
        return detail;
    }

    @Override
    public void submitHomework(SHomeworkVO vo, MultipartFile uploadFile) throws Exception {

        String loginId = vo.getLoginID();

        // 1. 기존 제출 여부 확인 및 제출 정보 처리
        Map<String, Object> param = new HashMap<>();
        param.put("homework_code", vo.getHomework_code());
        param.put("loginId", loginId);

        Integer submissionCode = sHomeworkDAO.findSubmissionCode(param);

        if (submissionCode != null) {
            vo.setSubmission_code(submissionCode);
            sHomeworkDAO.updateSubmission(vo);
            sHomeworkDAO.deleteSubmissionFile(submissionCode);
        } else {
            sHomeworkDAO.insertSubmission(vo);
            submissionCode = vo.getSubmission_code();
        }

        // 2. 실제 파일 저장 처리
        if (uploadFile != null && !uploadFile.isEmpty()) {

            String originalName = uploadFile.getOriginalFilename();
            // 파일명 중복 방지를 위한 UUID 처리
            String saveName = UUID.randomUUID().toString() + "_" + originalName;

            // 3. 저장 폴더 객체 생성 및 확인
            File saveDir = new File(physicalPath);

            // ★ 폴더가 존재하지 않으면 하위 폴더까지 한꺼번에 생성
            if (!saveDir.exists()) {
                saveDir.mkdirs();
            }

            // 4. 실제 저장될 전체 경로 파일 객체
            File dest = new File(saveDir, saveName);

            // 파일을 지정된 경로로 저장 (transferTo 사용)
            uploadFile.transferTo(dest);

            // 5. DB 기록을 위한 FileVO 세팅
            FileVO fileVO = new FileVO();
            fileVO.setName(originalName);
            fileVO.setSize((int) uploadFile.getSize());
            // 확장자 추출
            String extension = "";
            if (originalName != null && originalName.contains(".")) {
                extension = originalName.substring(originalName.lastIndexOf(".") + 1);
            }
            fileVO.setType(extension);

            // 경로 기록 (물리적 전체 경로와 논리 경로 저장)
            fileVO.setPhysical_path(dest.getAbsolutePath());
            fileVO.setLogical_path(logicalPath + saveName);

            // 파일 정보 DB Insert
            homeworkFileDao.insertFile(fileVO);

            // 6. 생성된 file_id를 가져와 연결 테이블에 기록
            // FileVO에서 생성된 ID를 꺼내올 때 Long인 경우 int로 형변환 필요
            int fileId = Math.toIntExact(fileVO.getFile_id());

            sHomeworkDAO.insertHomeworkFile(
                    vo.getHomework_code(),
                    submissionCode,
                    fileId
            );
        }
    }

    @Override
    public List<SHomeworkVO> getSubmittedHomework(String loginId) {
        return sHomeworkDAO.submittedList(loginId);
    }

    @Override
    public List<SHomeworkVO> getSubmittedResult(String loginId) {
        return sHomeworkDAO.submittedList(loginId);
    }

    // 2. 수정 모드 (이미 제출한 과제 클릭했을 때)
    @Override
    public SHomeworkVO getSubmittedOne(int submissionCode) {
        // 기본 제출 정보 및 과제 정보 조회
        SHomeworkVO detail = sHomeworkDAO.getSubmittedOne(submissionCode);

        if (detail != null) {
            // [추가] 과제 번호로 연결된 모든 파일(강사 양식 + 학생 제출물 모두 포함됨) 조회
            // Mapper 쿼리 구조상 homework_code가 일치하는 모든 파일을 가져오게 됩니다.
            List<Map<String, Object>> fileList = homeworkFileDao.selectFilesByHomework(detail.getHomework_code());
            detail.setFileList(fileList);
        }
        return detail;
    }

    @Override
    public Integer findSubmissionCode(int homework_code, String loginId) {
        Map<String, Object> param = new HashMap<>();
        param.put("homework_code", homework_code);
        param.put("loginId", loginId);
        return sHomeworkDAO.findSubmissionCode(param);
    }

    @Override
    public void updateSubmission(int submission_code) {
        // 필요시 구현
    }

    @Override
    public void deleteSubmissionFile(int submission_code) {
        sHomeworkDAO.deleteSubmissionFile(submission_code);
    }
}