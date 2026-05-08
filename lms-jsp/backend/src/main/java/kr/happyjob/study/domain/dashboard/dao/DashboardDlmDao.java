package kr.happyjob.study.domain.dashboard.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.domain.dashboard.model.DeliveryBuyerModel;

public interface DashboardDlmDao {
	
	List<DeliveryBuyerModel> deliveryBuyerList(Map<String, Object> paramMap);

}
