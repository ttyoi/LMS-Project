package kr.happyjob.study.domain.admin.controller.courseClass;

import kr.happyjob.study.domain.admin.dao.courseClass.CourseClassDao;
import kr.happyjob.study.domain.admin.model.courseClass.CourseClass;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Controller
//@RequestMapping("/admin/classrooms")
@RequestMapping("api/admin/classrooms")
public class CourseClassController {

    @Autowired
    private CourseClassDao courseClassDao;

    /** 목록 조회 */
// 리스트 조회
    @GetMapping("/list")
    @ResponseBody
    public List<Map<String, Object>> list(@RequestParam(required = false) String search) {
        // search 파라미터를 다오까지 전달하여 검색 기능 연동
        return courseClassDao.listClassrooms(search);
    }

    @GetMapping("/list/paging")
    @ResponseBody
    public Map<String, Object> listPaging(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String search
    ) {
        int offset = (page - 1) * pageSize;

        List<CourseClass> list =
                courseClassDao.listClassroomsPaging(offset, pageSize, search);

        int totalCount =
                courseClassDao.countClassrooms(search);

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("totalCount", totalCount);
        result.put("page", page);
        result.put("pageSize", pageSize);

        return result;
    }


    @GetMapping("/detail")
    @ResponseBody
    public List<Map<String,Object>> detail(@RequestParam("name") String className) {
        return courseClassDao.detailClassroomByName(className);
    }

    /** 등록 */
    @PostMapping("/insert")
    @ResponseBody
    public int insert(@RequestBody CourseClass courseClass) {
        return courseClassDao.insertClassroom(courseClass);
    }

    /** 수정 */
    @PutMapping("/update")
    @ResponseBody
    public int update(@RequestBody CourseClass courseClass) {
        return courseClassDao.updateClassroom(courseClass);
    }

    /** 강의실 정보 수정 (class_name, people_limit, status) */
    @PutMapping("/updateInfo")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateInfo(@RequestBody Map<String, Object> payload) {
        Map<String, Object> result = new HashMap<>();
        try {
            int count = courseClassDao.updateClassroomInfo(payload);
            result.put("success", count > 0);
            result.put("count", count);
            return count > 0
                    ? ResponseEntity.ok(result)
                    : ResponseEntity.status(HttpStatus.BAD_REQUEST).body(result);
        } catch (Exception e) {
            result.put("success", false);
            result.put("count", 0);
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
        }
    }

    /** 삭제 */
    @DeleteMapping("/delete")
    @ResponseBody
    public int delete(@RequestParam String class_name) {
        return courseClassDao.deleteClassroomByName(class_name);
    }

    @GetMapping("")
    public String viewPage() {
        return "admin/classroom/classroom";  // 실제 JSP 경로
    }


}

