package com.ruoyi.charging.mapper;

import com.ruoyi.charging.domain.ChargingSettlement;
import java.util.List;

/**
 * 充电结算Mapper接口
 * 
 * @author ruoyi
 */
public interface ChargingSettlementMapper 
{
    public ChargingSettlement selectChargingSettlementById(Long settlementId);

    public List<ChargingSettlement> selectChargingSettlementList(ChargingSettlement settlement);

    public List<ChargingSettlement> selectChargingSettlementListByMerchantId(Long merchantId);

    public int insertChargingSettlement(ChargingSettlement settlement);

    public int updateChargingSettlement(ChargingSettlement settlement);

    public int deleteChargingSettlementById(Long settlementId);
}
