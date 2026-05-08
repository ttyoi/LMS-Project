package kr.happyjob.study.domain.instructor.service;

import kr.happyjob.study.common.comnUtils.MypageFileUtil;
import kr.happyjob.study.domain.instructor.dao.IMypageDAO;
import kr.happyjob.study.domain.instructor.model.*;
import kr.happyjob.study.domain.student.model.MypagePasswordChangeParamDTO;
import kr.happyjob.study.domain.student.model.MypageProfileUpdateParamDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class IMypageServiceImpl implements IMypageService {

    @Autowired
    IMypageDAO instructorMypageDao;

    @Value("${file.upload.physical-profile-path}")
    private String phyProfilePath;

    @Value("${file.upload.logical-profile}")
    private String logiProfilePath;

    private int updateProfileImage(MypageProfileUpdateParamDTO dto) throws Exception {

        IMypageVO user = instructorMypageDao.getInstructorMypage(dto.getLoginID());

        if (user != null && user.getImgPhyPath() != null && user.getImgName() != null) {
            String oldPath = user.getImgPhyPath() + user.getImgName();
            MypageFileUtil.delete(oldPath);
        }

        return instructorMypageDao.updateProfileImage(dto);
    }


    @Override
    public IMypageVO getInstructorMypage(String loginId) throws Exception {
        return instructorMypageDao.getInstructorMypage(loginId);
    }

    @Override
    public int updateInstructorMypage(IUpdateDTO dto) throws Exception {
        return instructorMypageDao.updateInstructorMypage(dto);
    }

    @Override
    public int updateEduCareer(IUpdateEduCareerDTO dto) throws Exception {
        return instructorMypageDao.updateEduCareer(dto);
    }

    @Override
    public int changePassword(MypagePasswordChangeParamDTO dto) throws Exception {
        int count = instructorMypageDao.checkOldPassword(dto);

        if(count == 0) {
            return -1;
        }

        if(dto.getOldPw().equals(dto.getNewPw())) {
            return -2;
        }

        int result = instructorMypageDao.changePassword(dto);

        if(result > 0) {
            instructorMypageDao.updateTempPasswordFlag(dto.getLoginID());
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
        
        physicalPath = physicalPath.replace("file:////", "\\\\");
        physicalPath = physicalPath.replace("/", "\\");
        
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
    public IEduCareerVO getEduCareer(String loginId) {
        return instructorMypageDao.getEduCareer(loginId);
    }

    @Override
    public List<IMyCourseVO> getMyCourseList(Map<String, Object> param) {
        return instructorMypageDao.getMyCourseList(param);
    }

    @Override
    public Map<String, Object> getInstructorCourseStatusPageData(String loginID) {
        return buildCourseStatusResponse(instructorMypageDao.getInstructorCourseStatusCards(loginID));
    }

    @Override
    public int getMyCourseListCnt(Map<String, Object> param) {
        return instructorMypageDao.getMyCourseListCnt(param);
    }

    private Map<String, Object> buildCourseStatusResponse(List<Map<String, Object>> rows) {
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
            course.put("studentCount", intValue(row.get("studentCount")));
            course.put("statusCode", statusCode);
            course.put("statusLabel", statusLabel);
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
