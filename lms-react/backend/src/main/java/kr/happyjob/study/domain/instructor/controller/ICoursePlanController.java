package kr.happyjob.study.domain.instructor.controller;

import kr.happyjob.study.domain.admin.model.AUserVO;
import kr.happyjob.study.domain.instructor.model.ICourseClassVO;
import kr.happyjob.study.domain.instructor.model.ICourseTimeVO;
import kr.happyjob.study.domain.instructor.model.ICourseVO;
import kr.happyjob.study.domain.instructor.service.ICoursePlanService;
import kr.happyjob.study.domain.instructor.service.ICourseService;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/inst/")
public class ICoursePlanController {
    // Set logger
    private final Logger logger = LogManager.getLogger(this.getClass());

    // Get class name for logger
    private final String className = this.getClass().toString();
    private String path = "instructor/icourse/courplan";

    @Autowired
    ICoursePlanService coursePlanService;
    @Autowired
    ICourseService courseService;

    private ResponseEntity<Map<String, Object>> validateCoursePlan(Map<String, Object> paramMap, String loginId) {
      Map<String, Object> resultMap = new HashMap<>();

      // 1. 세션 체크
      if (loginId == null) {
        resultMap.put("result", "FAIL");
        resultMap.put("resultMsg", "세션이 만료되었습니다.");
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(resultMap);
      }

      // 2. 날짜 논리 체크 (시작일 < 종료일)
      try {
        String startDateStr = (String) paramMap.get("start_date");
        String endDateStr = (String) paramMap.get("end_date");

        if (startDateStr != null && endDateStr != null) {
          LocalDate startDate = LocalDate.parse(startDateStr);
          LocalDate endDate = LocalDate.parse(endDateStr);
          LocalDate today = LocalDate.now();

          if (startDate.isBefore(today)) {
            resultMap.put("result", "FAIL");
            resultMap.put("resultMsg", "과거 날짜로 강의를 생성/수정할 수 없습니다.");
            return ResponseEntity.badRequest().body(resultMap);
          }
          if (startDate.isAfter(endDate)) {
            resultMap.put("result", "FAIL");
            resultMap.put("resultMsg", "종료일은 시작일보다 빠를 수 없습니다.");
            return ResponseEntity.badRequest().body(resultMap);
          }
        }
      } catch (Exception e) {
        resultMap.put("result", "FAIL");
        resultMap.put("resultMsg", "날짜 형식이 올바르지 않습니다.");
        return ResponseEntity.badRequest().body(resultMap);
      }

      // 3. 중복 체크 (강사/강의실/시간)
      paramMap.put("professor", loginId);
      paramMap.put("loginID", loginId);

      if (coursePlanService.checkOverlap(paramMap) > 0) {
        resultMap.put("result", "FAIL");
        resultMap.put("resultMsg", "강의 기간/시간/강사/강의실이 이미 사용 중입니다.");
        return ResponseEntity.status(HttpStatus.CONFLICT).body(resultMap);
      }

      return null; // 모든 검증 통과 시 null 반환
    }

    @GetMapping("course-plan")
    public String coursePlan(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".coursePlan");
        logger.info("   - paramMap : " + paramMap);
        logger.info("+ End " + className + ".coursePlan");
        return path+"/coursePlanView";
    }
    @PostMapping("getCoursePlanList")
    @ResponseBody
    public String coursePlanList(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".getCoursePlanList");
        logger.info("   - paramMap : " + paramMap);

        logger.info("+ End " + className + ".getCoursePlanList");
        return path+"/coursePlanList";
    }
