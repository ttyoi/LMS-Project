package kr.happyjob.study.domain.notice.controller;

import kr.happyjob.study.domain.notice.model.NoticeNewVO;
import kr.happyjob.study.domain.notice.service.NoticeNewService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class NoticeNewController {
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
    @GetMapping({"/admin/notices", "/stu/notices", "/inst/notices"})
    public String selectNoticeList(@RequestParam Map<String,Object> paramMap, HttpSession session, Model model) {

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
        Integer pageSize  = (Integer) session.getAttribute("noticePageSize");

        if (paramMap.get("currentPage") != null) {
            currentPage = Integer.parseInt(paramMap.get("currentPage").toString());
            session.setAttribute("noticeCurrentPage", currentPage);
        }
        if (paramMap.get("pageSize") != null) {
            pageSize = Integer.parseInt(paramMap.get("pageSize").toString());
            session.setAttribute("noticePageSize", pageSize);
        }

        if (currentPage == null) currentPage = 1;
        if (pageSize == null) pageSize    = 10;

        int startNum = (currentPage - 1)* pageSize;

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
        if (sname == null) sname  = "";

        session.setAttribute("noticeSearchType", searchType);
        session.setAttribute("noticeSearchSname", sname);

        Map<String, Object> queryMap = new HashMap<>();
        queryMap.put("startNum", startNum);
        queryMap.put("pageSize", pageSize);
        queryMap.put("searchType", searchType);
        queryMap.put("sname", sname);


        List<NoticeNewVO> noticeList = noticeNewService.selctNoticeList(queryMap);
        int noticeCnt = noticeNewService.selectNoticeCount(queryMap);

        model.addAttribute("notice", noticeList);
        model.addAttribute("noticeCnt", noticeCnt);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("pageSize", pageSize);
        // 검색
        model.addAttribute("searchType", searchType);
        model.addAttribute("sname", sname);


        // 나옴(검색전)
        System.out.println("noticeCnt = " + noticeCnt);
        System.out.println("noticeList = " + noticeList);

        return "notice/noticeList";
    }
    // 수정
    @PostMapping("/admin/notices/updateContent")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateOneNoticeContent(
            @RequestParam Map<String, Object> paramMap,
            HttpSession session
    ) {
        if (!isAdmin(session)) {
            return forbiddenResponse();
        }

        int result = noticeNewService.updateOneNoticeContent(paramMap);

        Map<String, Object> res = new HashMap<>();
        res.put("result", result >0? "success": "fail" );
        return ResponseEntity.ok(res);
    }

    // 새글작성
    @PostMapping("/admin/notices/insertNotice")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> insertNewNotice(
            @RequestParam Map<String, Object> paramMap,
            HttpSession session
    ) {
        if (!isAdmin(session)) {
            return forbiddenResponse();
        }

        String loginID =(String) session.getAttribute("loginId");

        paramMap.put("loginID", loginID);
        int result = noticeNewService.insertNewNotice(paramMap);
        Map<String,Object> resultMap = new HashMap<>();
        resultMap.put("result", result >0? "success": "fail" );
        return ResponseEntity.ok(resultMap);
    }
    // 삭제
    @PostMapping("/admin/notices/deleteNotice")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> delectOneNotice(
            @RequestParam("noticeId") int noticeId,
            HttpSession session
    ) {
        if (!isAdmin(session)) {
            return forbiddenResponse();
        }

        int result = noticeNewService.delectOneNotice(noticeId);
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", result >0? "success": "fail" );
        return ResponseEntity.ok(resultMap);
    }

    // 조회수
    @PostMapping("/admin/notices/viewCount")
    @ResponseBody
    public Map<String, Object> updateNoticeViewCount(@RequestParam("noticeId") int noticeId) {
        int result = noticeNewService.updateNoticeViewCount(noticeId);
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", result >0? "success": "fail" );
        return resultMap;
    }

}
