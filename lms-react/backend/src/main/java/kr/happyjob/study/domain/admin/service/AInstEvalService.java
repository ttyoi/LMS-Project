package kr.happyjob.study.domain.admin.service;

import kr.happyjob.study.domain.admin.model.AInstEvalVO;

public interface AInstEvalService {
    AInstEvalVO getInstEval(String loginID);
    void saveInstEval(AInstEvalVO aInstEvalVO);
}
