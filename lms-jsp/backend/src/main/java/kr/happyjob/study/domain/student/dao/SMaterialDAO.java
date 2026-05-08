package kr.happyjob.study.domain.student.dao;

import kr.happyjob.study.domain.instructor.model.ICourseSimpleVO;
import kr.happyjob.study.domain.instructor.model.IMaterialVO;
import kr.happyjob.study.domain.student.model.SCourseSimpleVO;
import kr.happyjob.study.domain.student.model.SMaterialSearchDTO;
import kr.happyjob.study.domain.student.model.SMaterialVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface SMaterialDAO {

    int totalCnt(SMaterialSearchDTO sMaterialSearchDTO);


    List<SMaterialVO> loadMaterials(SMaterialSearchDTO sMaterialSearchDTO);


    List<SCourseSimpleVO> loadStuCourse(String loginID);
}
