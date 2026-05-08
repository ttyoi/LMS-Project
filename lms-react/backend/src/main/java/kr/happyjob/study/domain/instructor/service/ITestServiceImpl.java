package kr.happyjob.study.domain.instructor.service;

import kr.happyjob.study.domain.instructor.dao.ITestDAO;
import kr.happyjob.study.domain.instructor.model.ITestCourseListDTO;
import kr.happyjob.study.domain.instructor.model.ITestListDTO;
import kr.happyjob.study.domain.instructor.model.RegTestDTO;
import kr.happyjob.study.domain.instructor.model.TestDetailVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import org.springframework.beans.factory.annotation.Autowired;

@Service
@RequiredArgsConstructor
public class ITestServiceImpl implements ITestService {

  private final Logger logger = Logger.getLogger(String.valueOf(this.getClass()));
  private final ITestDAO testDAO;

    @Autowired
    private ITestDAO testDao;

  /**
   * 시험 등록 및 수정
   * 트랜잭션을 통해 마스터 정보와 문항 정보를 일괄 처리합니다.
   */
  @Override
  @Transactional(rollbackFor = Exception.class)
  public void registerExam(RegTestDTO req) throws Exception {
    Map<String, Object> param = new HashMap<>();
    param.put("courseId", req.getCourseId());
    param.put("period", req.getPeriod());

    // 1. 기존 데이터 삭제 (재등록/수정 대응)
    testDAO.deleteTestDetails(param);
    testDAO.deleteTestSchedule(param);

    // 2. 시험 마스터 정보 등록
    testDAO.insertTestSchedule(req);

    // 3. 문항 상세 정보 등록 (단건 루프)
    if (req.getQuestions() != null) {
      for (TestDetailVO q : req.getQuestions()) {
        q.setCourseId(req.getCourseId());
        q.setPeriod(req.getPeriod());
        testDAO.insertTestDetail(q);
      }
    }
  }

  /**
   * 시험 목록 조회
   */
  @Override
  public List<ITestListDTO> getTestList(Map<String, Object> paramMap) throws Exception {
    List<ITestListDTO> list = testDAO.getTestList(paramMap);
    String loginId = (String) paramMap.get("loginId");

    for (ITestListDTO dto : list) {
      dto.setLoginId(loginId);

      if (dto.getDate() == null) {
        dto.setScore(null);
        continue;
      }

      Map<String, Object> scoreMap = new HashMap<>();
      scoreMap.put("studentId", dto.getStudentId());
      scoreMap.put("courseId", dto.getCourseId());
      scoreMap.put("period", dto.getPeriod());

      Integer score = testDAO.computeScore(scoreMap);
      dto.setScore(score);
    }
    return list;
  }

  @Override
  public int getTestTotalCount(Map<String, Object> paramMap) throws Exception {
    return testDAO.getTestTotalCount(paramMap);
  }

  /**
   * 특정 학생의 시험 점수 계산
   */
  @Override
  public Integer computeScore(String studentId, int courseId, int period) throws Exception {
    Map<String, Object> param = new HashMap<>();
    param.put("studentId", studentId);
    param.put("courseId", courseId);
    param.put("period", period);
    return testDAO.computeScore(param);
  }

  /**
   * 강사의 과정 목록 조회
   */
  @Override
  public List<ITestCourseListDTO> getCourseList(String loginId) throws Exception {
    return testDAO.getCourseList(loginId);
  }

  /**
   * 학생의 시험 상세 결과(채점표) 조회
   */
  @Override
  public List<TestDetailVO> getTestResult(int courseId, int period, String studentId) throws Exception {
    Map<String, Object> param = new HashMap<>();
    param.put("courseId", courseId);
    param.put("period", period);
    param.put("studentId", studentId);
    return testDAO.getTestResult(param);
  }

  /**
   * 등록 전 검증 로직
   */
  @Override
  public void validateExamRegister(RegTestDTO req, String loginId) throws Exception {
    if (req.getCourseId() == null) throw new IllegalArgumentException("강의 코드가 없습니다.");

    if (testDAO.existsCourse(req.getCourseId()) == 0) {
      throw new IllegalArgumentException("등록되지 않은 강의코드입니다!");
    }

    Map<String, Object> paramMap = new HashMap<>();
    paramMap.put("loginId", loginId);
    paramMap.put("courseId", req.getCourseId());

    if (testDAO.hasInstructorAuth(paramMap) == 0) {
      throw new IllegalStateException("해당 강의의 담당교수만 문제등록이 가능합니다!");
    }

    Map<String, Object> dupParam = new HashMap<>();
    dupParam.put("courseId", req.getCourseId());
    dupParam.put("title", req.getTitle());
    dupParam.put("period", req.getPeriod());
    if (testDAO.existsTestSchedule(dupParam) > 0) {
      throw new IllegalStateException("이미 존재하는 시험입니다: " + req.getTitle() + " (" + req.getPeriod() + "차시)");
    }
  }

  /**
   * [수정 완료] 학생 제출 현황 목록 조회
   * 기존 Collections.emptyList()를 삭제하고 DAO와 연결했습니다.
   */
  @Override
  public List<Map<String, Object>> getStudentSubmissionList(int courseId, int period) {
    Map<String, Object> paramMap = new HashMap<>();
    paramMap.put("courseId", courseId);
    paramMap.put("period", period);

    // DAO를 호출하여 실제 DB 데이터를 가져옵니다.
    return testDAO.getStudentSubmissionList(paramMap);
  }

  /*강사가 출제 문제 목록 조회*/
  @Override
  public List<TestDetailVO> getExamQuestionsOnly(Map<String, Object> paramMap) throws Exception {
      return testDao.getExamQuestionsOnly(paramMap);
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public void deleteExam(int courseId, int period, String loginId) throws Exception {
      Map<String, Object> authParam = new HashMap<>();
      authParam.put("loginId", loginId);
      authParam.put("courseId", courseId);
      if (testDAO.hasInstructorAuth(authParam) == 0) {
          throw new IllegalStateException("해당 강의의 담당교수만 삭제 가능합니다.");
      }

      Map<String, Object> param = new HashMap<>();
      param.put("courseId", courseId);
      param.put("period", period);

      testDAO.deleteStudentAnswers(param);
      testDAO.deleteStudentSchedule(param);
      testDAO.deleteTestDetails(param);
      testDAO.deleteTestSchedule(param);
  }
}
