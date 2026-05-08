package kr.happyjob.study.domain.dashboard.model;

/** 수업 중인 강의실 모델 */
public class ClassroomModel {

    private String roomNumber;   // 강의실 호수 (course_class.class_name: "103", "102" 등)
    private String timeSlot;     // 시간대 (course_time: "12:00 ~ 14:00")
    private String subject;      // 강의명 (course.title: "vuejs", "react" 등)
    private String startDate;    // 시작일 (course.start_date)
    private String endDate;      // 종료일 (course.end_date)
    private Long courseId;       // 강의 ID
    private String courseName;   // 강의명 (course.title)

    // Getters and Setters
    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public String getTimeSlot() {
        return timeSlot;
    }

    public void setTimeSlot(String timeSlot) {
        this.timeSlot = timeSlot;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public Long getCourseId() {
        return courseId;
    }

    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    @Override
    public String toString() {
        return "ClassroomModel{" +
                "roomNumber='" + roomNumber + '\'' +
                ", timeSlot='" + timeSlot + '\'' +
                ", subject='" + subject + '\'' +
                ", startDate='" + startDate + '\'' +
                ", endDate='" + endDate + '\'' +
                ", courseId=" + courseId +
                ", courseName='" + courseName + '\'' +
                '}';
    }
}