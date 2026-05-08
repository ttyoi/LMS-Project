package kr.happyjob.study.domain.student.service;

import kr.happyjob.study.domain.student.dao.SFileDAO;
import kr.happyjob.study.domain.student.dao.SMaterialDAO;
import kr.happyjob.study.domain.student.model.FileVO;
import kr.happyjob.study.domain.student.model.SCourseSimpleVO;
import kr.happyjob.study.domain.student.model.SMaterialSearchDTO;
import kr.happyjob.study.domain.student.model.SMaterialVO;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
public class SMaterialServiceImpl implements SMaterialService {

    Logger logger = Logger.getLogger(SMaterialServiceImpl.class);

    @Autowired
    private SMaterialDAO sMaterialDAO;

    @Autowired
    private SFileDAO sFileDAO;

    @Override
    public int totalCnt(SMaterialSearchDTO sMaterialSearchDTO) {
        return sMaterialDAO.totalCnt(sMaterialSearchDTO);
    }


    @Override
    public List<SMaterialVO> loadMaterials(SMaterialSearchDTO sMaterialSearchDTO) {
        return sMaterialDAO.loadMaterials(sMaterialSearchDTO);
    }

    @Override
    public FileVO selectFile(Long fileId) {
        return sFileDAO.selectFile(fileId);
    }

    @Override
    public List<SCourseSimpleVO> loadStuCourse(String loginID) {
        return sMaterialDAO.loadStuCourse(loginID);
    }


}
