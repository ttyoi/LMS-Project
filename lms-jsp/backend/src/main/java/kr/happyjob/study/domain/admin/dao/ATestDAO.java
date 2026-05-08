package kr.happyjob.study.domain.admin.dao;


import kr.happyjob.study.domain.admin.model.ATestDetailVO;
import kr.happyjob.study.domain.admin.model.ATestListVO;
import kr.happyjob.study.domain.admin.model.ATestStatusVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ATestDAO {

    /* 시험목록 전체 불러오기 */
    List<ATestListVO> getTestList(Map<String, Object> paramMap) throws Exception;
    /* 시험목록 페이징 관련 */
    int getTestTotalCount();
    /* 시험 상태 업데이트 */
    int updateTestStatus(Map<String, Object> paramMap) throws Exception;
    /* 시험 상태 체크 */
    ATestStatusVO checkStatus(
            @Param("courseId") Integer courseId,
            @Param("period") Integer period
    ) throws Exception;
    /* 시험문제 상세 불러오기 */
    List<ATestDetailVO> getTestDetail(Map<String, Object> param);
    /* 시험문제 수정 */
    void updateTestDetail(ATestDetailVO aTestDetailVO);
}
