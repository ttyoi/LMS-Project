package kr.happyjob.study.domain.student.dao;

import kr.happyjob.study.domain.student.model.*;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;


public interface STestDAO {
    /* 수강생 시험목록 조회 */
    List<STestListDTO> getTestList(Map<String, Object> paramMap) throws Exception;
    
    /* 시험목록 페이징 처리 관련 */
    int getTestTotalCount(Map<String, Object> paramMap) throws Exception;
    
    /* 수강생 시험문제 점수계산 */
    Integer computeScore(Map<String, Object> paramMap) throws Exception;

    /* 수강생 답안 가져오기 */
    List<TestAnswerVO> getStudentAnswer(Map<String, Object> paramMap) throws Exception;
    
    /* 과정목록 불러오기 */
    List<STestCourseListDTO> getCourseList(String loginId) throws Exception;
    
    /* 시험응시 가능여부 체크 */
     Integer checkExamAvailable(Map<String, Object> paramMap) throws Exception;
     
     /* 시험문제 상세 불러오기 */
    List<STestDetailDTO> getTestDetail(Map<String, Object> paramMap) throws Exception;

    /* 수강생 답안 저장 */
    int submitTestAnswer(
            @Param("loginId") String loginId,
            @Param("courseId") int courseId,
            @Param("period") int period,
            @Param("questionNo") int questionNo,
            @Param("studentAnswer") int studentAnswer
    )throws Exception;

    /* 응시날짜 저장*/
    void submitDate(
            @Param("loginId") String loginId,
            @Param("courseId") int courseId,
            @Param("period") int period
    ) throws Exception;

    /* 수강생 시험결과 상세조회 */
    List<STestResultDTO> getTestResult(Map<String, Object> paramMap) throws Exception;
}
