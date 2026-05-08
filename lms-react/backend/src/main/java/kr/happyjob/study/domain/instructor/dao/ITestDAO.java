package kr.happyjob.study.domain.instructor.dao;

import kr.happyjob.study.domain.instructor.model.ITestCourseListDTO;
import kr.happyjob.study.domain.instructor.model.ITestListDTO;
import kr.happyjob.study.domain.instructor.model.RegTestDTO;
import kr.happyjob.study.domain.instructor.model.TestDetailVO;
import org.apache.ibatis.annotations.Param;


import java.util.List;
import java.util.Map;

public interface ITestDAO {
    /* 강의코드/시험제목/시험차시를 저장 */
    int insertTestSchedule(RegTestDTO req) throws Exception;
    /* 시험문제 상세정보를 저장 */
    int registerExam(@Param("list") List<TestDetailVO> questions)throws Exception;
    /* 강사별 시험목록 불러오기 */
    List<ITestListDTO> getTestList(Map<String, Object> paramMap) throws Exception;
    /* 시험목록 페이징 처리 관련 */
    int getTestTotalCount(Map<String, Object> paramMap) throws Exception;
    /* 수강생 시험문제 점수계산 */
    Integer computeScore(Map<String, Object> paramMap) throws Exception;
    /* 과정 목록 불러오기 */
    List<ITestCourseListDTO> getCourseList(String loginId) throws Exception;
    /* 수강생별 시험결과 불러오기 */
    List<TestDetailVO> getTestResult(Map<String, Object> paramMap) throws Exception;
    /* 강의코드 존재 여부 */
    int existsCourse(int courseId) throws Exception;
    /* 강사 권한 확인 (담당교수인지 아닌지) */
    int hasInstructorAuth(Map<String, Object> paramMap) throws Exception;
    /* 시험정보 중복여부 (강의코드,차시) */
    int existsTestSchedule(Map<String, Object> paramMap) throws Exception;
  void deleteTestDetails(Map<String, Object> param);
  void deleteTestSchedule(Map<String, Object> param);
  void deleteStudentAnswers(Map<String, Object> param);
  void deleteStudentSchedule(Map<String, Object> param);

  void insertTestDetail(TestDetailVO q);

  List<Map<String, Object>> getStudentSubmissionList(Map<String, Object> paramMap);

  // 강사 출제 문제 목록 조회
  List<TestDetailVO> getExamQuestionsOnly(Map<String, Object> paramMap) throws Exception;

  // 기간 만료된 시험 닫힘 처리
  int updateExpiredExams();
}