//    @PostMapping("regCoursePlan")
//    @ResponseBody
//    public ResponseEntity regCourse(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
//        logger.info("+ Start " + className + ".regCourse");
//        logger.info("   - paramMap : " + paramMap);
//
//        Map<String, Object> resultMap = new HashMap<String, Object>();
//
//        HttpSession session = request.getSession();
//        String loginId = (String) session.getAttribute("loginId");
//
//        // 1. 세션 체크 (로그인 안 된 경우 차단)
//        if (loginId == null) {
//            resultMap.put("result", "FAIL");
//            resultMap.put("resultMsg", "세션이 만료되었습니다. 다시 로그인해주세요.");
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(resultMap);
//        }
//
//        // 2. 강제 고정 (안전하게 덮어쓰기)
//        paramMap.put("professor", loginId);
//        paramMap.put("loginID", loginId);
//
//        // 3. 필수 파라미터 null 체크 (500 에러 방지)
//        // 예: 강의실이나 시간이 선택되지 않고 넘어왔을 때
//        if (paramMap.get("classId") == null || paramMap.get("time_code") == null || paramMap.get("start_date") == null) {
//            resultMap.put("result", "FAIL");
//            resultMap.put("resultMsg", "필수 입력 항목(강의실, 시간, 시작일 등)이 누락되었습니다.");
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(resultMap);
//        }
//
//        if (paramMap.get("sub_prof") != null && "".equals(paramMap.get("sub_prof").toString().trim())) {
//            paramMap.put("sub_prof", null);
//        }
//
//        // 1. 날짜 유효성 체크 추가
//        try {
//            // paramMap에서 시작일 꺼내기 (키값은 실제 데이터에 맞게 'startDate' 등으로 확인 필요)
//            String startDateStr = (String) paramMap.get("start_date");
//            String endDateStr = (String) paramMap.get("end_date");
//
//            if (startDateStr != null && !startDateStr.isEmpty()) {
//                java.time.LocalDate startDate = java.time.LocalDate.parse(startDateStr);
//              java.time.LocalDate endDate = java.time.LocalDate.parse(endDateStr);
//                java.time.LocalDate today = java.time.LocalDate.now();
//
//                // 시작일이 오늘보다 이전(과거)인지 확인
//                if (startDate.isBefore(today)) {
//                    resultMap.put("result", "FAIL");
//                    resultMap.put("resultMsg", "현재 또는 지난 날짜로는 강의를 생성할 수 없습니다.");
//                    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(resultMap);
//                }
//
//              if (startDate.isAfter(endDate)) {
//                resultMap.put("result", "FAIL");
//                resultMap.put("resultMsg", "종료일은 시작일보다 빠를 수 없습니다.");
//                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(resultMap);
//              }
//            }
//        } catch (Exception e) {
//            logger.error("날짜 파싱 오류 : " + e.getMessage());
//            // 날짜 형식이 잘못 넘어왔을 경우에 대한 예외 처리
//        }
//
//
//        // 2. 기존 로직 (중복 체크)
//        int overlap = coursePlanService.checkOverlap(paramMap);
//
//        if (overlap > 0) {
//            resultMap.put("result", "FAIL");
//            resultMap.put("resultMsg", "강의 기간/시간/강사/강의실이 중복됩니다.");
//            return ResponseEntity.status(HttpStatus.CONFLICT).body(resultMap);
//        }
//
//        // 3. 저장 로직
//        coursePlanService.saveCoursePlan(paramMap);
//        resultMap.put("result", "SUCCESS");
//
//        logger.info("overlap count = " + overlap);
//        logger.info("+ End " + className + ".regCourse");
//
//        return ResponseEntity.status(HttpStatus.CREATED).body(resultMap);
//    }

      @PostMapping("regCoursePlan")
      @ResponseBody
      public ResponseEntity<Map<String, Object>> regCourse(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        String loginId = (String) request.getSession().getAttribute("loginId");

        // 필수 파라미터 체크
        if (paramMap.get("classId") == null || paramMap.get("time_code") == null) {
          Map<String, Object> fail = new HashMap<>();
          fail.put("result", "FAIL");
          fail.put("resultMsg", "필수 입력 항목이 누락되었습니다.");
          return ResponseEntity.badRequest().body(fail);
        }

        // 공통 검증 호출 (세션, 날짜, 중복)
        ResponseEntity<Map<String, Object>> validationResponse = validateCoursePlan(paramMap, loginId);
        if (validationResponse != null) return validationResponse;

        coursePlanService.saveCoursePlan(paramMap);

        Map<String, Object> success = new HashMap<>();
        success.put("result", "SUCCESS");
        return ResponseEntity.status(HttpStatus.CREATED).body(success);
      }

    @PostMapping("instlist")
    @ResponseBody
    public Map<String, Object> instList(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".instList");
        logger.info("   - paramMap : " + paramMap);

        List<AUserVO> instlist = coursePlanService.getInstlist();
        logger.info("+ instlist " + instlist);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", "SUCCESS");
        resultMap.put("instlist", instlist);

        logger.info("+ End " + className + ".instList");
        return resultMap;
    }

    @PostMapping("classList")
    @ResponseBody
    public Map<String,Object> classList(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".classList");
        logger.info("   - paramMap : " + paramMap);

        List<ICourseClassVO> classlist = coursePlanService.getClassList();
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", "SUCCESS");
        resultMap.put("classlist", classlist);

        logger.info("+ End " + className + ".classList");
        return resultMap;
    }
    @PostMapping("classTimelist")
    @ResponseBody
    public Map<String,Object> classTimeList(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".classTimeList");
        logger.info("   - paramMap : " + paramMap);

        List<ICourseTimeVO> classTimelist = coursePlanService.getClassTimeList();
        logger.info("   - classTimelist " + classTimelist);
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", "SUCCESS");
        resultMap.put("classTimelist", classTimelist);

        logger.info("+ End " + className + ".classTimeList");
        return resultMap;
    }
    @PostMapping("classPlanList")
    public String classPlanList(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".classPlanList");
        logger.info("   - paramMap : " + paramMap);
        HttpSession session = request.getSession();
        String loginId = session.getAttribute("loginId").toString();
        String userType =  session.getAttribute("userType").toString();
        int currentPage = Integer.parseInt((String)paramMap.get("currentPage"));	// 현재 페이지 번호
        int pageSize = Integer.parseInt((String)paramMap.get("pageSize"));			// 페이지 사이즈
        int pageIndex = (currentPage-1)*pageSize;												// 페이지 시작 row 번호
        logger.info("   - currentPage : " + currentPage);
        logger.info("   - pageSize : " + pageSize);
        logger.info("   - pageIndex : " + pageIndex);
        paramMap.put("pageIndex", pageIndex);
        paramMap.put("pageSize", pageSize);

        paramMap.put("loginID", loginId);
        paramMap.put("userType", userType);
        List<ICourseVO> coursePlanList = coursePlanService.getClassPlanList(paramMap);

        model.addAttribute("coursePlanList", coursePlanList);
        int totalCount = coursePlanService.totalCntCoursePlan(paramMap);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("loginID", loginId);
        model.addAttribute("userType", userType);

        logger.info("+ End " + className + ".classPlanList");
        return path+"/coursePlanList";
    }

    @PostMapping("coursePlanDetailList")
    @ResponseBody
    public Map<String, Object> coursePlanDetailList(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".coursePlanDetailList");
        logger.info("   - paramMap : " + paramMap);
        HttpSession session = request.getSession();
        String loginId = session.getAttribute("loginId").toString();
        String userType =  session.getAttribute("userType").toString();
        paramMap.put("loginID", loginId);
        paramMap.put("userType", userType);

        ICourseVO course =  coursePlanService.getCoursPlanDetail(paramMap);

        logger.info("   - course : " + course);
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("course", course);
        resultMap.put("result", "SUCCESS");
        logger.info("+ End " + className + ".coursePlanDetailList");
        return resultMap;
    }

      @PostMapping("modifyCoursePlan")
      @ResponseBody
      public ResponseEntity<Map<String, Object>> modifyCoursePlan(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        String loginId = (String) request.getSession().getAttribute("loginId");

        // 공통 검증 호출 (세션, 날짜, 중복)
        ResponseEntity<Map<String, Object>> validationResponse = validateCoursePlan(paramMap, loginId);
        if (validationResponse != null) return validationResponse;

        int updatedCount = coursePlanService.updateCoursePlan(paramMap);

        Map<String, Object> resultMap = new HashMap<>();
        if (updatedCount > 0) {
          resultMap.put("result", "SUCCESS");
          resultMap.put("resultMsg", "성공적으로 수정되었습니다.");
          return ResponseEntity.ok(resultMap);
        } else {
          resultMap.put("result", "FAIL");
          resultMap.put("resultMsg", "수정에 실패했습니다.");
          return ResponseEntity.badRequest().body(resultMap);
        }
      }

