package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadCarbonStatistics;

public interface IStadCarbonStatisticsService {
    StadCarbonStatistics selectStadCarbonStatisticsById(Long statId);
    List<StadCarbonStatistics> selectStadCarbonStatisticsList(StadCarbonStatistics statistics);
    int insertStadCarbonStatistics(StadCarbonStatistics statistics);
    int updateStadCarbonStatistics(StadCarbonStatistics statistics);
    int deleteStadCarbonStatisticsByIds(Long[] statIds);
}