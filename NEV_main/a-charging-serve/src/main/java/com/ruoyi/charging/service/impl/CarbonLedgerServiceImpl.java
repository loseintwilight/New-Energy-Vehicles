package com.ruoyi.charging.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.charging.domain.CarbonLedger;
import com.ruoyi.charging.mapper.CarbonLedgerMapper;
import com.ruoyi.charging.service.ICarbonLedgerService;

/**
 * 碳积分流水 服务层实现
 *
 * @author ruoyi
 */
@Service
public class CarbonLedgerServiceImpl implements ICarbonLedgerService
{
    @Autowired
    private CarbonLedgerMapper carbonLedgerMapper;

    /**
     * 查询碳积分流水列表
     *
     * @param carbonLedger 碳积分流水信息
     * @return 碳积分流水集合
     */
    @Override
    public List<CarbonLedger> selectCarbonLedgerList(CarbonLedger carbonLedger)
    {
        return carbonLedgerMapper.selectList(carbonLedger);
    }

    /**
     * 通过ID查询碳积分流水
     *
     * @param ledgerId 流水ID
     * @return 碳积分流水信息
     */
    @Override
    public CarbonLedger selectCarbonLedgerById(Long ledgerId)
    {
        return carbonLedgerMapper.selectById(ledgerId);
    }

    /**
     * 新增碳积分流水
     *
     * @param carbonLedger 碳积分流水信息
     * @return 结果
     */
    @Override
    public int insertCarbonLedger(CarbonLedger carbonLedger)
    {
        return carbonLedgerMapper.insert(carbonLedger);
    }

    /**
     * 修改碳积分流水
     *
     * @param carbonLedger 碳积分流水信息
     * @return 结果
     */
    @Override
    public int updateCarbonLedger(CarbonLedger carbonLedger)
    {
        return carbonLedgerMapper.update(carbonLedger);
    }

    /**
     * 批量删除碳积分流水
     *
     * @param ledgerIds 需要删除的流水ID
     * @return 结果
     */
    @Override
    public int deleteCarbonLedgerByIds(Long[] ledgerIds)
    {
        return carbonLedgerMapper.deleteByIds(ledgerIds);
    }
}
