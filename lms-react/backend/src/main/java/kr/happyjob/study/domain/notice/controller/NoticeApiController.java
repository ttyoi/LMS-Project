package kr.happyjob.study.domain.notice.controller;

import kr.happyjob.study.domain.notice.model.NoticeNewVO;
import kr.happyjob.study.domain.notice.service.NoticeNewService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
public class NoticeApiController {
    @Autowired
    NoticeNewService noticeNewService;

    private boolean isAdmin(HttpSession session) {
        Object userType = session.getAttribute("userType");
        return "A".equals(userType);
    }

    private ResponseEntity<Map<String, Object>> forbiddenResponse() {
        Map<String, Object> res = new HashMap<>();
        res.put("result", "fail");
        res.put("message", "관리자 권한이 필요합니다.");
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(res);
    }

    // 공지사항 리스트
    @GetMapping({"/admin/notices/list", "/stu/notices/list", "/inst/notices/list"})
    public Map<String, Object> selectNoticeList(@RequestParam Map<String, Object> paramMap, HttpSession session) {
    	
        // 새로고침
        Object resetObj = paramMap.get("reset");
        if (resetObj != null && "Y".equals(resetObj.toString())) {
            session.removeAttribute("noticeCurrentPage");
            session.removeAttribute("noticePageSize");
            session.removeAttribute("noticeSearchType");
            session.removeAttribute("noticeSearchSname");
        }
        // 페이지네이션
        Integer currentPage = (Integer) session.getAttribute("noticeCurrentPage");
        Integer pageSize = (Integer) session.getAttribute("noticePageSize");

        if (paramMap.get("currentPage") != null) {
            currentPage = Integer.parseInt(paramMap.get("currentPage").toString());
            session.setAttribute("noticeCurrentPage", currentPage);
        }
        if (paramMap.get("pageSize") != null) {
            pageSize = Integer.parseInt(paramMap.get("pageSize").toString());
            session.setAttribute("noticePageSize", pageSize);
        }

        if (currentPage == null) currentPage = 1;
        if (pageSize == null) pageSize = 10;

        int startNum = (currentPage - 1) * pageSize;

        // 검색
        String searchType = (String) session.getAttribute("noticeSearchType");
        String sname = (String) session.getAttribute("noticeSearchSname");

        if (paramMap.get("searchType") != null) {
            searchType = paramMap.get("searchType").toString();
        }
        if (paramMap.get("sname") != null) {
            sname = paramMap.get("sname").toString();
        }

        if (searchType == null) searchType = "all";   // 기본 : 전체
        if (sname == null) sname = "";

        session.setAttribute("noticeSearchType", searchType);
        session.setAttribute("noticeSearchSname", sname);

        String orderType = (String) paramMap.get("orderType");
        if (orderType == null || orderType.isEmpty()) {
            orderType = "DESC"; // 기본값 설정
        }

        Map<String, Object> queryMap = new HashMap<>();
        queryMap.put("startNum", startNum);
        queryMap.put("pageSize", pageSize);
        queryMap.put("searchType", searchType);
        queryMap.put("sname", sname);
        queryMap.put("orderType", orderType);

        List<NoticeNewVO> noticeList = noticeNewService.selctNoticeList(queryMap);
        int noticeCnt = noticeNewService.selectNoticeCount(queryMap);

        Map<String, Object> res = new HashMap<>();

        res.put("notice", noticeList);
        res.put("noticeCnt", noticeCnt);
        res.put("currentPage", currentPage);
        res.put("pageSize", pageSize);
        // 검색
        res.put("searchType", searchType);
        res.put("sname", sname);


        // 나옴(검색전)
        System.out.println("noticeCnt = " + noticeCnt);
        System.out.println("noticeList = " + noticeList);

        return res;
    }

    
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------
    // 공지사항 리스트
    @GetMapping({"api/admin/notices/list", "api/stu/notices/list", "api/inst/notices/list"})
    public Map<String, Object> selectNoticeList11(@RequestParam Map<String, Object> paramMap, HttpSession session) {
    	

        // 새로고침
        Object resetObj = paramMap.get("reset");
        if (resetObj != null && "Y".equals(resetObj.toString())) {
            session.removeAttribute("noticeCurrentPage");
            session.removeAttribute("noticePageSize");
            session.removeAttribute("noticeSearchType");
            session.removeAttribute("noticeSearchSname");
        }
        // 페이지네이션
        Integer currentPage = (Integer) session.getAttribute("noticeCurrentPage");
        Integer pageSize = (Integer) session.getAttribute("noticePageSize");

        if (paramMap.get("currentPage") != null) {
            currentPage = Integer.parseInt(paramMap.get("currentPage").toString());
            session.setAttribute("noticeCurrentPage", currentPage);
        }
        if (paramMap.get("pageSize") != null) {
            pageSize = Integer.parseInt(paramMap.get("pageSize").toString());
            session.setAttribute("noticePageSize", pageSize);
        }

        if (currentPage == null) currentPage = 1;
        if (pageSize == null) pageSize = 10;

        int startNum = (currentPage - 1) * pageSize;

        // 검색
        String searchType = (String) session.getAttribute("noticeSearchType");
        String sname = (String) session.getAttribute("noticeSearchSname");

        if (paramMap.get("searchType") != null) {
            searchType = paramMap.get("searchType").toString();
        }
        if (paramMap.get("sname") != null) {
            sname = paramMap.get("sname").toString();
        }

        if (searchType == null) searchType = "all";   // 기본 : 전체
        if (sname == null) sname = "";

        session.setAttribute("noticeSearchType", searchType);
        session.setAttribute("noticeSearchSname", sname);

        String orderType = (String) paramMap.get("orderType");
        if (orderType == null || orderType.isEmpty()) {
            orderType = "DESC"; // 기본값 설정
        }

        Map<String, Object> queryMap = new HashMap<>();
        queryMap.put("startNum", startNum);
        queryMap.put("pageSize", pageSize);
        queryMap.put("searchType", searchType);
        queryMap.put("sname", sname);
        queryMap.put("orderType", orderType);

        List<NoticeNewVO> noticeList = noticeNewService.selctNoticeList(queryMap);
        int noticeCnt = noticeNewService.selectNoticeCount(queryMap);

        Map<String, Object> res = new HashMap<>();

        res.put("notice", noticeList);
        res.put("noticeCnt", noticeCnt);
        res.put("currentPage", currentPage);
        res.put("pageSize", pageSize);
        // 검색
        res.put("searchType", searchType);
        res.put("sname", sname);


        // 나옴(검색전)
        System.out.println("noticeCnt = " + noticeCnt);
        System.out.println("noticeList = " + noticeList);

        return res;
    }
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    

