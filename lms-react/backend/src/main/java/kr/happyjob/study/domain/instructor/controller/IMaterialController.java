package kr.happyjob.study.domain.instructor.controller;

import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.happyjob.study.domain.instructor.model.FileVO;
import kr.happyjob.study.domain.instructor.model.ICourseSimpleVO;
import kr.happyjob.study.domain.instructor.model.IMaterialSearchDTO;
import kr.happyjob.study.domain.instructor.model.IMaterialVO;
import kr.happyjob.study.domain.instructor.service.IMaterialService;

@Controller
@RequestMapping("inst/")
public class IMaterialController {

    @Autowired
    IMaterialService iMaterialService;

    Logger logger = LoggerFactory.getLogger(IMaterialController.class);
    
    @GetMapping("/materials")
    public String materialsPage() {
        return "/instructor/materials";
    }
    
    // 1. 강사의 강의 목록 조회 (셀렉트박스용)
    @ResponseBody
    @GetMapping("loadInstCourse")
    public List<ICourseSimpleVO> loadInstCourse(HttpSession session) {
        String loginID = (String) session.getAttribute("loginId");
        return iMaterialService.loadInstCourse(loginID);
    }

    // 2. 학습자료 목록 조회 (페이징 포함)
    @ResponseBody
    @GetMapping("loadMaterials")
    public Map<String, Object> loadMaterials(IMaterialSearchDTO iMaterialSearchDTO, HttpSession session) {
        String loginID = (String) session.getAttribute("loginId");
        iMaterialSearchDTO.setLoginID(loginID);
         System.out.println("DEBUG: 현재 세션 loginId = " + loginID);

        int totalCnt = iMaterialService.totalCnt(iMaterialSearchDTO);

        int start = (iMaterialSearchDTO.getCurrentPage() - 1) * iMaterialSearchDTO.getPageSize();
        iMaterialSearchDTO.setStart(start);
        iMaterialSearchDTO.setLimit(iMaterialSearchDTO.getPageSize());

        List<IMaterialVO> materialList = iMaterialService.loadMaterials(iMaterialSearchDTO);

        Map<String, Object> result = new HashMap<>();
        result.put("materialList", materialList);
        result.put("totalCnt", totalCnt);
        return result;
    }

    // 3. 학습자료 등록 (파일 포함)
    @ResponseBody
    @PostMapping("insertMaterial")
    public Map<String, Object> insertMaterial(IMaterialVO iMaterialVO, MultipartHttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            iMaterialService.insertMaterial(iMaterialVO, request);
            result.put("status", 200);
            result.put("msg", "등록 성공");
        } catch (Exception e) {
            result.put("status", 500);
            result.put("msg", e.getMessage());
        }
        return result;
    }

    // 4. 학습자료 수정
    @ResponseBody
    @PostMapping("updateMaterial")
    public Map<String, Object> updateMaterial(@ModelAttribute IMaterialVO iMaterialVO) {
        Map<String, Object> result = new HashMap<>();
        iMaterialService.updateMaterial(iMaterialVO);
        result.put("status", 200);
        return result;
    }

    // 5. 학습자료 삭제
    @ResponseBody
    @PostMapping("deleteMaterial")
    public Map<String, Object> deleteMaterial(@RequestParam Long materials_id, @RequestParam(required = false) Long file_id) {
        Map<String, Object> result = new HashMap<>();
        try {
            iMaterialService.deleteMaterial(materials_id, file_id);
            result.put("status", 200);
        } catch (Exception e) {
            result.put("status", 500);
        }
        return result;
    }


    // 6. 파일 다운로드
    @GetMapping("/downloadMaterial") // Added leading slash for clarity
    public void downloadMaterial(@RequestParam("file_id") Long file_id, HttpServletResponse response) {
        try {
            FileVO file = iMaterialService.selectFile(file_id);

            // 1. Check if record exists
            if (file == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "File record not found in database.");
                return;
            }

            File fileObj = new File(file.getPhysical_path());

            // 2. Check if physical file exists
            if (!fileObj.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Physical file not found on server.");
                return;
            }

            // 3. Set Headers correctly
            String encodedFileName = URLEncoder.encode(file.getName(), "UTF-8").replaceAll("\\+", "%20");
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");
            response.setContentLength(file.getSize());

            // 4. Stream the file
            try (FileInputStream fis = new FileInputStream(fileObj)) {
                FileCopyUtils.copy(fis, response.getOutputStream());
                response.getOutputStream().flush();
            }

        } catch (Exception e) {
            e.printStackTrace(); // This will show the real error in your console
        }
    }
}
