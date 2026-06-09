package com.ruoyi.charging.mapper;

import java.util.List;
import com.ruoyi.charging.domain.CarbonLedger;
import org.apache.ibatis.annotations.Mapper;

/**
 * 碳积分流水 数据层
 *
 * @author ruoyi
 */
@Mapper
public interface CarbonLedgerMapper {

    /**
     * 查询碳积分流水列表
     *
     * @param carbonLedger 碳积分流水信息
     * @return 碳积分流水集合
     */
    public List<CarbonLedger> selectList(CarbonLedger carbonLedger);

    /**
     * 通过ID查询碳积分流水
     *
     * @param ledgerId 流水ID
     * @return 碳积分流水信息
     */
    public CarbonLedger selectById(Long ledgerId);

    /**
     * 新增碳积分流水
     *
     * @param carbonLedger 碳积分流水信息
     * @return 结果
     */
    public int insert(CarbonLedger carbonLedger);

    /**
     * 修改碳积分流水
     *
     * @param carbonLedger 碳积分流水信息
     * @return 结果
     */
    public int update(CarbonLedger carbonLedger);

    /**
     * 批量删除碳积分流水
     *
     * @param ledgerIds 需要删除的流水ID
     * @return 结果
     */
    public int deleteByIds(Long[] ledgerIds);
}
