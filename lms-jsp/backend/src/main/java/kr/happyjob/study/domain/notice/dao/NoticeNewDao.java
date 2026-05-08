package kr.happyjob.study.domain.notice.dao;

import kr.happyjob.study.domain.notice.model.NoticeNewVO;
import kr.happyjob.study.system.model.NoticeModel;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface NoticeNewDao {
    List<NoticeNewVO> findNoticeList(Map<String, Object> paramMap); // 목록 불러오기
    NoticeNewVO findNoticeDetail(@Param("noticeId") int noticeId); // 상세 조회
    int countNotice(Map<String, Object> paramMap); // 목록 개수
    //등록
    int insertNotice(Map<String, Object> paramMap);
    //수정
    int updateNoticeContent(Map<String, Object> paramMap);
    //삭제
    int deleteNotice(@Param("noticeId") int noticeId);
    //조회수
    int noticeViewCount(int noticeId);

    //대쉬보드용 조회
    public List<NoticeModel> dashboardNoticeList(Map<String, Object> paramMap);
}