package com.ruoyi.mine.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.mine.domain.MineStadCarbonLedger;

public interface IStadCarbonLedgerService {
    public MineStadCarbonLedger selectStadCarbonLedgerById(Long ledgerId);
    public List<MineStadCarbonLedger> selectStadCarbonLedgerList(MineStadCarbonLedger ledger);
    public List<MineStadCarbonLedger> selectStadCarbonLedgerByUserId(Long userId);
    public int insertStadCarbonLedger(MineStadCarbonLedger ledger);
    public int updateStadCarbonLedger(MineStadCarbonLedger ledger);
    public int deleteStadCarbonLedgerById(Long ledgerId);
    public int deleteStadCarbonLedgerByIds(Long[] ledgerIds);
    
    /**
     * 获取碳积分概览
     */
    Map<String, Object> getCarbonOverview(Long userId);
    
    /**
     * 获取碳积分获取方式
     */
    List<Map<String, Object>> getCarbonEarnWays();
    
    /**
     * 获取格式化的碳积分记录
     */
    List<Map<String, Object>> getFormattedCarbonRecords(Long userId, MineStadCarbonLedger ledger);
    
    /**
     * 碳积分兑换
     */
    boolean exchangePoints(Long userId, Map<String, Object> data);
    
    /**
     * 获取兑换商品列表
     */
    List<Map<String, Object>> getExchangeProducts();
    
    /**
     * 碳积分签到
     */
    boolean doCheckIn(Long userId);
}
