package kr.happyjob.study.domain.admin.service;

import kr.happyjob.study.domain.admin.model.ATestDetailVO;
import kr.happyjob.study.domain.admin.model.ATestListVO;
import kr.happyjob.study.domain.admin.model.ATestStatusVO;
import kr.happyjob.study.domain.student.model.STestListDTO;

import java.util.List;
import java.util.Map;

public interface ATestService {

    /* 전체 시험목록 불러오기 */
    public List<ATestListVO> getTestList(Map<String, Object> paramMap) throws Exception;
    /* 시험목록 페이징 처리 */
    public int getTestTotalCount(Map<String, Object> paramMap) throws Exception;
    /* 시험 상태 변경 */
    public int updateTestStatus(Map<String, Object> paramMap) throws Exception;
    /* 시험 상태 체크 */
    ATestStatusVO checkStatus(Integer courseId, Integer period) throws Exception;
    /* 시험문제 상세 불러오기 */
    public List<ATestDetailVO> getTestDetail(int courseId, int period) throws Exception;
    /* 시험문제 수정하기 */
    public void updateTestDetail(ATestDetailVO aTestDetailVO) throws Exception;

}
