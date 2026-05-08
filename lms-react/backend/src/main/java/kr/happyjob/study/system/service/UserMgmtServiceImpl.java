package kr.happyjob.study.system.service;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.happyjob.study.common.comnUtils.FileUtilCho;
import kr.happyjob.study.system.dao.UserMgmtDao;
import kr.happyjob.study.system.model.UserMgmtModel;

@Service
public class UserMgmtServiceImpl implements UserMgmtService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	// Get class name for logger
	private final String className = this.getClass().toString();
	
	// Root path for file upload 
	@Value("${fileUpload.rootPath}")
	private String rootPath;
	
	@Value("${fileUpload.virtualRootPath}")
	private String virtualRootPath;
	
	@Value("${fileUpload.userPath}")
	private String userPath;
	
	
	@Autowired
	UserMgmtDao userMgmtDao;
	
	/** 사용자 목록 조회 */
	public List<UserMgmtModel> userlist(Map<String, Object> paramMap) throws Exception {
		
		return userMgmtDao.userlist(paramMap);
		
	}
	
	/** 사용자 목록 카운트 조회 */
	public int userlisttotalcnt(Map<String, Object> paramMap) throws Exception {
		
		return userMgmtDao.userlisttotalcnt(paramMap);
		
	}
	
	/** 특정 사용자  조회 */
	public UserMgmtModel userselect(Map<String, Object> paramMap) throws Exception {
		return userMgmtDao.userselect(paramMap);
	}
	
	/** ID 중복 체크 */
	public int iddupcheck(Map<String, Object> paramMap)throws Exception {
		return userMgmtDao.iddupcheck(paramMap);
	}
	
	// user 등록
	public int insertuser(Map<String, Object> paramMap, HttpServletRequest request)throws Exception {
		
		// 1. Upload 된 File을 처리 (특정 디렉토리에 저장)
		// 2. file 정보(파일멸, 논리경로,물리경로, 사이즈, 확장자  추출
		// 3 DB Insert
		
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
				
		String itemFilePath = userPath + File.separator;  
		FileUtilCho fileup = new FileUtilCho(multipartHttpServletRequest, rootPath, virtualRootPath, itemFilePath);
		Map<String, Object> fileinfo = fileup.uploadFiles();
				
		//map.put("file_nm", file_nm);
        //map.put("file_size", file_Size);
        //map.put("file_loc", file_loc);
        //map.put("vrfile_loc", vrfile_loc);
        //map.put("fileExtension", fileExtension);
        //map.put("file_nm_uuid", file_nm_uuid);
				
		// #{aa}
		// #{fileinfo.file_nm}
		
		if(fileinfo.get("file_nm") == null) {
			paramMap.put("fileyn", "N");
		} else {
			paramMap.put("fileyn", "Y");
			paramMap.put("fileinfo", fileinfo);
		}		
		
		return userMgmtDao.insertuser(paramMap);
	}
			
	// user 수정
	public int updateuser(Map<String, Object> paramMap, HttpServletRequest request)throws Exception {
		
		//                        수정 후 Data
		//                    file X  file O   
		// 수정전 Data file X       X      O
		//          file O       X      O (기존 File 삭제)
		//                    기존 파일 유지 O Update 항목 제외
		// 0. 기존 파일 삭제
		// 1. Upload 된 File을 처리 (특정 디렉토리에 저장)
		// 2. file 정보(파일멸, 논리경로,물리경로, 사이즈, 확장자  추출
		// 3 DB Insert
		
		// 0. 기존 파일 삭제
		UserMgmtModel olddata = userMgmtDao.selectfile(paramMap);
		String existyn = (String) paramMap.get("existyn");
		
		if(olddata.getFilesize() > 0) {
			if(!"on".equals(existyn)) {
				File oldfile = new File(olddata.getPygicalpath());
				oldfile.delete();
			}
		}
		
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
				
		String itemFilePath = userPath + File.separator;  
		FileUtilCho fileup = new FileUtilCho(multipartHttpServletRequest, rootPath, virtualRootPath, itemFilePath);
		Map<String, Object> fileinfo = fileup.uploadFiles();
				
		//map.put("file_nm", file_nm);
        //map.put("file_size", file_Size);
        //map.put("file_loc", file_loc);
        //map.put("vrfile_loc", vrfile_loc);
        //map.put("fileExtension", fileExtension);
        //map.put("file_nm_uuid", file_nm_uuid);
				
		// #{aa}
		// #{fileinfo.file_nm}
		
		if(fileinfo.get("file_nm") == null) {
			paramMap.put("fileyn", "N");
		} else {
			paramMap.put("fileyn", "Y");
			paramMap.put("fileinfo", fileinfo);
		}		
		
		return userMgmtDao.updateuser(paramMap);
	}	
	
	// user 삭제
	public int deleteuser(Map<String, Object> paramMap)throws Exception {
		UserMgmtModel olddata = userMgmtDao.selectfile(paramMap);
		
		if(olddata.getFilesize() > 0) {
		   File oldfile = new File(olddata.getPygicalpath());
		   oldfile.delete();
		}
		
		return userMgmtDao.deleteuser(paramMap);
	}
	
	// 파일정보 조회
	public UserMgmtModel selectuserfile(Map<String, Object> paramMap)throws Exception {
		
		 return userMgmtDao.selectfile(paramMap);
	}
			
	
}
