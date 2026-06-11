package com.ruoyi.charging.service;

import com.ruoyi.charging.domain.ChargingSettlement;
import java.util.List;

/**
 * 充电结算Service接口
 *
 * @author ruoyi
 */
public interface IChargingSettlementService
{
    public List<ChargingSettlement> selectChargingSettlementList(ChargingSettlement settlement);

    public ChargingSettlement selectChargingSettlementById(Long settlementId);

    public List<ChargingSettlement> selectChargingSettlementListByMerchantId(Long merchantId);

    public int insertChargingSettlement(ChargingSettlement settlement);

    public int updateChargingSettlement(ChargingSettlement settlement);

    public int deleteChargingSettlementByIds(Long[] settlementIds);
}
