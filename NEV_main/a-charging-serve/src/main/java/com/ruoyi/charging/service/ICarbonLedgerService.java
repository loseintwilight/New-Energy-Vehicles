package com.ruoyi.charging.service;

import java.util.List;
import com.ruoyi.charging.domain.CarbonLedger;

/**
 * 碳积分流水 服务层
 *
 * @author ruoyi
 */
public interface ICarbonLedgerService
{
    /**
     * 查询碳积分流水列表
     *
     * @param carbonLedger 碳积分流水信息
     * @return 碳积分流水集合
     */
    public List<CarbonLedger> selectCarbonLedgerList(CarbonLedger carbonLedger);

    /**
     * 通过ID查询碳积分流水
     *
     * @param ledgerId 流水ID
     * @return 碳积分流水信息
     */
    public CarbonLedger selectCarbonLedgerById(Long ledgerId);

    /**
     * 新增碳积分流水
     *
     * @param carbonLedger 碳积分流水信息
     * @return 结果
     */
    public int insertCarbonLedger(CarbonLedger carbonLedger);

    /**
     * 修改碳积分流水
     *
     * @param carbonLedger 碳积分流水信息
     * @return 结果
     */
    public int updateCarbonLedger(CarbonLedger carbonLedger);

    /**
     * 批量删除碳积分流水
     *
     * @param ledgerIds 需要删除的流水ID
     * @return 结果
     */
    public int deleteCarbonLedgerByIds(Long[] ledgerIds);
}
