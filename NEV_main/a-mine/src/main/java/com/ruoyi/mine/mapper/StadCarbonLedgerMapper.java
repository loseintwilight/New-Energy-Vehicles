package com.ruoyi.mine.mapper;

import java.util.List;
import com.ruoyi.mine.domain.MineStadCarbonLedger;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository("mineStadCarbonLedgerMapper")
public interface StadCarbonLedgerMapper {
    public MineStadCarbonLedger selectStadCarbonLedgerById(Long ledgerId);
    public List<MineStadCarbonLedger> selectStadCarbonLedgerList(MineStadCarbonLedger ledger);
    public List<MineStadCarbonLedger> selectStadCarbonLedgerByUserId(Long userId);
    public int insertStadCarbonLedger(MineStadCarbonLedger ledger);
    public int updateStadCarbonLedger(MineStadCarbonLedger ledger);
    public int deleteStadCarbonLedgerById(Long ledgerId);
    public int deleteStadCarbonLedgerByIds(Long[] ledgerIds);
}
