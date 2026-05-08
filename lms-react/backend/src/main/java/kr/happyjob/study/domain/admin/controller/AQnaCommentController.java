package kr.happyjob.study.domain.admin.controller;

import kr.happyjob.study.domain.admin.service.AQnaCommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import kr.happyjob.study.domain.admin.model.AQnaCommentVO;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/api/admin/qna/comment")
public class AQnaCommentController {
	
    @Autowired
    private AQnaCommentService commentService;

    // 댓글 목록 조회 (AJAX get)
    @RequestMapping(value="/api/list", method= RequestMethod.GET)
    @ResponseBody
    public Map<String,Object> selectCommentList(@RequestParam("postId") int postId) throws Exception{

        List<AQnaCommentVO> list= commentService.selectCommentList(postId);

        Map<String, Object> result= new HashMap<>();
        result.put("result", "SUCCESS");
        result.put("data", list);
        result.put("count", list.size());

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
        vo.setIsTeacher("N");
        vo.setIsDeleted("N");

        int inserted = commentService.insertComment(vo);
        res.put("result", inserted > 0 ? "SUCCESS" : "FAIL");
        return res;
    }

    // 댓글 삭제
    @RequestMapping(value="/delete", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteComment(@RequestParam("commentId") int commentId,
 HttpSession session) throws Exception {

        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) {
            Map<String,Object> error = new HashMap<>();
            error.put("result", "FAIL");
            error.put("message", "로그인이 필요합니다.");
            return error;
        }

        int deleted = commentService.deleteComment(commentId);

        Map<String, Object> res = new HashMap<>();
        res.put("result", deleted > 0 ? "SUCCESS" : "FAIL");
        return res;
    }

    // 댓글 수정
    @RequestMapping(value="/update", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> updateComment(@RequestParam("commentId") int commentId,
    @RequestParam("content") String content,
HttpSession session) throws Exception {

        // 로그인 체크
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) {
            Map<String,Object> error = new HashMap<>();
            error.put("result", "FAIL");
            error.put("message", "로그인이 필요합니다.");
            return error;
        }

        // VO 생성
        AQnaCommentVO vo = new AQnaCommentVO();
        vo.setCommentId((long)commentId);
        vo.setContent(content);

        // DB 업데이트
        int updated = commentService.updateComment(vo);

        Map<String,Object> res = new HashMap<>();
        res.put("result", updated > 0 ? "SUCCESS" : "FAIL");
        return res;
    }

}
