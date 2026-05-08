package kr.happyjob.study.domain.student.service;

import kr.happyjob.study.domain.student.dao.SCourseDAO;
import kr.happyjob.study.domain.student.model.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;

@Service
public class SCourseServiceImpl implements SCourseService {

  @Autowired
  private SCourseDAO scourseDao;

  private static final Logger logger = LoggerFactory.getLogger(SCourseServiceImpl.class);

  @Override
  public SCourseDetailDTO courseDetail(int course_id, String loginID) {
    SCourseDetailDTO sCourseDetailDTO = scourseDao.courseDetail(course_id);
    if (sCourseDetailDTO == null) return null;

    LocalDate today = LocalDate.now();
    // 획득한 java.util.Date를 LocalDate로 변환
    LocalDate courseStartDate = toLocalDate(sCourseDetailDTO.getStart_date());

    boolean isCapacityFull = sCourseDetailDTO.getStu_num() >= sCourseDetailDTO.getPeople_limit();
    boolean isEnrollDeadlinePassed = courseStartDate != null && courseStartDate.isBefore(today);
    boolean isAlreadyEnrolled = false;

    List<SEnrollCheckDTO> baseDTOList = null;
    if (loginID != null && !loginID.trim().isEmpty()) {
      baseDTOList = scourseDao.loadbaseDTO(loginID);
      isAlreadyEnrolled = baseDTOList.stream()
        .anyMatch(dto -> dto.getCourse_id().equals(sCourseDetailDTO.getCourse_id()));
    } else {
      baseDTOList = new ArrayList<>();
    }

    sCourseDetailDTO.setCapacityFull(isCapacityFull);
    sCourseDetailDTO.setEnrollDeadlinePassed(isEnrollDeadlinePassed);

    String enrollableStatus = "available";
    if (isAlreadyEnrolled) {
      enrollableStatus = "cancel";
    } else if (isCapacityFull || isEnrollDeadlinePassed) {
      enrollableStatus = "conflict";
    } else {
      for (SEnrollCheckDTO base : baseDTOList) {
        if (base.getCourse_id().equals(sCourseDetailDTO.getCourse_id())) continue;

        LocalDate baseStart = toLocalDate(base.getStart_date());
        LocalDate baseEnd = toLocalDate(base.getEnd_date());

        // null 체크 추가로 안전성 확보
        if (courseStartDate != null && baseEnd != null && baseStart != null) {
          boolean isDateOverlap = courseStartDate.isBefore(baseEnd) && toLocalDate(sCourseDetailDTO.getEnd_date()).isAfter(baseStart);
          boolean isTimeOverlap = sCourseDetailDTO.getTime_code() == base.getTime_code();

          if (isDateOverlap && isTimeOverlap) {
            enrollableStatus = "conflict";
            break;
          }
        }
      }
    }
    sCourseDetailDTO.setEnrollable(enrollableStatus);
    sCourseDetailDTO.setApply_status(mapStatus(enrollableStatus, isCapacityFull, isEnrollDeadlinePassed));

    return sCourseDetailDTO;
  }

  @Override
  public List<SCourseListDTO> loadAllCourses(SSearchParamsDTO searchParamsDTO) {
    List<SCourseListDTO> list = scourseDao.loadAllCourses(searchParamsDTO);
    String loginID = searchParamsDTO.getLoginID();
    List<SEnrollCheckDTO> baseDTOList = (loginID != null && !loginID.trim().isEmpty()) ? scourseDao.loadbaseDTO(loginID) : new ArrayList<>();
    LocalDate today = LocalDate.now();

    for (SCourseListDTO item : list) {
      LocalDate courseStartDate = toLocalDate(item.getStart_date());
      boolean isCapacityFull = item.getStu_num() >= item.getPeople_limit();
      boolean isEnrollDeadlinePassed = courseStartDate != null && courseStartDate.isBefore(today);
      boolean isAlreadyEnrolled = baseDTOList.stream().anyMatch(dto -> dto.getCourse_id().equals(item.getCourse_id()));

      item.setCapacityFull(isCapacityFull);
      item.setEnrollDeadlinePassed(isEnrollDeadlinePassed);

      String enrollableStatus = isAlreadyEnrolled ? "cancel" : (isCapacityFull || isEnrollDeadlinePassed ? "conflict" : "available");

      if ("available".equals(enrollableStatus)) {
        for (SEnrollCheckDTO base : baseDTOList) {
          if (base.getCourse_id().equals(item.getCourse_id())) continue;

          LocalDate bStart = toLocalDate(base.getStart_date());
          LocalDate bEnd = toLocalDate(base.getEnd_date());
          LocalDate iEnd = toLocalDate(item.getEnd_date());

          if (courseStartDate != null && bEnd != null && iEnd != null && bStart != null) {
            boolean isDateOverlap = courseStartDate.isBefore(bEnd) && iEnd.isAfter(bStart);
            if (isDateOverlap && item.getTime_code() == base.getTime_code()) {
              enrollableStatus = "conflict";
              break;
            }
          }
        }
      }
      item.setApply_status(mapStatus(enrollableStatus, isCapacityFull, isEnrollDeadlinePassed));
    }
    return list;
  }

