package kr.happyjob.study.domain.notice.service;

import kr.happyjob.study.domain.notice.model.NoticeNewVO;

import java.util.List;
import java.util.Map;

public interface NoticeNewService {
    // 공지 리스트
    List<NoticeNewVO> selctNoticeList(Map<String, Object> paramMap);
    // 공지 상세
    NoticeNewVO selectNoticeDetail(int noticeId);
    // 공지 개수
    int selectNoticeCount(Map<String, Object> paramMap);

    // 수정
    int updateOneNoticeContent(Map<String,Object> paramMap);
    // 새글 작성
    int insertNewNotice(Map<String, Object> paramMap);

    // 삭제
    int delectOneNotice(int noticeId);
    // 조회수
    int updateNoticeViewCount(int noticeId);
}
