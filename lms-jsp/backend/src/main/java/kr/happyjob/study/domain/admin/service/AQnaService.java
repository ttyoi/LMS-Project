package kr.happyjob.study.domain.admin.service;

import kr.happyjob.study.domain.admin.model.AQnaVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

public interface AQnaService {

    // 목록 조회
    public List<AQnaVO> selectQnaList(Map<String, Object> paramMap) throws Exception;

    // 목록 카운트
    public int selectQnaListCnt(Map<String, Object> paramMap) throws Exception;

    // 카테고리 목록 조회
    List<Map<String, Object>> selectCategoryList() throws Exception;

    // 상세 조회 (서비스을 호출하면 AQnaVO라는 객체를 만들어서 넘겨줌)
    public AQnaVO selectQnaDetail(int postId) throws Exception;

    // 게시글 등록
    public int insertQnaPost(AQnaVO vo, MultipartFile file) throws Exception;

    // 게시글 수정
    public int updateQnaPost(AQnaVO vo, MultipartFile file) throws Exception;

    // 게시글 삭제
    public int deleteQnaPost(int postId) throws Exception;

    // 답변상태 변경
    public int updateAnswerStatus(Map<String, Object> paramMap) throws Exception;

    // 강사 목록 조회
    List<Map<String, Object>> selectTeacherList() throws Exception;
}
