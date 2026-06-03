package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadCarbonLedger;

public interface StadCarbonLedgerMapper {
    StadCarbonLedger selectStadCarbonLedgerById(Long ledgerId);
    List<StadCarbonLedger> selectStadCarbonLedgerList(StadCarbonLedger ledger);
    List<StadCarbonLedger> selectStadCarbonLedgerByUserId(Long userId);
    int insertStadCarbonLedger(StadCarbonLedger ledger);
    int updateStadCarbonLedger(StadCarbonLedger ledger);
    int deleteStadCarbonLedgerById(Long ledgerId);
    int deleteStadCarbonLedgerByIds(Long[] ledgerIds);
}