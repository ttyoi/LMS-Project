package kr.happyjob.study.domain.student.service;

import kr.happyjob.study.domain.student.model.*;

import java.util.List;
import java.util.Map;

public interface SCourseService {

    // 셀렉트박스 조회
    public List<SSearchKeyDTO> loadSearchKeys(String group_code);
    public List<SCourseListDTO> loadAllCourses(SSearchParamsDTO searchParamsDTO);

    /**
     * 강의 상세정보 조회 및 수강신청 가능 여부 검사
     *
     * @param course_id
     * @param loginID
     * @return
     */
    public SCourseDetailDTO courseDetail(int course_id, String loginID);

    /**
     * 수강신청 여부 판단 기능
     * @param targetDTO 대상 강의
     * @param baseDTOList 수강중인 강의목록
     * @return String 활성화되는 버튼의 id
     */
    String checkEnrollAvailable(SEnrollCheckDTO targetDTO, List<SEnrollCheckDTO> baseDTOList, int stuCnt, int limit);

    // 수강목록 구역
    public List<SMyCourseListDTO> myCourseList(SSearchParamsDTO searchParamsDTO);

    public SMyCosDetailDTO myCourseDetail(String loginID, int courseId);

    public String postCourse(String apply_status, Long course_id, String loginID);

    Map<String, Object> courseActionForReact(Long courseId, Map<String, Object> data);

    int courseTotalCnt(SSearchParamsDTO searchParamsDTO);

    int myCourseTotalcount(SSearchParamsDTO searchParamsDTO);

    List<Map<String, Object>> myCourseAttCalendar(Map<String, Object> params);
}