  private String mapStatus(String enrollableStatus, boolean isCapacityFull, boolean isEnrollDeadlinePassed) {
    if ("cancel".equals(enrollableStatus)) return "신청 완료";
    if ("conflict".equals(enrollableStatus)) {
      if (isCapacityFull) return "정원 초과";
      if (isEnrollDeadlinePassed) return "신청 마감";
      return "일정 충돌";
    }
    return "신청 가능";
  }

  @Override
  public String checkEnrollAvailable(SEnrollCheckDTO targetDTO, List<SEnrollCheckDTO> baseDTOList, int stuCnt, int limit) {
    LocalDate start = toLocalDate(targetDTO.getStart_date());
    LocalDate today = LocalDate.now();
    if (baseDTOList.stream().anyMatch(dto -> dto.getCourse_id().equals(targetDTO.getCourse_id()))) return "cancel";
    if (stuCnt >= limit || (start != null && start.isBefore(today))) return "conflict";

    for (SEnrollCheckDTO base : baseDTOList) {
      if (base.getCourse_id().equals(targetDTO.getCourse_id())) continue;

      LocalDate tEnd = toLocalDate(targetDTO.getEnd_date());
      LocalDate bStart = toLocalDate(base.getStart_date());
      LocalDate bEnd = toLocalDate(base.getEnd_date());

      if (start != null && bEnd != null && tEnd != null && bStart != null) {
        boolean isDateOverlap = start.isBefore(bEnd) && tEnd.isAfter(bStart);
        if (isDateOverlap && targetDTO.getTime_code() == base.getTime_code()) return "conflict";
      }
    }
    return "available";
  }

  @Override
  public String postCourse(String apply_status, Long course_id, String loginID) {
    if ("apply".equals(apply_status)) {
      if (scourseDao.existsAppliedCourse(course_id, loginID) > 0) {
        return "이미 신청한 강의입니다.";
      }

      if (scourseDao.existsCompletedCourse(course_id, loginID) > 0) {
        return "이미 수강완료한 강의입니다.";
      }

      scourseDao.applyCourse(course_id, loginID);
      return "수강신청";
    }

    if ("delete".equals(apply_status)) {
      scourseDao.deleteCourse(course_id, loginID);
      return "수강취소";
    }

    return "처리 실패";
  }

  @Override
  public Map<String, Object> courseActionForReact(Long courseId, Map<String, Object> data) {
    Map<String, Object> resultMap = new HashMap<>();
    for (String key : data.keySet()) {
      Object value = data.get(key);
      if (value instanceof java.time.LocalDate) {
        data.put(key, java.sql.Date.valueOf((java.time.LocalDate) value));
      }
    }
    int result = scourseDao.updateCourseAction(data);
    resultMap.put("success", result > 0);
    return resultMap;
  }

  @Override
  public int courseTotalCnt(SSearchParamsDTO searchParamsDTO) {
    return scourseDao.courseTotalCnt(searchParamsDTO);
  }

  @Override
  public int myCourseTotalcount(SSearchParamsDTO searchParamsDTO) {
    return scourseDao.myCourseTotalCnt(searchParamsDTO);
  }

  @Override
  public List<SMyCourseListDTO> myCourseList(SSearchParamsDTO searchParamsDTO) {
    return scourseDao.myCourseList(searchParamsDTO);
  }

  @Override
  public SMyCosDetailDTO myCourseDetail(String loginID, int courseId) {
    SMyCosDetailDTO detail = scourseDao.myCourseDetail(loginID, courseId);
    List<SEnrollCheckDTO> baseList = scourseDao.loadbaseDTO(loginID);
    SEnrollCheckDTO target = new SEnrollCheckDTO();
    target.setCourse_id(detail.getCourse_id());
    target.setStart_date(detail.getStart_date());
    target.setEnd_date(detail.getEnd_date());
    target.setTime_code(detail.getTime_code());
    detail.setEnrollable(checkEnrollAvailable(target, baseList, detail.getStu_num(), detail.getPeople_limit()));
    return detail;
  }

  @Override
  public List<SSearchKeyDTO> loadSearchKeys(String group_code) {
    return scourseDao.loadSearchKeys(group_code);
  }

  @Override
  public List<Map<String, Object>> myCourseAttCalendar(Map<String, Object> params) {
    return scourseDao.myCourseAttCalendar(params);
  }

  /**
   * [최종 해결 메서드]
   * 입력받는 타입을 java.lang.Object로 설정하여 어떤 타입이 들어와도 안전하게 처리합니다.
   */
  public LocalDate toLocalDate(Object dateObj) {
    if (dateObj == null) return null;

    // 1. 이미 LocalDate인 경우
    if (dateObj instanceof LocalDate) {
      return (LocalDate) dateObj;
    }

    // 2. java.sql.Date인 경우 (MyBatis에서 자주 넘어옴)
    if (dateObj instanceof java.sql.Date) {
      return ((java.sql.Date) dateObj).toLocalDate();
    }

    // 3. java.util.Date인 경우
    if (dateObj instanceof java.util.Date) {
      return ((java.util.Date) dateObj).toInstant()
        .atZone(ZoneId.systemDefault())
        .toLocalDate();
    }

    return null;
  }
}
