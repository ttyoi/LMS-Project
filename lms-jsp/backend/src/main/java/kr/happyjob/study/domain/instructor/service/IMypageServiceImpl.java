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

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class IMypageServiceImpl implements IMypageService {

    @Autowired
    IMypageDAO instructorMypageDao;

    @Value("${file.upload.physical-path}")
    private String phyRootPath;

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

        if(dto.getOldPw().equals(dto.getNewPw())) {
            return -2;
        }
        int count = instructorMypageDao.checkOldPassword(dto);

        if(count == 0) {
            return -1;
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

        String physicalPath = phyRootPath + logiProfilePath + newFileName;
        
        physicalPath = physicalPath.replace("file:////", "\\\\");
        physicalPath = physicalPath.replace("/", "\\");
        
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
    public IEduCareerVO getEduCareer(String loginId) {
        return instructorMypageDao.getEduCareer(loginId);
    }

    @Override
    public List<IMyCourseVO> getMyCourseList(Map<String, Object> param) {
        return instructorMypageDao.getMyCourseList(param);
    }

    @Override
    public int getMyCourseListCnt(Map<String, Object> param) {
        return instructorMypageDao.getMyCourseListCnt(param);
    }

}
