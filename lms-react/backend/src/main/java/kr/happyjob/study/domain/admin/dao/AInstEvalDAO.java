package kr.happyjob.study.domain.admin.dao;

import kr.happyjob.study.domain.admin.model.AInstEvalVO;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

public interface AInstEvalDAO {

    // 1명 조회
    AInstEvalVO seletInstEval(String loginID);

    // 새로 생성
    int insertInstEval(AInstEvalVO aInstEvalVO);

    // 수정
    int updateInstEval(AInstEvalVO aInstEvalVO);
}
