package com.ruoyi.charging.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.charging.domain.CarbonStatistics;
import com.ruoyi.charging.mapper.CarbonStatisticsMapper;
import com.ruoyi.charging.service.ICarbonStatisticsService;

/**
 * 碳排放统计 服务层实现
 *
 * @author ruoyi
 */
@Service
public class CarbonStatisticsServiceImpl implements ICarbonStatisticsService
{
    @Autowired
    private CarbonStatisticsMapper carbonStatisticsMapper;

    /**
     * 查询碳排放统计列表
     *
     * @param carbonStatistics 碳排放统计信息
     * @return 碳排放统计集合
     */
    @Override
    public List<CarbonStatistics> selectCarbonStatisticsList(CarbonStatistics carbonStatistics)
    {
        return carbonStatisticsMapper.selectList(carbonStatistics);
    }

    /**
     * 通过ID查询碳排放统计
     *
     * @param statId 统计ID
     * @return 碳排放统计信息
     */
    @Override
    public CarbonStatistics selectCarbonStatisticsById(Long statId)
    {
        return carbonStatisticsMapper.selectById(statId);
    }

    /**
     * 新增碳排放统计
     *
     * @param carbonStatistics 碳排放统计信息
     * @return 结果
     */
    @Override
    public int insertCarbonStatistics(CarbonStatistics carbonStatistics)
    {
        return carbonStatisticsMapper.insert(carbonStatistics);
    }

    /**
     * 修改碳排放统计
     *
     * @param carbonStatistics 碳排放统计信息
     * @return 结果
     */
    @Override
    public int updateCarbonStatistics(CarbonStatistics carbonStatistics)
    {
        return carbonStatisticsMapper.update(carbonStatistics);
    }

    /**
     * 批量删除碳排放统计
     *
     * @param statIds 需要删除的统计ID
     * @return 结果
     */
    @Override
    public int deleteCarbonStatisticsByIds(Long[] statIds)
    {
        return carbonStatisticsMapper.deleteByIds(statIds);
    }
}
