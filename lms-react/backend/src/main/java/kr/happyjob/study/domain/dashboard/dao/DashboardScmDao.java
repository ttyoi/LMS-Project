package kr.happyjob.study.domain.dashboard.dao;

import java.util.List;

import kr.happyjob.study.domain.dashboard.model.DashboardScmModel;


public interface DashboardScmDao {

	// main tree map 
	public List<DashboardScmModel> getCurdateData();
	
	
	// main bar map
	public List<DashboardScmModel> getBardateData();
	
}
