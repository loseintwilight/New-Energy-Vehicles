package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadCarbonStatisticsMapper;
import com.ruoyi.business.domain.StadCarbonStatistics;
import com.ruoyi.business.service.IStadCarbonStatisticsService;

@Service
public class StadCarbonStatisticsServiceImpl implements IStadCarbonStatisticsService {

    @Autowired
    private StadCarbonStatisticsMapper stadCarbonStatisticsMapper;

    @Override
    public StadCarbonStatistics selectStadCarbonStatisticsById(Long statId) {
        return stadCarbonStatisticsMapper.selectStadCarbonStatisticsById(statId);
    }

    @Override
    public List<StadCarbonStatistics> selectStadCarbonStatisticsList(StadCarbonStatistics statistics) {
        return stadCarbonStatisticsMapper.selectStadCarbonStatisticsList(statistics);
    }

    @Override
    public int insertStadCarbonStatistics(StadCarbonStatistics statistics) {
        return stadCarbonStatisticsMapper.insertStadCarbonStatistics(statistics);
    }

    @Override
    public int updateStadCarbonStatistics(StadCarbonStatistics statistics) {
        return stadCarbonStatisticsMapper.updateStadCarbonStatistics(statistics);
    }

    @Override
    public int deleteStadCarbonStatisticsByIds(Long[] statIds) {
        return stadCarbonStatisticsMapper.deleteStadCarbonStatisticsByIds(statIds);
    }
}