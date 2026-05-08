package kr.happyjob.study.domain.instructor.model;

public class ICourseTimeVO {
    private int time_code;
    private String start_time;
    private String end_time;

    public int getTime_code() {
        return time_code;
    }

    public void setTime_code(int time_code) {
        this.time_code = time_code;
    }

    public String getStart_time() {
        return start_time;
    }

    public void setStart_time(String start_time) {
        this.start_time = start_time;
    }

    public String getEnd_time() {
        return end_time;
    }

    public void setEnd_time(String end_time) {
        this.end_time = end_time;
    }
}