    // 공지 상세 조회
    @GetMapping("/admin/notices/detail")
    public Map<String, Object> selectNoticeDetail(@RequestParam("noticeId") int noticeId) {
        Map<String, Object> res = new HashMap<>();
        NoticeNewVO notice = noticeNewService.selectNoticeDetail(noticeId);
        res.put("notice", notice);
        return res;
    }

    // 수정
    @PostMapping("/admin/notices/updateContent/list")
    public ResponseEntity<Map<String, Object>> updateOneNoticeContent(
            @RequestParam Map<String, Object> paramMap,
            HttpSession session
    ) {
        if (!isAdmin(session)) {
            return forbiddenResponse();
        }

        int result = noticeNewService.updateOneNoticeContent(paramMap);
        System.out.println("==== updateNotice paramMap ====");
        paramMap.forEach((k, v) -> System.out.println(k + " = " + v));
        Map<String, Object> res = new HashMap<>();
        res.put("result", result > 0 ? "success" : "fail");
        return ResponseEntity.ok(res);
    }

    // 새글작성
    @PostMapping("/admin/notices/insertNotice/list")
    public ResponseEntity<Map<String, Object>> insertNewNotice(
            @RequestParam Map<String, Object> paramMap,
            HttpSession session
    ) {
        if (!isAdmin(session)) {
            return forbiddenResponse();
        }

        String loginID = (String) session.getAttribute("loginId");

        paramMap.put("loginID", loginID);
        int result = noticeNewService.insertNewNotice(paramMap);
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", result > 0 ? "success" : "fail");
        return ResponseEntity.ok(resultMap);
    }

    // 삭제
    @PostMapping("/admin/notices/deleteNotice/list")
    public ResponseEntity<Map<String, Object>> delectOneNotice(
            @RequestParam("noticeId") int noticeId,
            HttpSession session
    ) {
        if (!isAdmin(session)) {
            return forbiddenResponse();
        }

        int result = noticeNewService.delectOneNotice(noticeId);
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", result > 0 ? "success" : "fail");
        return ResponseEntity.ok(resultMap);
    }

    // 조회수
    @PostMapping("/admin/notices/viewCount/list")
    public Map<String, Object> updateNoticeViewCount(@RequestParam("noticeId") int noticeId) {
        int result = noticeNewService.updateNoticeViewCount(noticeId);
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", result > 0 ? "success" : "fail");
        return resultMap;
    }
}
