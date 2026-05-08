package kr.happyjob.study.domain.instructor.controller;

import kr.happyjob.study.domain.admin.model.AQnaVO;
import kr.happyjob.study.domain.admin.service.AQnaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;

@Controller
@RequestMapping("/inst/qna")
public class IQnaController {

    @Autowired
    private AQnaService aqnaService;

    // 설정 파일의 경로값 읽어오기
    @Value("${fileUpload.rootPath}")
    private String rootPath;

    @Value("${fileUpload.noticePath}") // QNA용 경로가 따로 없다면 noticePath 혹은 적절한 키 사용
    private String qnaPath;
    
    // 화면 진입용
    @GetMapping
    public String qnaPage() {
        return "instructor/qnaList";
    }

    // 1. 목록 조회
    @GetMapping("/list")
    @ResponseBody
    public Map<String, Object> qnaListPage(
            @RequestParam(value="page", defaultValue = "1") int page,
            @RequestParam(value="loginID", required=false) String loginID,
            @RequestParam(value="userType", required=false) String userType, // userRole -> userType 변경
            @RequestParam(value="category", required=false) String category,
            @RequestParam(value="keyword", required=false) String keyword,
            @RequestParam(value="answerStatus", required=false) String answerStatus) throws Exception {

        Map<String, Object> resultMap = new HashMap<>();
        int pageSize = 10;
        int startNum = (page - 1) * pageSize;

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("loginID", loginID);
        paramMap.put("userType", userType); // 변경
        paramMap.put("startNum", startNum);
        paramMap.put("pageSize", pageSize);
        paramMap.put("category", category);
        paramMap.put("keyword", keyword);
        paramMap.put("answerStatus", answerStatus);

        List<Map<String, Object>> categories = aqnaService.selectCategoryList();
        List<AQnaVO> list = aqnaService.selectQnaList(paramMap);
        int totalCnt = aqnaService.selectQnaListCnt(paramMap);

        resultMap.put("qnaList", list);
        resultMap.put("categories", categories);
        resultMap.put("totalCnt", totalCnt);
        resultMap.put("page", page);
        resultMap.put("pageSize", pageSize);

        return resultMap;
    }

    // 2. 상세 조회 (JSON 반환)
    @RequestMapping("/detail")
    @ResponseBody
    public Map<String, Object> qnaDetailPage(@RequestParam("postId") int postId) throws Exception {
        Map<String, Object> resultMap = new HashMap<>();
        AQnaVO detail = aqnaService.selectQnaDetail(postId);

        resultMap.put("detail", detail);
        resultMap.put("result", "SUCCESS");
        return resultMap;
    }

