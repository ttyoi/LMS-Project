package kr.happyjob.study.domain.student.service;

import kr.happyjob.study.domain.student.model.*;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

public interface STestService {
    /* 수강생 시험목록 불러오기 */
    public List<STestListDTO> getTestList(Map<String, Object> paramMap) throws Exception;
    /* 시험목록 페이징 처리 */
    public int getTestTotalCount(Map<String, Object> paramMap) throws Exception;
    /* 수강생 점수 불러오기 */
    public Integer computeScore(String loginId, int courseId, int period) throws Exception;
    /* 수강생 답안 정보 불러하기 */
    public List<TestAnswerVO> getStudentAnswer(String loginId, int courseId, int period) throws Exception;
    /* 과정목록 불러오기 */
    public List<STestCourseListDTO> getCourseList(String loginId) throws Exception;
    /* 시험응시 가능여부 체크 */
    public boolean checkExamAvailable(int courseId, int period)throws Exception;
    /* 시험문제 상세 불러오기 */
    public List<STestDetailDTO> getTestDetail(Map<String, Object> paramMap)throws Exception;
    /* 시험문제 제출하기 */
    public void submitTestAnswer(TestAnswerVO answers) throws Exception;
    /* 시험결과 상세 불러오기 */
    public List<STestResultDTO> getTestResult(String loginId, int courseId, int period) throws Exception;
}
