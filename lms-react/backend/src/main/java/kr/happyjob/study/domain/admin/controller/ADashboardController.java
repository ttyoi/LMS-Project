package kr.happyjob.study.domain.admin.controller;

import kr.happyjob.study.domain.admin.dao.ADashboardDao;
import kr.happyjob.study.domain.admin.model.ADashboard;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/dashboard")
public class ADashboardController {

    @Autowired
    private ADashboardDao aDashboardDao;

    @GetMapping
    public String dashboard()
    {
        return "admin/aDashboard";
    }

    @GetMapping("/viewExam")
    @ResponseBody
    public List<ADashboard> getMonthlyExams() {

        return aDashboardDao.getMonthlyExams();
    }

    @GetMapping("/viewClassrooms")
    @ResponseBody
    public List<ADashboard> getTodayClassrooms() {

        return aDashboardDao.getTodayClasses();
    }

    @GetMapping("/viewUsers")
    @ResponseBody
    public Map<String, Integer> viewUsers() {
        Map<String, Integer> userStats = new HashMap<>();
        userStats.put("totalUsers", aDashboardDao.getTotalUsers());
        userStats.put("students", aDashboardDao.getStudentCount());
        userStats.put("teachers", aDashboardDao.getTeacherCount());
        userStats.put("newUsers", aDashboardDao.getNewUsers());
        return userStats;
    }


    @GetMapping("/viewCommunity")
    @ResponseBody
    public Map<String, List<ADashboard>> viewCommunity() {
        Map<String, List<ADashboard>> communityData = new HashMap<>();

        communityData.put("recentNotices", aDashboardDao.getRecentNotices());
        communityData.put("recentSurveys", aDashboardDao.getRecentSurveys());
        communityData.put("recentQnaPosts", aDashboardDao.getRecentQnaPosts());

        return communityData;
    }



}
