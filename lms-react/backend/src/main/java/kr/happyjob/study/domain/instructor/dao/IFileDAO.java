package kr.happyjob.study.domain.instructor.dao;

import kr.happyjob.study.domain.instructor.model.FileVO;

import java.util.Map;

public interface IFileDAO {
    int insertFile(FileVO fileVO);
    FileVO selectFile(Long fileId);
    int deleteFile(Long fileId);
}
