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
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class SMypageServiceImpl implements SMypageService {

    private static final Pattern RESUME_NAME_PATTERN = Pattern.compile("^.*_[0-9a-fA-F-]{36}_(.+)$");

    @Autowired
    SMypageDAO studentMypageDao;

    @Value("${file.upload.physical-path}")
    private String phyRootPath;

    @Value("${file.upload.physical-profile-path}")
    private String phyProfilePath;

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
        int count = studentMypageDao.checkOldPassword(dto);

        if (count == 0) {
            return -1;
        }

        if(dto.getOldPw().equals(dto.getNewPw())) {
            return -2;
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

        String physicalPath = phyProfilePath + newFileName;
        
        // physicalPath = physicalPath.replace("file:////", "\\\\");
        // physicalPath = physicalPath.replace("/", "\\");
        
        physicalPath = MypageFileUtil.convertPath(physicalPath);

        MypageFileUtil.save(file, physicalPath);

        MypageProfileUpdateParamDTO dto = new MypageProfileUpdateParamDTO();
        dto.setLoginID(loginId);
        dto.setImgName(newFileName);
        dto.setImgLogiPath("/" + logiProfilePath);
        dto.setImgPhyPath(phyProfilePath);

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
    public int deleteResume(String loginId) throws Exception {

        MypageResumeVO oldResume = studentMypageDao.getResumeByLoginId(loginId);
        if (oldResume == null) {
            return 1;
        }

        if (oldResume.getPhysicalPath() != null) {
            MypageFileUtil.delete(oldResume.getPhysicalPath());
        }

        return studentMypageDao.deleteResumeByLoginId(loginId);
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

        String downloadFileName = resolveOriginalResumeName(resume.getName());
        String encodedName = URLEncoder.encode(downloadFileName, "UTF-8").replace("+", "%20");

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

    private String resolveOriginalResumeName(String storedName) {
        if (storedName == null || storedName.isEmpty()) {
            return "resume";
        }

        Matcher matcher = RESUME_NAME_PATTERN.matcher(storedName);
        if (matcher.matches()) {
            return matcher.group(1);
        }
        return storedName;
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
    public Map<String, Object> getStudentCourseStatusPageData(String loginID) {
        return buildCourseStatusResponse(studentMypageDao.getStudentCourseStatusCards(loginID), false);
    }


    @Override
    public List<SMypagePeriodScoreVO> getCoursePeriodScores(String loginID, int courseId) {
        Map<String, Object> param = new HashMap<>();
        param.put("loginID", loginID);
        param.put("courseId", courseId);
        return studentMypageDao.getCoursePeriodScores(param);
    }

    private Map<String, Object> buildCourseStatusResponse(List<Map<String, Object>> rows, boolean instructorMode) {
        List<Map<String, Object>> courses = new ArrayList<>();
        int inProgressCount = 0;
        int scheduledCount = 0;
        int completedCount = 0;

        for (Map<String, Object> row : rows) {
            String startDate = stringValue(row.get("startDate"));
            String endDate = stringValue(row.get("endDate"));
            String statusCode = resolveStatusCode(startDate, endDate);
            String statusLabel = resolveStatusLabel(statusCode);

            if ("inProgress".equals(statusCode)) inProgressCount++;
            if ("scheduled".equals(statusCode)) scheduledCount++;
            if ("completed".equals(statusCode)) completedCount++;

            Map<String, Object> course = new HashMap<>();
            course.put("courseId", intValue(row.get("courseId")));
            course.put("title", stringValue(row.get("title")));
            course.put("className", stringValue(row.get("className")));
            course.put("startDate", startDate);
            course.put("endDate", endDate);
            course.put("startTime", stringValue(row.get("startTime")));
            course.put("endTime", stringValue(row.get("endTime")));
            course.put("statusCode", statusCode);
            course.put("statusLabel", statusLabel);

            if (instructorMode) {
                course.put("studentCount", intValue(row.get("studentCount")));
            } else {
                course.put("instructorName", stringValue(row.get("instructorName")));
            }

            courses.add(course);
        }

        Map<String, Object> summary = new HashMap<>();
        summary.put("totalCount", courses.size());
        summary.put("inProgressCount", inProgressCount);
        summary.put("scheduledCount", scheduledCount);
        summary.put("completedCount", completedCount);

        Map<String, Object> response = new HashMap<>();
        response.put("summary", summary);
        response.put("courses", courses);
        return response;
    }

    private String resolveStatusCode(String startDate, String endDate) {
        LocalDate today = LocalDate.now();
        LocalDate start = parseDate(startDate);
        LocalDate end = parseDate(endDate);

        if (start != null && today.isBefore(start)) return "scheduled";
        if (end != null && today.isAfter(end)) return "completed";
        return "inProgress";
    }

    private String resolveStatusLabel(String statusCode) {
        if ("scheduled".equals(statusCode)) return "예정";
        if ("completed".equals(statusCode)) return "완료";
        return "진행중";
    }

    private LocalDate parseDate(String value) {
        try {
            return value == null || value.isEmpty() ? null : LocalDate.parse(value);
        } catch (Exception ignore) {
            return null;
        }
    }

    private String stringValue(Object value) {
        return value == null ? "" : String.valueOf(value);
    }

    private int intValue(Object value) {
        if (value instanceof Number) return ((Number) value).intValue();
        try {
            return Integer.parseInt(String.valueOf(value));
        } catch (Exception ignore) {
            return 0;
        }
    }

}
