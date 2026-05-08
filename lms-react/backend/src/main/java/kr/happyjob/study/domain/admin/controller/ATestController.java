package kr.happyjob.study.domain.admin.controller;

import kr.happyjob.study.domain.admin.model.ATestDetailVO;
import kr.happyjob.study.domain.admin.model.ATestListVO;
import kr.happyjob.study.domain.admin.model.ATestStatusVO;
import kr.happyjob.study.domain.admin.service.ATestService;
import lombok.RequiredArgsConstructor;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
//@RequestMapping("/admin/test-exam")
@RequestMapping("api/admin/test-exam")
public class ATestController {

    // Set logger
    private final Logger logger = LogManager.getLogger(this.getClass());

    // Get class name for logger
    private final String className = this.getClass().toString();

    private final ATestService testService ;


    // 시험목록 페이지 불러오기
    @GetMapping("")
    public String TestList(){

        logger.info("+ 관리자 시험목록 페이지 이동 시작" + className + ".initComnCod");
//        logger.info("   - paramMap : " + paramMap);
//
        logger.info("+ 관리자 시험목록 페이지 이동 끝 " + className + ".initComnCod");

        return "admin/testList";

    }

    // 시험목록 불러오기
    @GetMapping("/list")
    @ResponseBody
    public Map<String, Object> getTestList(@RequestParam(required = false) String keyword,
                                           @RequestParam(required = false) String filteredType,
                                           @RequestParam(defaultValue = "1") int currentPage,
                                           @RequestParam(defaultValue = "5") int pageSize) throws Exception{


        logger.info("+ 관리자 시험목록 불러오기 시작" + className + ".initComnCod");

        Map<String,Object> paramMap = new HashMap<>();

        int pageIndex = (currentPage - 1) * pageSize;
        paramMap.put("pageIndex", pageIndex);
        paramMap.put("pageSize", pageSize);
        paramMap.put("keyword", keyword);
        paramMap.put("filteredType", filteredType);

        logger.info("   - paramMap : " + paramMap);


        //Service 호출
        List<ATestListVO> testList = testService.getTestList(paramMap);
        int totalCount = testService.getTestTotalCount(paramMap);

        logger.info("+ 관리자 시험목록 불러오기 끝 " + className + ".initComnCod");

        // JSP 로 전달할 Model 값 넣기
        // 시험명 테이블 위치 변경 추후 반영할 것 (12/05)
        Map<String, Object> result = new HashMap<>();
        result.put("list", testList);
        result.put("totalCount", totalCount);

        return result;

    }


    // 시험정보 상세보기 이동
    @GetMapping("/detail/{courseId}/{period}")
    public String TestDetail(
            @PathVariable Integer courseId,
            @PathVariable Integer period,
            Model model
    ) throws Exception{

        logger.info("+ 관리자 시험상세 페이지 이동 시작" + className + ".initComnCod");
        model.addAttribute("courseId", courseId);
        model.addAttribute("period", period);

        logger.info("   - model : " + model);
        logger.info("+ 관리자 시험상세 페이지 이동 끝 " + className + ".initComnCod");

        return "admin/testDetail";
    }

    // 시험문제 상세 불러오기
    @GetMapping("/detail/{courseId}/{period}/data")
    @ResponseBody
    public List<ATestDetailVO> getTestDetail(@PathVariable Integer courseId,
                                             @PathVariable Integer period) throws Exception {
    	logger.info("+ 관리자 시험상세 ");
        return testService.getTestDetail(courseId, period);
    }

    
    // 시험정보 수정하기 페이지 이동
    @GetMapping("/edit/{courseId}/{period}")
    public String editTest(
            @PathVariable Integer courseId,
            @PathVariable Integer period,
            Model model
    ) throws Exception{

        // 페이지 이동 전 조건(시험이 닫혀있을 것)
        ATestStatusVO status = testService.checkStatus(courseId,period);

        // 시험 정보가 없을 경우
        if (status == null) {
            model.addAttribute("alertMessage", "시험 중인 시험은 수정할 수 없습니다.");
            return "admin/AtestAlert";
        }

        // 시험 중이면 수정 불가
        if (status.getStatus() == 1) {
            model.addAttribute("msg", "현재 시험이 진행 중이라 수정할 수 없습니다.");
            model.addAttribute("url", "/admin/test-exam");
            return "admin/AtestAlert";
        }

        logger.info("+ 현재 시험은 닫혀있음 => 수정가능" + className + ".initComnCod");
        logger.info("+ 관리자 시험정보 수정페이지 이동 시작" + className + ".initComnCod");
        model.addAttribute("courseId", courseId);
        model.addAttribute("period", period);
        model.addAttribute("status", status);
        logger.info("   - model : " + model);
        logger.info("+ 관리자 시험정보 수정페이지 이동 끝 " + className + ".initComnCod");

        return "admin/editTest";
    }

    // 시험 상태 조회 (JSON)
    @GetMapping("/status/{courseId}/{period}")
    @ResponseBody
    public ATestStatusVO getStatus(@PathVariable Integer courseId,
                                   @PathVariable Integer period) throws Exception {
        return testService.checkStatus(courseId, period);
    }


    // 시험정보 DB 수정
    @PostMapping("/edit")
    @ResponseBody
    public Map<String, String> editTestDetail(@RequestBody List<ATestDetailVO> details
    ) throws Exception{
        Map<String, String> result = new HashMap<>();

        logger.info("+ 관리자 시험정보 수정 시작" + className + ".initComnCod");
        try {
            for (ATestDetailVO vo : details) {
                testService.updateTestDetail(vo);
            }
            result.put("status", "success");
        } catch (Exception e) {
            result.put("status", "fail");
            result.put("message", e.getMessage());
        }

        logger.info("   - result : " + result);
        logger.info("+ 관리자 시험정보 수정 끝 " + className + ".initComnCod");

        return result;
    }

}
