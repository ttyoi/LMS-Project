package kr.happyjob.study.common.scheduler;

import kr.happyjob.study.domain.instructor.dao.ITestDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ExamStatusScheduler {

    private final ITestDAO iTestDAO;

    // 매일 자정에 기간 만료된 시험을 닫힘(status=0)으로 자동 업데이트
    @Scheduled(cron = "0 0 0 * * ?")
    public void updateExpiredExamStatus() {
        int updated = iTestDAO.updateExpiredExams();
        System.out.println("[ExamStatusScheduler] 기간 만료 시험 닫힘 처리: " + updated + "건");
    }
}
