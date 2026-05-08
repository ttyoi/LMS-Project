package kr.happyjob.study.domain.admin.controller.aTestSchedule;

import kr.happyjob.study.domain.admin.dao.ATestScheduleDao.ATestScheduleDao;
import kr.happyjob.study.domain.admin.model.ATestSchedule.ATestSchedule;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
//@RequestMapping("/admin/exam")
@RequestMapping("api/admin/exam")
public class ATestScheduleController {

    @Autowired
    private ATestScheduleDao aTestScheduleDao;

    // 시험일정 리스트 조회
    @GetMapping("/schedule")
    public String listTestSchedules(Model model) {
    	
        List<ATestSchedule> testScheduleList = aTestScheduleDao.selectTestScheduleList();

        System.out.println("=== Controller Debug ===");
        System.out.println("testScheduleList size: " + testScheduleList.size());
        System.out.println("testScheduleList: " + testScheduleList);

        model.addAttribute("testScheduleList", testScheduleList);
        return "admin/aTest/testScheduleList";
    }

    @GetMapping("/scheduleDetail/{courseId}/{period}")
    public String detailTestSchedules(@PathVariable("courseId") int courseId,
                                      @PathVariable("period") int period,
                                      Model model) {
        ATestSchedule detail = aTestScheduleDao.selectTestScheduleDetail(courseId,period);

        model.addAttribute("detail", detail);
        model.addAttribute("courseId", courseId);
        model.addAttribute("period", period);
        return "admin/aTest/testScheduleDetail";
    }


    @GetMapping("/schedule/list")
    @ResponseBody
    public List<ATestSchedule> getTestScheduleList() {
        return aTestScheduleDao.selectTestScheduleList();
    }
//-----------------------------------------------------------------------------------------------------------------------------------
//    @GetMapping("api/schedule/list")
//    @ResponseBody
//    public List<ATestSchedule> getTestScheduleList11() {
//        return aTestScheduleDao.selectTestScheduleList();
//    }
//-----------------------------------------------------------------------------------------------------------------------------------    

    @GetMapping("/schedule/detail/{courseId}/{period}")
    @ResponseBody
    public ATestSchedule getTestScheduleDetail(
            @PathVariable int courseId,
            @PathVariable int period) {
        return aTestScheduleDao.selectTestScheduleDetail(courseId,period);
    }



    @PostMapping("/updateStatus/{courseId}/{period}")
    @ResponseBody
    public Map<String, Object> updateTestScheduleStatus(
            @PathVariable int courseId,
            @PathVariable int period,
            @RequestBody Map<String, Integer> requestData) {

        int status = requestData.get("status");
        System.out.println("period=" + period + ", status=" + status);


        Map<String, Object> result = new HashMap<>();

        try {
            aTestScheduleDao.updateStatus(courseId, period, status); // DAO 호출
            result.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
        }

        return result;
    }




}
