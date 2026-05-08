package kr.happyjob.study.domain.admin.controller;

import kr.happyjob.study.domain.admin.model.AInstEvalVO;
import kr.happyjob.study.domain.admin.service.AInstEvalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
public class AInstEvalController {

    @Autowired
    private AInstEvalService aInstEvalService;

    @PostMapping("/admin/inst/eval")
    @ResponseBody
    public Map<String, Object> getInstEval(@RequestParam("loginID") String loginID) {
        AInstEvalVO evalVO = aInstEvalService.getInstEval(loginID);

        Map<String, Object> result = new HashMap<>();
        result.put("result", "SUCCESS");
        result.put("content", evalVO != null ? evalVO.getContent() : "");
        return result;
    }

    @PostMapping("/admin/inst/eval/save")
    @ResponseBody
    public Map<String, Object> saveInstEval(@RequestParam("loginID") String loginID, @RequestParam("content") String content) {
        Map<String, Object> result = new HashMap<>();

        AInstEvalVO evalVO = new AInstEvalVO();
        evalVO.setLoginID(loginID);
        evalVO.setContent(content);
        aInstEvalService.saveInstEval(evalVO);
        result.put("result", "SUCCESS");

        return result;
    }

    @PostMapping("/api/admin/inst/eval")
    @ResponseBody
    public Map<String, Object> getInstEvalReact(@RequestParam("loginID") String loginID) {
        AInstEvalVO evalVO = aInstEvalService.getInstEval(loginID);

        Map<String, Object> result = new HashMap<>();
        result.put("result", "SUCCESS");
        result.put("content", evalVO != null ? evalVO.getContent() : "");
        return result;
    }

    @PostMapping("/api/admin/inst/eval/save")
    @ResponseBody
    public Map<String, Object> saveInstEvalReact(@RequestParam("loginID") String loginID, @RequestParam("content") String content) {
        Map<String, Object> result = new HashMap<>();

        AInstEvalVO evalVO = new AInstEvalVO();
        evalVO.setLoginID(loginID);
        evalVO.setContent(content);
        aInstEvalService.saveInstEval(evalVO);
        result.put("result", "SUCCESS");

        return result;
    }

}
