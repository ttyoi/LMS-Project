package kr.happyjob.study.domain.dashboard.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.domain.dashboard.model.PcmModel;

public interface DashboardPcmDao {
	
	List<PcmModel> purchaseOrderList(Map<String, Object> paramMap);

}
