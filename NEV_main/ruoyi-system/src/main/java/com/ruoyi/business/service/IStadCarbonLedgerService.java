package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadCarbonLedger;

public interface IStadCarbonLedgerService {
    StadCarbonLedger selectStadCarbonLedgerById(Long ledgerId);
    List<StadCarbonLedger> selectStadCarbonLedgerList(StadCarbonLedger ledger);
    List<StadCarbonLedger> selectStadCarbonLedgerByUserId(Long userId);
    int insertStadCarbonLedger(StadCarbonLedger ledger);
    int updateStadCarbonLedger(StadCarbonLedger ledger);
    int deleteStadCarbonLedgerByIds(Long[] ledgerIds);
}