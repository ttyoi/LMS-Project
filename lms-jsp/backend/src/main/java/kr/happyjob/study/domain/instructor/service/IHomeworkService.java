package kr.happyjob.study.domain.instructor.service;

import kr.happyjob.study.domain.homework.model.SubmissionListVO;
import kr.happyjob.study.domain.instructor.model.ICourseVO;
import kr.happyjob.study.domain.instructor.model.IHomeworkVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

public interface IHomeworkService {
    int insertHomework(IHomeworkVO vo);
    List<IHomeworkVO> listHomework();
    List<ICourseVO> getCourseListByTeacher(String loginId) throws Exception;
    List<IHomeworkVO> listHomework(String loginId);
    IHomeworkVO detailHomework(int homework_code);
    int updateSubmission(int submissionCode, Integer score, String feedback, String appealReply);
    int countSubmissions(int homework_code);

    void registerHomework(IHomeworkVO vo, List<MultipartFile> files) throws Exception;
    List<SubmissionListVO> getHomeworkSubmissions(int homeworkCode);
    List<SubmissionListVO> listSubmissions(int homeworkCode);
    List<SubmissionListVO> listAllSubmissions(String loginId);

    int deleteHomework(int homeworkCode);
    int deleteHomeworkFile(int homework_code);

    int updateHomework(IHomeworkVO data, List<MultipartFile> file);

    /**
     * 파일 상세 정보 조회 (다운로드용)
     * @param file_id 파일 고유 번호
     * @return 파일명, 물리경로, 논리경로 등이 담긴 Map
     * @throws Exception
     */
    Map<String, Object> getFileDetail(int file_id) throws Exception;
}