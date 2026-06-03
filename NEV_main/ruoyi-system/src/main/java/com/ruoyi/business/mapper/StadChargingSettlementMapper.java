package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadChargingSettlement;

public interface StadChargingSettlementMapper {
    StadChargingSettlement selectStadChargingSettlementById(Long settlementId);
    List<StadChargingSettlement> selectStadChargingSettlementList(StadChargingSettlement settlement);
    int insertStadChargingSettlement(StadChargingSettlement settlement);
    int updateStadChargingSettlement(StadChargingSettlement settlement);
    int deleteStadChargingSettlementById(Long settlementId);
    int deleteStadChargingSettlementByIds(Long[] settlementIds);
}