package kr.happyjob.study.domain.instructor.controller;

import kr.happyjob.study.domain.admin.model.AQnaCommentVO;
import kr.happyjob.study.domain.admin.service.AQnaCommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/inst/qna/comment")
public class IQnaCommentController {

    @Autowired
    private AQnaCommentService commentService;

    // 댓글 목록 조회
    @RequestMapping(value="/list", method= RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> selectCommentList(@RequestParam("postId") int postId) throws Exception {
        List<AQnaCommentVO> list = commentService.selectCommentList(postId);
        Map<String, Object> result = new HashMap<>();
        result.put("result", "SUCCESS");
        result.put("data", list);
        return result;
    }

    // 댓글 등록
    @RequestMapping(value="/save", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> insertComment(@RequestParam Map<String, Object> paramMap,
                                             HttpSession session) throws Exception {
        Map<String, Object> res = new HashMap<>();
        String loginId = (String) session.getAttribute("loginId");

        if (loginId == null) {
            res.put("result", "FAIL");
            res.put("message", "로그인이 필요합니다.");
            return res;
        }

        AQnaCommentVO vo = new AQnaCommentVO();
        vo.setPostId(Long.parseLong(String.valueOf(paramMap.get("postId"))));
        vo.setContent((String) paramMap.get("content"));
        vo.setLoginID(loginId);
        vo.setIsTeacher("Y"); // 강사 페이지이므로 Y로 설정
        vo.setIsDeleted("N");

        int inserted = commentService.insertComment(vo);
        res.put("result", inserted > 0 ? "SUCCESS" : "FAIL");
        return res;
    }

    // 댓글 수정
    @RequestMapping(value="/update", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> updateComment(@RequestParam("commentId") int commentId,
                                             @RequestParam("content") String content) throws Exception {
        AQnaCommentVO vo = new AQnaCommentVO();
        vo.setCommentId((long) commentId);
        vo.setContent(content);

        int updated = commentService.updateComment(vo);
        Map<String, Object> res = new HashMap<>();
        res.put("result", updated > 0 ? "SUCCESS" : "FAIL");
        return res;
    }

    // 댓글 삭제
    @RequestMapping(value="/delete", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteComment(@RequestParam("commentId") int commentId) throws Exception {
        int deleted = commentService.deleteComment(commentId);
        Map<String, Object> res = new HashMap<>();
        res.put("result", deleted > 0 ? "SUCCESS" : "FAIL");
        return res;
    }
}