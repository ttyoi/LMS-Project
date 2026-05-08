package kr.happyjob.study.domain.admin.dao;

import kr.happyjob.study.domain.admin.model.ADashboard;

import java.util.List;

public interface ADashboardDao {

    // 오늘 시험 과목
    List<ADashboard> getMonthlyExams();

    // 오늘 강의실
    List<ADashboard> getTodayClasses();

    // 사용자 통계
    int getTotalUsers();
    int getStudentCount();
    int getTeacherCount();
    int getNewUsers();

    // 커뮤니티 최근 글
    List<ADashboard> getRecentNotices();
    List<ADashboard> getRecentSurveys();
    List<ADashboard> getRecentQnaPosts();

}
