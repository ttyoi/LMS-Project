package kr.happyjob.study.domain.notice.service;

import kr.happyjob.study.domain.notice.dao.NoticeNewDao;
import kr.happyjob.study.domain.notice.model.NoticeNewVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class NoticeNewServiceImpl implements NoticeNewService {

    @Autowired
    private NoticeNewDao noticeNewDao;

    @Override
    public List<NoticeNewVO> selctNoticeList(Map<String, Object> paramMap){
        return noticeNewDao.findNoticeList(paramMap);
    }

    @Override
    public NoticeNewVO selectNoticeDetail(int noticeId) {
        return noticeNewDao.findNoticeDetail(noticeId);
    }

    @Override
    public int selectNoticeCount(Map<String, Object> paramMap){

        return noticeNewDao.countNotice(paramMap);
    }

    @Override
    public int updateOneNoticeContent(Map<String, Object> paramMap){
        return noticeNewDao.updateNoticeContent(paramMap);
    }
    @Override
    public int insertNewNotice(Map<String, Object> paramMap){
        return noticeNewDao.insertNotice(paramMap);
    }

    @Override
    public int delectOneNotice( int noticeId){
        return noticeNewDao.deleteNotice(noticeId);
    }
    @Override
    public int updateNoticeViewCount(int noticeId){
        return noticeNewDao.noticeViewCount(noticeId);
    }
}
