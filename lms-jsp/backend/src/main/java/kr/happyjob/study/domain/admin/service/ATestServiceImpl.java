package kr.happyjob.study.domain.admin.service;

import kr.happyjob.study.domain.admin.dao.ATestDAO;
import kr.happyjob.study.domain.admin.model.ATestDetailVO;
import kr.happyjob.study.domain.admin.model.ATestListVO;
import kr.happyjob.study.domain.admin.model.ATestStatusVO;
import kr.happyjob.study.domain.instructor.dao.ITestDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@Service
@RequiredArgsConstructor
public class ATestServiceImpl  implements ATestService {

    private final Logger logger = Logger.getLogger(String.valueOf(this.getClass()));


    private final ATestDAO testDAO;

    /* 시험 전체 목록 조회 */
    @Override
    public List<ATestListVO> getTestList(Map<String, Object> paramMap) throws Exception{

        return testDAO.getTestList(paramMap);
    }

    /* 페이징 처리 */
    @Override
    public int getTestTotalCount(Map<String, Object> paramMap) throws Exception{
        return testDAO.getTestTotalCount();
    }

    /* 시험 상태 변경 */
    @Override
    public int updateTestStatus(Map<String, Object> paramMap) throws Exception{
        return testDAO.updateTestStatus(paramMap);
    }

    @Override
    public ATestStatusVO checkStatus(Integer courseId, Integer period) throws Exception {
        return testDAO.checkStatus(courseId,period);
    }

    /* 시험문제 상세 불러오기 */
    @Override
    public List<ATestDetailVO> getTestDetail(int courseId, int period) throws Exception {
        Map<String, Object> param = new HashMap<>();
        param.put("courseId", courseId);
        param.put("period", period);
        return testDAO.getTestDetail(param);
    }

    /* 시험문제 수정하기 */
    @Override
    public void updateTestDetail(ATestDetailVO aTestDetailVO) throws Exception {
        testDAO.updateTestDetail(aTestDetailVO);
    }
}
