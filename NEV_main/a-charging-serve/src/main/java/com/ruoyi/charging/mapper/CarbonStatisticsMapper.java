package com.ruoyi.charging.mapper;

import java.util.List;
import com.ruoyi.charging.domain.CarbonStatistics;
import org.apache.ibatis.annotations.Mapper;

/**
 * 碳排放统计 数据层
 *
 * @author ruoyi
 */
@Mapper
public interface CarbonStatisticsMapper {

    /**
     * 查询碳排放统计列表
     *
     * @param carbonStatistics 碳排放统计信息
     * @return 碳排放统计集合
     */
    public List<CarbonStatistics> selectList(CarbonStatistics carbonStatistics);

    /**
     * 通过ID查询碳排放统计
     *
     * @param statId 统计ID
     * @return 碳排放统计信息
     */
    public CarbonStatistics selectById(Long statId);

    /**
     * 新增碳排放统计
     *
     * @param carbonStatistics 碳排放统计信息
     * @return 结果
     */
    public int insert(CarbonStatistics carbonStatistics);

    /**
     * 修改碳排放统计
     *
     * @param carbonStatistics 碳排放统计信息
     * @return 结果
     */
    public int update(CarbonStatistics carbonStatistics);

    /**
     * 批量删除碳排放统计
     *
     * @param statIds 需要删除的统计ID
     * @return 结果
     */
    public int deleteByIds(Long[] statIds);
}
