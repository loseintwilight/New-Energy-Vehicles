package com.ruoyi.charging.service.impl;

import com.ruoyi.charging.domain.ChargingSettlement;
import com.ruoyi.charging.mapper.ChargingSettlementMapper;
import com.ruoyi.charging.service.IChargingSettlementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 充电结算Service业务层处理
 *
 * @author ruoyi
 */
@Service
public class ChargingSettlementServiceImpl implements IChargingSettlementService
{
    @Autowired
    private ChargingSettlementMapper chargingSettlementMapper;

    @Override
    public List<ChargingSettlement> selectChargingSettlementList(ChargingSettlement settlement)
    {
        return chargingSettlementMapper.selectChargingSettlementList(settlement);
    }

    @Override
    public ChargingSettlement selectChargingSettlementById(Long settlementId)
    {
        return chargingSettlementMapper.selectChargingSettlementById(settlementId);
    }

    @Override
    public List<ChargingSettlement> selectChargingSettlementListByMerchantId(Long merchantId)
    {
        return chargingSettlementMapper.selectChargingSettlementListByMerchantId(merchantId);
    }

    @Override
    public int insertChargingSettlement(ChargingSettlement settlement)
    {
        return chargingSettlementMapper.insertChargingSettlement(settlement);
    }

    @Override
    public int updateChargingSettlement(ChargingSettlement settlement)
    {
        return chargingSettlementMapper.updateChargingSettlement(settlement);
    }

    @Override
    public int deleteChargingSettlementByIds(Long[] settlementIds)
    {
        int rows = 0;
        for (Long settlementId : settlementIds)
        {
            rows += chargingSettlementMapper.deleteChargingSettlementById(settlementId);
        }
        return rows;
    }
}
