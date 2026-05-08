package kr.happyjob.study.domain.admin.service;

import kr.happyjob.study.domain.admin.model.AQnaCommentVO;

import java.util.List;
import java.util.Map;

public interface AQnaCommentService {

    /** 댓글 목록 조회 */
    List<AQnaCommentVO> selectCommentList(int postId) throws Exception;

    /** 댓글 등록 */
    int insertComment(AQnaCommentVO vo) throws Exception;

    /** 댓글 수정 */
    int updateComment(AQnaCommentVO vo) throws Exception;

    /** 댓글 삭제 */
    int deleteComment(int commentId) throws Exception;

    /** 게시글별 댓글 개수 */
    int countCommentByPost(int postId) throws Exception;

}
