package kr.happyjob.study.domain.admin.service;

import kr.happyjob.study.domain.admin.dao.AInstEvalDAO;
import kr.happyjob.study.domain.admin.model.AInstEvalVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AInstEvalServiceImpl implements AInstEvalService {

    @Autowired
    private AInstEvalDAO aInstEvalDAO;

    @Override
    public AInstEvalVO getInstEval(String loginID) {
        return aInstEvalDAO.seletInstEval(loginID);
    }

    @Override
    public void saveInstEval(AInstEvalVO aInstEvalVO) {
        AInstEvalVO exist = aInstEvalDAO.seletInstEval(aInstEvalVO.getLoginID());
        if(exist == null){
            aInstEvalDAO.insertInstEval(aInstEvalVO);
        }else {
            aInstEvalDAO.updateInstEval(aInstEvalVO);
        }
    }
}
