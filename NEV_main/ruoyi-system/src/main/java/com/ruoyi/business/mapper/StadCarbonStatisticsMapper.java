package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadCarbonStatistics;

public interface StadCarbonStatisticsMapper {
    StadCarbonStatistics selectStadCarbonStatisticsById(Long statId);
    List<StadCarbonStatistics> selectStadCarbonStatisticsList(StadCarbonStatistics statistics);
    int insertStadCarbonStatistics(StadCarbonStatistics statistics);
    int updateStadCarbonStatistics(StadCarbonStatistics statistics);
    int deleteStadCarbonStatisticsById(Long statId);
    int deleteStadCarbonStatisticsByIds(Long[] statIds);
}