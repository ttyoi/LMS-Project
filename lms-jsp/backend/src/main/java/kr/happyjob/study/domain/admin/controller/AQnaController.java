package kr.happyjob.study.domain.admin.controller;

import kr.happyjob.study.domain.admin.model.AQnaVO;
import kr.happyjob.study.domain.admin.service.AQnaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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

@Controller
@RequestMapping("/admin/qna")
public class AQnaController {

    @Autowired
    private AQnaService aqnaService;

    @Value("${file.upload.logical-qna}")
    private String logiQnaPath;
    
    // 화면 진입용
    @GetMapping
    public String qnaPage() {
        return "admin/qnaList";
    }

    // 게시글 전체 목록 조회
    @RequestMapping("")
    @ResponseBody
    public Map<String, Object> qnaListPage(
            @RequestParam(value="page", defaultValue = "1") int page,
            @RequestParam(value="category", required=false) String category,
            @RequestParam(value="keyword", required=false) String keyword,
            @RequestParam(value="answerStatus", required=false) String answerStatus,
            @RequestParam(value="userType", required=false) String userType, // userRole -> userType 변경
            @RequestParam(value="loginID", required=false) String loginID) throws Exception {

        Map<String, Object> resultMap = new HashMap<>();
        int pageSize = 10;
        int startNum = (page - 1) * pageSize;

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("startNum", startNum);
        paramMap.put("pageSize", pageSize);
        paramMap.put("category", category);
        paramMap.put("keyword", keyword);
        paramMap.put("answerStatus", answerStatus);
        paramMap.put("userType", userType); // 변경
        paramMap.put("loginID", loginID);

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

    // 게시글 상세 조회
    @RequestMapping("/detail")
    @ResponseBody
    public Map<String, Object> qnaDetailPage(@RequestParam("postId") int postId) throws Exception{
        Map<String, Object> resultMap = new HashMap<>();
        AQnaVO detail = aqnaService.selectQnaDetail(postId);

        // 사진이 있는 경우 미리보기용 논리 경로 세팅 (팀원 방식 참고)
        if (detail != null && detail.getFilSavName() != null && !detail.getFilSavName().isEmpty()) {
          resultMap.put("imgLogiPath", "/" + logiQnaPath + detail.getFilSavName());
        } else {
          resultMap.put("imgLogiPath", "");
        }

        resultMap.put("detail", detail);
        resultMap.put("result", "SUCCESS");
        return resultMap;
    }

    // 게시글 작성 (공용폼 mode:write)
    // 작성&수정 : 같은 페이지, 다른 mode 사용
    @RequestMapping(value="/save", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveQnaPost(@ModelAttribute AQnaVO vo,
                                           @RequestParam(value="uploadFile", required=false) MultipartFile file,
                                           HttpSession session) throws Exception{
        Map<String, Object> resultMap = new HashMap<>();

        String loginId = (String)session.getAttribute("loginId");
        vo.setLoginID(loginId);
        vo.setAnswerStatus("N");
        vo.setIsDeleted("N");

      // 서비스단에서 파일 저장 및 insert 수행
        int result = aqnaService.insertQnaPost(vo, file);
        resultMap.put("result", result > 0 ? "SUCCESS" : "FAIL");
        return resultMap;
    }


    // 게시글 수정 및 저장
    @RequestMapping(value="/update", method=RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> updateQnaPost(@ModelAttribute AQnaVO vo,
                                             @RequestParam(value="uploadFile", required=false) MultipartFile file,
                                             HttpSession session) throws Exception{
        Map<String, Object> resultMap = new HashMap<>();

        // 수정시에도 세션 아이디 확인하도록 로직 추가
        String loginId = (String)session.getAttribute("loginId");
        vo.setLoginID(loginId);

        int result = aqnaService.updateQnaPost(vo, file);
        resultMap.put("result", result > 0 ? "SUCCESS" : "FAIL");
        return resultMap;
    }


    // 게시글 삭제
    @RequestMapping("/delete")
    @ResponseBody
    public Map<String, Object> qnaDelete(@RequestParam("postId") int postId) throws Exception{
        Map<String, Object> resultMap = new HashMap<>();
        int result = aqnaService.deleteQnaPost(postId);
        resultMap.put("result", result > 0 ? "SUCCESS" : "FAIL");
        return resultMap;
    }

    @RequestMapping("/download")
    public void downloadFile(@RequestParam("postId") int postId, HttpServletResponse response) throws Exception {
        AQnaVO fileInfo = aqnaService.selectQnaDetail(postId);

        if (fileInfo == null || fileInfo.getFilSavName() == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File info not found");
            return;
        }

        // DB에서 가져온 경로와 파일명 조합
        String savePath = fileInfo.getPhysicalPath();
        String fileName = fileInfo.getFilSavName();

        File file = new File(savePath, fileName); // 생성자에서 결합하면 구분자 걱정이 없습니다.

        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found on Server");
            return;
        }

        String oriName = fileInfo.getFilOriName();
        String encodedFileName = URLEncoder.encode(oriName, "UTF-8").replaceAll("\\+", "%20");

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
            os.flush();
        }
    }

    @RequestMapping("/teachers")
    @ResponseBody
    public Map<String, Object> getTeacherList() throws Exception {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<Map<String, Object>> dbTeachers = aqnaService.selectTeacherList();
            List<Map<String, Object>> teacherList = new java.util.ArrayList<>();

            // 1. 관리자 수동 추가
            Map<String, Object> admin = new HashMap<>();
            admin.put("id", "admin");
            admin.put("name", "관리자");
            teacherList.add(admin);

            // 2. 강사 목록 가공
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
