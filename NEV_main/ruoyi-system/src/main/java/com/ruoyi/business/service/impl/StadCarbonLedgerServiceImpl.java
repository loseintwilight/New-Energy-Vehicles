package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadCarbonLedgerMapper;
import com.ruoyi.business.domain.StadCarbonLedger;
import com.ruoyi.business.service.IStadCarbonLedgerService;

@Service
public class StadCarbonLedgerServiceImpl implements IStadCarbonLedgerService {

    @Autowired
    private StadCarbonLedgerMapper stadCarbonLedgerMapper;

    @Override
    public StadCarbonLedger selectStadCarbonLedgerById(Long ledgerId) {
        return stadCarbonLedgerMapper.selectStadCarbonLedgerById(ledgerId);
    }

    @Override
    public List<StadCarbonLedger> selectStadCarbonLedgerList(StadCarbonLedger ledger) {
        return stadCarbonLedgerMapper.selectStadCarbonLedgerList(ledger);
    }

    @Override
    public List<StadCarbonLedger> selectStadCarbonLedgerByUserId(Long userId) {
        return stadCarbonLedgerMapper.selectStadCarbonLedgerByUserId(userId);
    }

    @Override
    public int insertStadCarbonLedger(StadCarbonLedger ledger) {
        return stadCarbonLedgerMapper.insertStadCarbonLedger(ledger);
    }

    @Override
    public int updateStadCarbonLedger(StadCarbonLedger ledger) {
        return stadCarbonLedgerMapper.updateStadCarbonLedger(ledger);
    }

    @Override
    public int deleteStadCarbonLedgerByIds(Long[] ledgerIds) {
        return stadCarbonLedgerMapper.deleteStadCarbonLedgerByIds(ledgerIds);
    }
}