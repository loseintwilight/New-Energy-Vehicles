package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadChargingSettlement;

public interface IStadChargingSettlementService {
    StadChargingSettlement selectStadChargingSettlementById(Long settlementId);
    List<StadChargingSettlement> selectStadChargingSettlementList(StadChargingSettlement settlement);
    int insertStadChargingSettlement(StadChargingSettlement settlement);
    int updateStadChargingSettlement(StadChargingSettlement settlement);
    int deleteStadChargingSettlementByIds(Long[] settlementIds);
}