    // 3. 게시글 저장
    @RequestMapping(value="/save", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveQnaPost(@ModelAttribute AQnaVO vo,
                                           @RequestParam(value="uploadFile", required=false) MultipartFile file,
                                           HttpSession session) throws Exception {
        Map<String, Object> resultMap = new HashMap<>();
        String loginId = (String) session.getAttribute("loginId");

        vo.setLoginID(loginId);
        vo.setAnswerStatus("N");
        vo.setIsDeleted("N");

        if (file != null && !file.isEmpty()) {
            String oriName = file.getOriginalFilename();
            String saveName = java.util.UUID.randomUUID().toString() + oriName.substring(oriName.lastIndexOf("."));

            // 설정 파일 기반 경로 조합
            String fullUploadPath = rootPath + qnaPath + File.separator;

            File dest = new File(fullUploadPath + saveName);
            if (!dest.getParentFile().exists()) dest.getParentFile().mkdirs();
            file.transferTo(dest);

            vo.setFilOriName(oriName);
            vo.setFilSavName(saveName);
            vo.setPhysicalPath(fullUploadPath); // DB에 전체 경로 저장
        }

        int result = aqnaService.insertQnaPost(vo, file);
        resultMap.put("result", result > 0 ? "SUCCESS" : "FAIL");
        return resultMap;
    }

    // 4. 게시글 수정
    @RequestMapping(value="/update", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> updateQnaPost(@ModelAttribute AQnaVO vo,
                                             @RequestParam(value="uploadFile", required=false) MultipartFile file,
                                             HttpSession session) throws Exception {
        Map<String, Object> resultMap = new HashMap<>();
        String loginId = (String) session.getAttribute("loginId");

        AQnaVO existPost = aqnaService.selectQnaDetail((int)vo.getPostId());
        if (existPost == null || !existPost.getLoginID().equals(loginId)) {
            resultMap.put("result", "FAIL");
            resultMap.put("message", "본인의 글만 수정할 수 있습니다.");
            return resultMap;
        }

        if (file != null && !file.isEmpty()) {
            String oriName = file.getOriginalFilename();
            String saveName = java.util.UUID.randomUUID().toString() + oriName.substring(oriName.lastIndexOf("."));

            // 설정 파일 기반 경로 조합
            String fullUploadPath = rootPath + qnaPath + File.separator;

            File dest = new File(fullUploadPath + saveName);
            if (!dest.getParentFile().exists()) dest.getParentFile().mkdirs();
            file.transferTo(dest);

            vo.setFilOriName(oriName);
            vo.setFilSavName(saveName);
            vo.setPhysicalPath(fullUploadPath);
        }

        int result = aqnaService.updateQnaPost(vo, file);
        resultMap.put("result", result > 0 ? "SUCCESS" : "FAIL");
        return resultMap;
    }

    // 5. 게시글 삭제 (본인 확인 로직 추가)
    @RequestMapping("/delete")
    @ResponseBody
    public Map<String, Object> qnaDelete(@RequestParam("postId") int postId, HttpSession session) throws Exception { // HttpSession 추가
        Map<String, Object> resultMap = new HashMap<>();

        // 세션에서 로그인한 ID 가져오기
        String loginId = (String) session.getAttribute("loginId");

        // DB에서 기존 게시글 정보 조회하여 작성자 대조
        AQnaVO existPost = aqnaService.selectQnaDetail(postId);
        if (existPost == null || !existPost.getLoginID().equals(loginId)) {
            resultMap.put("result", "FAIL");
            resultMap.put("message", "본인의 글만 삭제할 수 있습니다.");
            return resultMap;
        }

        int result = aqnaService.deleteQnaPost(postId);
        resultMap.put("result", result > 0 ? "SUCCESS" : "FAIL");
        return resultMap;
    }

    // 6. 파일 다운로드 (안전한 File 생성 방식 적용)
    @RequestMapping("/download")
    public void downloadFile(@RequestParam("postId") int postId, HttpServletResponse response) throws Exception {
        AQnaVO fileInfo = aqnaService.selectQnaDetail(postId);

        if (fileInfo == null || fileInfo.getFilSavName() == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "파일 정보가 없습니다.");
            return;
        }

        // DB에 저장된 실제 경로와 파일명 조합
        File file = new File(fileInfo.getPhysicalPath(), fileInfo.getFilSavName());

        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "서버에 파일이 존재하지 않습니다.");
            return;
        }

        String encodedFileName = URLEncoder.encode(fileInfo.getFilOriName(), "UTF-8").replaceAll("\\+", "%20");
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");
        response.setContentLength((int) file.length());

        try (FileInputStream fis = new FileInputStream(file);
             ServletOutputStream os = response.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        }
    }

    @RequestMapping("/teachers")
    @ResponseBody
    public Map<String, Object> getTeacherList() throws Exception {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<Map<String, Object>> dbTeachers = aqnaService.selectTeacherList();
            List<Map<String, Object>> teacherList = new java.util.ArrayList<>();

            // 관리자 추가
            Map<String, Object> admin = new HashMap<>();
            admin.put("id", "admin");
            admin.put("name", "관리자");
            teacherList.add(admin);

            // 강사 목록 가공 (Mapper의 selectTeacherList 활용)
            for (Map<String, Object> t : dbTeachers) {
                Map<String, Object> tMap = new HashMap<>();
                tMap.put("id", t.get("id"));
                tMap.put("name", t.get("name") + " 강사");
                teacherList.add(tMap);
            }

            resultMap.put("list", teacherList);
            resultMap.put("result", "SUCCESS");
        } catch (Exception e) {
            resultMap.put("result", "FAIL");
        }
        return resultMap;
    }
}
