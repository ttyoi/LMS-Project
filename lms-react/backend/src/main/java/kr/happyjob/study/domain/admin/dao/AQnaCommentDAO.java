package kr.happyjob.study.domain.admin.dao;

import kr.happyjob.study.domain.admin.model.AQnaCommentVO;

import java.util.List;
import java.util.Map;

public interface AQnaCommentDAO {

    /** 댓글 목록 조회 (postId 기준) */
    public List<AQnaCommentVO> selectCommentList(int postId) throws Exception;

    /** 댓글 저장 */
    public int insertComment(AQnaCommentVO vo) throws Exception;

    /** 댓글 수정 */
    public int updateComment(AQnaCommentVO vo) throws Exception;

    /** 댓글 삭제 (is_deleted = 'Y') */
    public int deleteComment(int commentId) throws Exception;

    /** 댓글 개수 (댓글 있는지 여부 확인용) */
    public int countCommentByPost(int postId) throws Exception;

    /** 사용자 타입 조회 (A:관리자, I:강사, S:학생) */
    public String selectUserType(String loginID) throws Exception;

    /** 강사/관리자 댓글이 달릴 경우 게시글 답변상태 'Y'로 변경 */
    public int updateAnswerStatusDone(long postId) throws Exception;

}