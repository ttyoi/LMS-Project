package kr.happyjob.study.domain.dashboard.model;

/** 이번 달 시험 과목 모델 */
public class ExamMonthModel {

    private String title;        // 시험 제목 (test_schedule.title)
    private String subject;      // 강의명 (course.title)
    private String examDate;     // 시험 날짜 (test_schedule.date)
    private Long courseId;       // 강의 ID
    private int period;          // 차시

    // Getters and Setters
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getExamDate() {
        return examDate;
    }

    public void setExamDate(String examDate) {
        this.examDate = examDate;
    }

    public Long getCourseId() {
        return courseId;
    }

    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }

    public int getPeriod() {
        return period;
    }

    public void setPeriod(int period) {
        this.period = period;
    }

    @Override
    public String toString() {
        return "ExamMonthModel{" +
                "title='" + title + '\'' +
                ", subject='" + subject + '\'' +
                ", examDate='" + examDate + '\'' +
                ", courseId='" + courseId + '\'' +
                ", period=" + period +
                '}';
    }
}