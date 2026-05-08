package kr.happyjob.study.domain.student.service;

import kr.happyjob.study.common.comnUtils.MypageFileUtil;
import kr.happyjob.study.domain.student.dao.SMypageDAO;
import kr.happyjob.study.domain.student.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class SMypageServiceImpl implements SMypageService {

    @Autowired
    SMypageDAO studentMypageDao;

    @Value("${file.upload.physical-path}")
    private String phyRootPath;

    @Value("${file.upload.logical-profile}")
    private String logiProfilePath;

    @Value("${file.upload.logical-resume}")
    private String logiResumePath;

    private int updateProfileImage(MypageProfileUpdateParamDTO dto) throws Exception {

        SMypageVO user = studentMypageDao.getStudentMypage(dto.getLoginID());

        if (user != null && user.getImgPhyPath() != null && user.getImgName() != null) {
            String oldPath = user.getImgPhyPath() + user.getImgName();
            MypageFileUtil.delete(oldPath);
        }

        return studentMypageDao.updateProfileImage(dto);
    }


    @Override
    public SMypageVO getStudentMypage (String loginId) throws Exception {
        return studentMypageDao.getStudentMypage(loginId);
    }

    @Override
    public int updateStudentMypage(SMypageUpdateDTO dto) throws Exception {
        return studentMypageDao.updateStudentMypage(dto);
    }

    @Override
    public int changePassword(MypagePasswordChangeParamDTO dto) throws Exception {

        if(dto.getOldPw().equals(dto.getNewPw())) {
            return -2;
        }
        int count = studentMypageDao.checkOldPassword(dto);

        if (count == 0) {
            return -1;
        }

        int result  = studentMypageDao.changePassword(dto);

        if(result > 0) {
            studentMypageDao.updateTempPasswordFlag(dto.getLoginID());
        }
        return result;
    }




    @Override
    public Map<String, Object> uploadProfileImage(String loginId, MultipartFile file) throws Exception {

        Map<String, Object> result = new HashMap<>();

        if (file == null || file.isEmpty()) {
            result.put("result", "NO_FILE");
            return result;
        }

        String original = file.getOriginalFilename();
        String ext = original.substring(original.lastIndexOf("."));
        String newFileName = loginId + "_" + UUID.randomUUID() + ext;

        String physicalPath = phyRootPath + logiProfilePath + newFileName;
        
        // physicalPath = physicalPath.replace("file:////", "\\\\");
        // physicalPath = physicalPath.replace("/", "\\");
        
        physicalPath = MypageFileUtil.convertPath(physicalPath);

        MypageFileUtil.save(file, physicalPath);

        MypageProfileUpdateParamDTO dto = new MypageProfileUpdateParamDTO();
        dto.setLoginID(loginId);
        dto.setImgName(newFileName);
        dto.setImgLogiPath("/" + logiProfilePath);
        dto.setImgPhyPath(phyRootPath + logiProfilePath);

        int update = updateProfileImage(dto);

        result.put("result", update > 0 ? "SUCCESS" : "FAIL");
        result.put("imgName", newFileName);
        result.put("imgLogiPath", "/" + logiProfilePath);

        return result;
    }


    @Override
    public MypageResumeVO getResumeById(long resumeId) {
        return studentMypageDao.getResumeById(resumeId);
    }


    @Override
    public Map<String, Object> uploadResume(String loginId, MultipartFile uploadFile) throws Exception {

        Map<String, Object> result = new HashMap<>();

        if (loginId == null) {
            result.put("result", "SESSION_EXPIRED");
            return result;
        }

        if (uploadFile == null || uploadFile.isEmpty()) {
            result.put("result", "NO_FILE");
            return result;
        }

        String originalFilename = uploadFile.getOriginalFilename();
        String newFileName = loginId + "_" + UUID.randomUUID() + "_" + originalFilename;

        String physicalPath = phyRootPath + logiResumePath + newFileName;
        
        physicalPath = physicalPath.replace("file:////", "\\\\");
        physicalPath = physicalPath.replace("/", "\\");
        
        physicalPath = MypageFileUtil.convertPath(physicalPath);

        MypageFileUtil.save(uploadFile, physicalPath);

        MypageResumeInsertParamDTO dto = new MypageResumeInsertParamDTO();
        dto.setLoginID(loginId);
        dto.setName(newFileName);
        dto.setLogicalPath("/" + logiResumePath);
        dto.setPhysicalPath(physicalPath);
        dto.setExtend(originalFilename.substring(originalFilename.lastIndexOf(".") + 1));
        dto.setSize(uploadFile.getSize());

        // 기존 이력서 삭제
        MypageResumeVO oldResume = studentMypageDao.getResumeByLoginId(loginId);
        if (oldResume != null && oldResume.getPhysicalPath() != null) {
            MypageFileUtil.delete(oldResume.getPhysicalPath());
            studentMypageDao.deleteResumeByLoginId(loginId);
        }

        studentMypageDao.insertResume(dto);

        result.put("result", "SUCCESS");
        return result;
    }

    @Override
    public void downloadResume(long resumeId, HttpServletResponse response) throws Exception {

        MypageResumeVO resume = studentMypageDao.getResumeById(resumeId);
        if (resume == null || resume.getPhysicalPath() == null) {
            throw new IllegalArgumentException("Resume not found");
        }

        File file = new File(resume.getPhysicalPath());
        if (!file.exists()) {
            throw new IllegalArgumentException("File not found");
        }

        String encodedName = URLEncoder.encode(resume.getName(), "UTF-8").replace("+", "%20");

        String mimeType = Files.probeContentType(file.toPath());
        if (mimeType == null) mimeType = "application/octet-stream";

        response.setContentType(mimeType);
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedName + "\"");
        response.setHeader("Content-Length", String.valueOf(file.length()));

        try (InputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            FileCopyUtils.copy(in, out);
        }
    }



    @Override
    public List<SMypageCourseStatusVO> getStudentCourseStatus(SMypageCourseStatusParamDTO param) {

        List<SMypageCourseStatusVO> list = studentMypageDao.getStudentCourseStatus(param);

        for (SMypageCourseStatusVO vo : list) {

            Double avg = vo.getMyAvgScore();

            if (avg == null || avg == 0) {
                vo.setGrade("-");
                continue;
            }

            if (avg >= 90) vo.setGrade("A");
            else if (avg >= 80) vo.setGrade("B");
            else if (avg >= 70) vo.setGrade("C");
            else if (avg >= 60) vo.setGrade("D");
            else vo.setGrade("F");
        }

        return list;
    }


    @Override
    public List<SMypagePeriodScoreVO> getCoursePeriodScores(String loginID, int courseId) {
        Map<String, Object> param = new HashMap<>();
        param.put("loginID", loginID);
        param.put("courseId", courseId);
        return studentMypageDao.getCoursePeriodScores(param);
    }


}
