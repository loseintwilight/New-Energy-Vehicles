package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadChargingSettlementMapper;
import com.ruoyi.business.domain.StadChargingSettlement;
import com.ruoyi.business.service.IStadChargingSettlementService;

@Service
public class StadChargingSettlementServiceImpl implements IStadChargingSettlementService {

    @Autowired
    private StadChargingSettlementMapper stadChargingSettlementMapper;

    @Override
    public StadChargingSettlement selectStadChargingSettlementById(Long settlementId) {
        return stadChargingSettlementMapper.selectStadChargingSettlementById(settlementId);
    }

    @Override
    public List<StadChargingSettlement> selectStadChargingSettlementList(StadChargingSettlement settlement) {
        return stadChargingSettlementMapper.selectStadChargingSettlementList(settlement);
    }

    @Override
    public int insertStadChargingSettlement(StadChargingSettlement settlement) {
        return stadChargingSettlementMapper.insertStadChargingSettlement(settlement);
    }

    @Override
    public int updateStadChargingSettlement(StadChargingSettlement settlement) {
        return stadChargingSettlementMapper.updateStadChargingSettlement(settlement);
    }

    @Override
    public int deleteStadChargingSettlementByIds(Long[] settlementIds) {
        return stadChargingSettlementMapper.deleteStadChargingSettlementByIds(settlementIds);
    }
}