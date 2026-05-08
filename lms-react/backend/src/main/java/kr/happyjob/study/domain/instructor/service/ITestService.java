package kr.happyjob.study.domain.instructor.service;

import kr.happyjob.study.domain.instructor.model.ITestCourseListDTO;
import kr.happyjob.study.domain.instructor.model.ITestListDTO;
import kr.happyjob.study.domain.instructor.model.RegTestDTO;
import kr.happyjob.study.domain.instructor.model.TestDetailVO;

import java.util.List;
import java.util.Map;

/**
 * 시험 관리 서비스 인터페이스 (JDK 1.8 기준)
 */
public interface ITestService {

  /**
   * 1. 강사별 시험 목록 조회
   */
  List<ITestListDTO> getTestList(Map<String, Object> paramMap) throws Exception;

  /**
   * 2. 시험 목록 총 개수 (페이징용)
   */
  int getTestTotalCount(Map<String, Object> paramMap) throws Exception;

  /**
   * 3. 특정 학생의 시험 점수 계산
   */
  Integer computeScore(String studentId, int courseId, int period) throws Exception;

  /**
   * 4. 강사 담당 강의 목록 조회
   */
  List<ITestCourseListDTO> getCourseList(String loginId) throws Exception;

  /**
   * 5. 시험 등록 전 검증 (권한 및 강의 존재 여부)
   */
  void validateExamRegister(RegTestDTO req, String loginId) throws Exception;

  /**
   * 6. 시험 및 문항 등록 처리
   */
  void registerExam(RegTestDTO req) throws Exception;

  /**
   * 7. 수강생별 시험 상세 결과 조회 (채점 상세 내역)
   */
  List<TestDetailVO> getTestResult(int courseId, int period, String studentId) throws Exception;

  /**
   * 8. 특정 시험의 학생별 제출 현황 조회 (목록)
   * @param courseId 강의ID
   * @param period 차시
   * @return 학생 아이디, 이름, 획득점수, 제출여부 등을 포함한 Map 리스트
   */
  List<Map<String, Object>> getStudentSubmissionList(int courseId, int period) throws Exception;

    /**
     * 강사가 출제 문제 목록 조회
     */
    List<TestDetailVO> getExamQuestionsOnly(Map<String, Object> paramMap) throws Exception;

    /**
     * 9. 시험 삭제 (문항, 학생 답안, 응시 기록 포함)
     */
    void deleteExam(int courseId, int period, String loginId) throws Exception;
}
