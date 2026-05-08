package kr.happyjob.study.domain.student.service;

import kr.happyjob.study.domain.student.dao.STestDAO;
import kr.happyjob.study.domain.student.model.*;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.time.LocalDate;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
@RequiredArgsConstructor
public class STestServiceImpl  implements STestService {


    private STestListDTO sTestListDTO;


   private final STestDAO sTestDAO;


    /* 수강생 시험목록 불러오기 */
    @Override
    public List<STestListDTO> getTestList(Map<String, Object> paramMap) throws Exception {

        List<STestListDTO> list = sTestDAO.getTestList(paramMap);
        String loginId = (String) paramMap.get("loginId");

        for (STestListDTO dto : list) {

            // 응시 안한 시험
            if (dto.getDate() == null) {
                // 응시 종료일이 지났으면 자동 0점 처리
                if (dto.getEndDate() != null
                        && dto.getEndDate().toLocalDate().isBefore(LocalDate.now())) {
                    dto.setScore(0);
                } else {
                    dto.setScore(null);
                }
                continue;
            }

            // 응시한 시험 → 점수 계산
            Map<String, Object> scoreMap = new HashMap<>();
            scoreMap.put("loginId", loginId);
            scoreMap.put("courseId", dto.getCourseId());
            scoreMap.put("period", dto.getPeriod());

            Integer score = sTestDAO.computeScore(scoreMap);
            dto.setScore(score);
        }

        return list;
    }

    /* 시험목록 페이징 처리 */
    @Override
    public int getTestTotalCount(Map<String, Object> paramMap) throws Exception {
        return sTestDAO.getTestTotalCount(paramMap);
    }

    /* 수강생 시험점수 계산 */
    @Override
    public  Integer computeScore(String loginId, int courseId, int period) throws Exception {
        Map<String, Object> param = new HashMap<>();
        param.put("loginId", loginId);
        param.put("courseId", courseId);
        param.put("period", period);
        return sTestDAO.computeScore(param);
    }
    
    /* 수강생 응시정보 불러오기 */
    @Override
    public List<TestAnswerVO> getStudentAnswer(String loginId, int courseId, int period) throws Exception {
        Map<String, Object> param = new HashMap<>();
        param.put("loginId", loginId);
        param.put("courseId", courseId);
        param.put("period", period);
        return sTestDAO.getStudentAnswer(param);
    }
    
    /* 과정목록 불러오기 */
    @Override
    public List<STestCourseListDTO> getCourseList(String loginId) throws Exception {
        return sTestDAO.getCourseList(loginId);
    }

    /* 시험응시 가능여부 체크 */
    @Override
    public boolean checkExamAvailable(int courseId, int period) throws Exception {
        Map<String, Object> param = new HashMap<>();
        param.put("courseId", courseId);
        param.put("period", period);
        Integer result = sTestDAO.checkExamAvailable(param);
        return result != null && result == 1; // 응시불가라면 0이 반환되어 false, 응시가능이면 1이 반환되어 true가 됨
    }
    
    /* 시험문제 상세 불러오기 */
    @Override
    public List<STestDetailDTO> getTestDetail(Map<String, Object> paramMap) throws Exception{
        return sTestDAO.getTestDetail(paramMap);

    }
    /* 수강생 시험답변 제출하기 */
    @Override
    public void submitTestAnswer(TestAnswerVO paramMap) throws Exception{

        String loginId =  paramMap.getLoginId();
        int courseId = paramMap.getCourseId();
        int period =  paramMap.getPeriod();


        // 재응시의 경우는 무시.
        for (SAnswerDTO ans : paramMap.getAnswers()) {
            sTestDAO.submitTestAnswer(
                    loginId,
                    courseId,
                    period,
                    ans.getQuestionNo(),
                    ans.getStudentAnswer()
            );

        }
        // 등록 날짜 저장
        sTestDAO.submitDate(loginId,courseId,period);
    }

    @Override
    public List<STestResultDTO> getTestResult(String loginId, int courseId, int period) throws Exception {
        Map<String, Object> param = new HashMap<>();
        param.put("loginId", loginId);
        param.put("courseId", courseId);
        param.put("period", period);

        return sTestDAO.getTestResult(param);
    }


}