//    @PostMapping("deleteCoursePlan")
//    @ResponseBody
//    public Map<String, Object> deleteCoursePlan(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
//        logger.info("+ Start " + className + ".deleteCoursePlan");
//        logger.info("   - paramMap : " + paramMap);
//
//        Map<String, Object> resultMap = new HashMap<>();
//
//        // 상세 조회 실행
//        ICourseVO courseDetail = coursePlanService.getCoursPlanDetail(paramMap);
//
//        if (courseDetail != null) {
//            // 1. 수강생 수 체크
//
//            String statusCode = courseDetail.getCos_sta_code();
//
//            if ("1".equals(statusCode)) {
//                resultMap.put("result", "FAIL");
//                resultMap.put("resultMsg", "진행 중인 강의(상태코드 1)는 삭제할 수 없습니다.");
//                return resultMap;
//            }
//
//            if (courseDetail.getStu_cnt() > 0) {
//                resultMap.put("result", "FAIL");
//                resultMap.put("resultMsg", "수강생이 있는 강의는 삭제할 수 없습니다.");
//                return resultMap;
//            }
//
//            // 2. 날짜 체크 (진행 중인 강의인지)
////            try {
////                java.time.LocalDate today = java.time.LocalDate.now(); // 오늘 (2026-01-15)
////                java.time.LocalDate endDate = java.time.LocalDate.parse(courseDetail.getEnd_date()); // 종료일 (2026-04-01)
////
////                // 오늘이 종료일 이전이거나 당일이면 삭제 불가
////                if (!today.isAfter(endDate)) {
////                    resultMap.put("result", "FAIL");
////                    resultMap.put("resultMsg", "현재 진행 중이거나 예정된 강의는 삭제할 수 없습니다.");
////                    return resultMap;
////                }
////            } catch (Exception e) {
////                logger.error("날짜 파싱 에러: " + e.getMessage());
////            }
//        }
//
//        // 위 조건들에 안 걸려야만 실행됨
//        int deleteResult = coursePlanService.deleteCoursePlan(paramMap);
//
//        if(deleteResult > 0){
//            resultMap.put("result", "SUCCESS");
//        } else {
//            resultMap.put("result", "FAIL");
//            resultMap.put("resultMsg", "삭제 실패");
//        }
//
//        return resultMap;
//    }

    @PostMapping("deleteCoursePlan")
    @ResponseBody
    public Map<String, Object> deleteCoursePlan(@RequestParam Map<String, Object> paramMap) {

      Map<String, Object> resultMap = new HashMap<>();

      ICourseVO courseDetail = coursePlanService.getCoursPlanDetail(paramMap);

      if (courseDetail == null) {
        resultMap.put("result", "FAIL");
        resultMap.put("resultMsg", "존재하지 않는 강의입니다.");
        return resultMap;
      }

      // 상태 체크 (null 방어)
      if ("1".equals(courseDetail.getCos_sta_code())) {
        resultMap.put("result", "FAIL");
        resultMap.put("resultMsg", "진행 중인 강의는 삭제할 수 없습니다.");
        return resultMap;
      }


      if (courseDetail.getStu_cnt() > 0) {
        resultMap.put("result", "FAIL");
        resultMap.put("resultMsg", "수강생이 있는 강의는 삭제할 수 없습니다.");
        return resultMap;
      }

      int deleteResult = coursePlanService.deleteCoursePlan(paramMap);

      if (deleteResult > 0) {
        resultMap.put("result", "SUCCESS");
        resultMap.put("resultMsg", "삭제되었습니다.");
      } else {
        resultMap.put("result", "FAIL");
        resultMap.put("resultMsg", "삭제에 실패했습니다.");
      }

      return resultMap;
    }


  @PostMapping("searchCoursePlanList")
    public String searchCoursePlanList(Model model, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
        logger.info("+ Start " + className + ".searchCoursePlanList");
        logger.info("   - paramMap : " + paramMap);
        HttpSession session = request.getSession();
        String loginId = session.getAttribute("loginId").toString();
        String userType =  session.getAttribute("userType").toString();
        paramMap.put("loginID", loginId);
        paramMap.put("userType", userType);
        int currentPage = Integer.parseInt((String)paramMap.get("currentPage"));	// 현재 페이지 번호
        int pageSize = Integer.parseInt((String)paramMap.get("pageSize"));			// 페이지 사이즈
        int pageIndex = (currentPage-1)*pageSize;												// 페이지 시작 row 번호
        logger.info("   - currentPage : " + currentPage);
        logger.info("   - pageSize : " + pageSize);
        logger.info("   - pageIndex : " + pageIndex);
        paramMap.put("pageIndex", pageIndex);
        paramMap.put("pageSize", pageSize);
        List<ICourseVO> searchCoursePlanList =  coursePlanService.searchCoursePlanList(paramMap);

        logger.info(" - searchCoursePlanList : " + searchCoursePlanList);

        model.addAttribute("coursePlanList", searchCoursePlanList);
        model.addAttribute("result", "SUCCESS");

        //int totalCount = coursePlanService.searchCoursePlanCnt(paramMap);
        int totalCount = courseService.totalCntCourse(paramMap);
        logger.info(" - totalCount : " + totalCount);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("loginID", loginId);
        model.addAttribute("userType", userType);
        logger.info("+ End " + className + ".searchCoursePlanList");
        return path+"/coursePlanList";
    }


}
