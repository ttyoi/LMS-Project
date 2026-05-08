package kr.happyjob.study.domain.instructor.service;

import kr.happyjob.study.domain.homework.model.SubmissionListVO;
import kr.happyjob.study.domain.instructor.dao.IHomeworkDAO;
import kr.happyjob.study.domain.instructor.dao.IHomeworkFileDAO;
import kr.happyjob.study.domain.instructor.model.ICourseVO;
import kr.happyjob.study.domain.instructor.model.IHomeworkVO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class IHomeworkServiceImpl implements IHomeworkService {

    @Value("${fileUpload.rootPath}")
    private String rootPath;

    @Value("${fileUpload.homeworkPath}")
    private String homeworkPath;

    @Resource(name = "homeworkDAO")
    private IHomeworkDAO IHomeworkDao;

    @Resource(name = "homeworkFileDao")
    private IHomeworkFileDAO homeworkFileDao;

    @Override
    public int insertHomework(IHomeworkVO vo) {
        return IHomeworkDao.insertHomework(vo);
    }

    @Override
    public List<IHomeworkVO> listHomework() {
        return IHomeworkDao.listHomework();
    }

    @Override
    public List<ICourseVO> getCourseListByTeacher(String teacherNm) throws Exception {
        return IHomeworkDao.getCourseListByTeacher(teacherNm);
    }

    @Override
    public List<IHomeworkVO> listHomework(String loginId) {
        return IHomeworkDao.listHomework(loginId);
    }

    @Override
    public IHomeworkVO detailHomework(int homework_code) {
        return IHomeworkDao.detailHomework(homework_code);
    }

    // 경로 설정
    String physicalPath = "C:\\jquery_img";
    String logicalPath = "/jquery_img/";

    @Override
    @Transactional
    public int updateHomework(IHomeworkVO vo, List<MultipartFile> file) {
        try {
            if (file != null && !file.isEmpty() && !file.get(0).isEmpty()) {
                int count = homeworkFileDao.countHomeworkFile(vo.getHomework_code());
                if (count > 0) deleteHomeworkFile(vo.getHomework_code());

                File folder = new File(physicalPath);
                if (!folder.exists()) {
                    folder.mkdirs();
                }

                for (MultipartFile mf : file) {
                    if (mf.isEmpty()) continue;

                    String original = mf.getOriginalFilename();
                    String ext = original.substring(original.lastIndexOf(".") + 1);
                    int size = (int) mf.getSize();
                    String saveName = UUID.randomUUID() + "_" + original;

                    String fullPath = physicalPath + File.separator + saveName;
                    File saveFile = new File(fullPath);

                    if (!saveFile.getParentFile().exists()) {
                        saveFile.getParentFile().mkdirs();
                    }

                    mf.transferTo(saveFile);

                    Map<String, Object> fileData = new HashMap<>();
                    fileData.put("size", size);
                    fileData.put("type", ext);
                    fileData.put("name", original);
                    fileData.put("logical_path", logicalPath + saveName);
                    fileData.put("physical_path", fullPath);

                    IHomeworkDao.insertFile(fileData);

                    Object fileIdObj = fileData.get("file_id");
                    int fileId = Integer.parseInt(String.valueOf(fileIdObj));

                    Map<String, Object> map = new HashMap<>();
                    map.put("type", "HOMEWORK");
                    map.put("homework_code", vo.getHomework_code());
                    map.put("submission_code", null);
                    map.put("file_id", fileId);

                    homeworkFileDao.insertHomeworkFile(map);
                }
            }
            return IHomeworkDao.updateHomework(vo);

        } catch (Exception e) {
            System.out.println("Exception : " + e.getMessage());
            throw new RuntimeException(e);
        }
    }

    @Override
    @Transactional
    public int deleteHomeworkFile(int homework_code) {
        try {
            int count = homeworkFileDao.countHomeworkFile(homework_code);
            if (count > 0) {
                List<Map<String, Object>> vo = homeworkFileDao.selectFilesByHomework(homework_code);
                if (!vo.isEmpty()) {
                    for (Map<String, Object> map : vo) {
                        String path = (String) map.get("physical_path");
                        File file = new File(path);
                        if (file.exists()) {
                            file.delete();
                        }
                    }
                }
                int file_id = homeworkFileDao.findFileId(homework_code);
                homeworkFileDao.deleteHomeworkFile(homework_code);

                int countFile = homeworkFileDao.countFile(file_id);
                if (countFile > 0)
                    return homeworkFileDao.deleteFile(file_id);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return 0;
    }

    @Override
    @Transactional
    public int deleteHomework(int homework_code) {
        if (countSubmissions(homework_code) > 0) {
            return 0;
        }
        deleteHomeworkFile(homework_code);
        return IHomeworkDao.deleteHomework(homework_code);
    }

    @Override
    public int countSubmissions(int homework_code) {
        return IHomeworkDao.countSubmissions(homework_code);
    }

    @Override
    @Transactional
    public void registerHomework(IHomeworkVO vo, List<MultipartFile> files) throws Exception {
        IHomeworkDao.insertHomework(vo);
        int homework_code = vo.getHomework_code();

        File folder = new File(physicalPath);
        if (!folder.exists()) {
            folder.mkdirs();
        }

        for (MultipartFile mf : files) {
            if (mf.isEmpty()) continue;

            String original = mf.getOriginalFilename();
            String ext = original.substring(original.lastIndexOf(".") + 1);
            int size = (int) mf.getSize();
            String saveName = UUID.randomUUID() + "_" + original;

            String fullPath = physicalPath + File.separator + saveName;
            File saveFile = new File(fullPath);

            mf.transferTo(saveFile);

            Map<String, Object> fileData = new HashMap<>();
            fileData.put("size", size);
            fileData.put("type", ext);
            fileData.put("name", original);
            fileData.put("logical_path", logicalPath + saveName);
            fileData.put("physical_path", fullPath);

            IHomeworkDao.insertFile(fileData);

            int fileId = Integer.parseInt(String.valueOf(fileData.get("file_id")));

            Map<String, Object> map = new HashMap<>();
            map.put("type", "HOMEWORK");
            map.put("homework_code", homework_code);
            map.put("submission_code", null);
            map.put("file_id", fileId);

            homeworkFileDao.insertHomeworkFile(map);
        }
    }

    @Override
    public int updateSubmission(int submissionCode, Integer score, String feedback, String appealReply) {
        return IHomeworkDao.updateSubmission(submissionCode, score, feedback, appealReply);
    }

    @Override
    public List<SubmissionListVO> getHomeworkSubmissions(int homework_Code) {
        return IHomeworkDao.selectHomeworkSubmissions(homework_Code);
    }

    @Override
    public List<SubmissionListVO> listSubmissions(int homework_Code) {
        return IHomeworkDao.selectHomeworkSubmissions(homework_Code);
    }

    @Override
    public List<SubmissionListVO> listAllSubmissions(String loginId) {
        return IHomeworkDao.selectAllSubmissions(loginId);
    }

    /**
     * 파일 상세 정보 조회 구현 (다운로드용)
     */
    @Override
    public Map<String, Object> getFileDetail(int file_id) throws Exception {
        return homeworkFileDao.selectFileDetail(file_id);
    }
}