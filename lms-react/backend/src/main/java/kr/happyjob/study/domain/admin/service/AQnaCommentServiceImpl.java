package kr.happyjob.study.domain.admin.service;

import kr.happyjob.study.domain.admin.dao.AQnaCommentDAO;
import kr.happyjob.study.domain.admin.model.AQnaCommentVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AQnaCommentServiceImpl implements AQnaCommentService {

    @Autowired
    private AQnaCommentDAO commentDao;

    @Autowired
    private AQnaService aQnaService; // qna_service 업데이트용

    @Override
    public List<AQnaCommentVO> selectCommentList(int postId) throws Exception {
        return commentDao.selectCommentList(postId);
    }

    @Override
    public int insertComment(AQnaCommentVO vo) throws Exception {

        // 1. 로그인한 사용자 user_type 조회
        String userType = commentDao.selectUserType(vo.getLoginID());

        // 2. 강사라벨 표시 여부
        boolean isTeacher = "I".equals(userType);
        vo.setIsTeacher(isTeacher ? "Y" : "N");

        // 3. 답변 상태 변경 : 관리자(A) 또는 강사(I)
        boolean isAnswerRole = "A".equals(userType) || "I".equals(userType);

        // 4. 댓글 저장
        int result = commentDao.insertComment(vo);

        // 5. 강사 또는 관리자라면 answer_status = 'Y' 로 변경
        if (isAnswerRole) {
            commentDao.updateAnswerStatusDone(vo.getPostId());
        }

        return result;
    }

    @Override
    public int updateComment(AQnaCommentVO vo) throws Exception {
        return commentDao.updateComment(vo);
    }

    @Override
    public int deleteComment(int commentId) throws Exception {
        return commentDao.deleteComment(commentId);
    }

    @Override
    public int countCommentByPost(int postId) throws Exception {
        return commentDao.countCommentByPost(postId);
    }
}
