package com.ruoyi.charging.service;

import java.util.List;
import com.ruoyi.charging.domain.CarbonStatistics;

/**
 * 碳排放统计 服务层
 *
 * @author ruoyi
 */
public interface ICarbonStatisticsService
{
    /**
     * 查询碳排放统计列表
     *
     * @param carbonStatistics 碳排放统计信息
     * @return 碳排放统计集合
     */
    public List<CarbonStatistics> selectCarbonStatisticsList(CarbonStatistics carbonStatistics);

    /**
     * 通过ID查询碳排放统计
     *
     * @param statId 统计ID
     * @return 碳排放统计信息
     */
    public CarbonStatistics selectCarbonStatisticsById(Long statId);

    /**
     * 新增碳排放统计
     *
     * @param carbonStatistics 碳排放统计信息
     * @return 结果
     */
    public int insertCarbonStatistics(CarbonStatistics carbonStatistics);

    /**
     * 修改碳排放统计
     *
     * @param carbonStatistics 碳排放统计信息
     * @return 结果
     */
    public int updateCarbonStatistics(CarbonStatistics carbonStatistics);

    /**
     * 批量删除碳排放统计
     *
     * @param statIds 需要删除的统计ID
     * @return 结果
     */
    public int deleteCarbonStatisticsByIds(Long[] statIds);
}
