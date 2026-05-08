package kr.happyjob.study.domain.student.dao;

import kr.happyjob.study.domain.student.model.FileVO;

public interface SFileDAO {
    FileVO selectFile(Long fileId);

}
