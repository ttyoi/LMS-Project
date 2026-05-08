package kr.happyjob.study.domain.admin.dao;

import kr.happyjob.study.domain.admin.model.AQnaVO;

import java.util.List;
import java.util.Map;

public interface AQnaDAO {

    /** Q&A 전체 목록 조회 */
    public List<AQnaVO> selectQnaList(Map<String, Object> paramMap) throws Exception;

    /** Q&A 목록 개수 (페이징용) */
    public int selectQnaListCnt(Map<String, Object> paramMap) throws Exception;

    /** 카테고리 목록 조회 */
    public List<Map<String, Object>> selectCategoryList() throws Exception;

    /** Q&A 상세 조회 */
    public AQnaVO selectQnaDetail(int postId) throws Exception;

    /** Q&A 신규 작성 */
    public int insertQnaPost(AQnaVO vo) throws Exception;

    /** Q&A 수정 */
    public int updateQnaPost(AQnaVO vo) throws Exception;

    /** Q&A 삭제(실제 삭제 대신 is_deleted = 'Y') */
    public int deleteQnaPost(int postId) throws Exception;

    /** 답변 상태 변경 (강사 댓글 작성 시 '답변완료') */
    public int updateAnswerStatus(Map<String, Object> paramMap) throws Exception;

    /** 강사 목록 조회 (user_type = 'I') */
    public List<Map<String, Object>> selectTeacherList() throws Exception;
}
