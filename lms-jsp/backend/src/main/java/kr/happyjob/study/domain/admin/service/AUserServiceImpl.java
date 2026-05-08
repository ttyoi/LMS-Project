package kr.happyjob.study.domain.admin.service;

import kr.happyjob.study.domain.admin.dao.AUserDAO;
import kr.happyjob.study.domain.admin.model.AResumeVO;
import kr.happyjob.study.domain.admin.model.AUserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AUserServiceImpl implements AUserService {

    @Autowired
    private AUserDAO aUserDAO;

    // 강사 리스트
    @Override
    public List<AUserVO> getInstructorList(Map<String, Object> paramMap){
        paramMap.put("user_type", "I");
        return aUserDAO.selectUserList(paramMap);
    }
    // 강사 수
    @Override
    public int getInstructorListCount(Map<String, Object> paramMap){
        paramMap.put("user_type", "I");
        return aUserDAO.selectUserListCount(paramMap);
    }

    // 강사 상세 정보
    @Override
    public AUserVO getInstructorDetail(String loginID){
        Map<String, Object> param =new HashMap<>();
        param.put("user_type", "I");
        param.put("loginID", loginID);
        param.put("startNum",0);
        param.put("pageSize",1);

        List<AUserVO> list=aUserDAO.selectUserList(param);
        if(list ==null || list.isEmpty()){
            return null;
        }
        return list.get(0);
    }

    // 학생 리스트
    @Override
    public List<AUserVO> getStudentList(Map<String, Object> paramMap){
        paramMap.put("user_type", "S");
        return aUserDAO.selectUserList(paramMap);
    }
    // 학생 수
    public int getStudentListCount(Map<String, Object> paramMap){
        paramMap.put("user_type", "S");
        return aUserDAO.selectUserListCount(paramMap);
    }

    // 학생 상세 정보
    @Override
    public AUserVO getStudentDetailByLogin(String loginID){

        Map<String, Object> param =new HashMap<>();
        param.put("user_type", "S");
        param.put("loginID", loginID);
        param.put("startNum",0);
        param.put("pageSize",1);

        List<AUserVO> list=aUserDAO.selectUserList(param);
        if(list ==null || list.isEmpty()){
            return null;
        }
        return list.get(0);
    }

    @Override
    public int updateStudentStatus(String loginID, String status){
        return aUserDAO.updateStudentStatus(loginID,status);
    }

    // 이력서 다운로드
    @Override
    public AResumeVO getResumeByLoginID(String loginID){
        return aUserDAO.selectResumeByLoginID(loginID);
    }

}
