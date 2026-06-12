package com.ruoyi.mine.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.mine.mapper.StadCarbonLedgerMapper;
import com.ruoyi.mine.domain.MineStadCarbonLedger;
import com.ruoyi.mine.domain.MineStadUserProfile;
import com.ruoyi.mine.service.IStadCarbonLedgerService;
import com.ruoyi.mine.service.IStadUserProfileService;

@Service("mineStadCarbonLedgerServiceImpl")
public class StadCarbonLedgerServiceImpl implements IStadCarbonLedgerService {

    @Autowired
    @Qualifier("mineStadCarbonLedgerMapper")
    private StadCarbonLedgerMapper stadCarbonLedgerMapper;
    
    @Autowired
    private IStadUserProfileService stadUserProfileService;

    @Override
    public MineStadCarbonLedger selectStadCarbonLedgerById(Long ledgerId) {
        return stadCarbonLedgerMapper.selectStadCarbonLedgerById(ledgerId);
    }

    @Override
    public List<MineStadCarbonLedger> selectStadCarbonLedgerList(MineStadCarbonLedger ledger) {
        return stadCarbonLedgerMapper.selectStadCarbonLedgerList(ledger);
    }

    @Override
    public List<MineStadCarbonLedger> selectStadCarbonLedgerByUserId(Long userId) {
        return stadCarbonLedgerMapper.selectStadCarbonLedgerByUserId(userId);
    }

    @Override
    public int insertStadCarbonLedger(MineStadCarbonLedger ledger) {
        return stadCarbonLedgerMapper.insertStadCarbonLedger(ledger);
    }

    @Override
    public int updateStadCarbonLedger(MineStadCarbonLedger ledger) {
        return stadCarbonLedgerMapper.updateStadCarbonLedger(ledger);
    }

    @Override
    public int deleteStadCarbonLedgerById(Long ledgerId) {
        return stadCarbonLedgerMapper.deleteStadCarbonLedgerById(ledgerId);
    }

    @Override
    public int deleteStadCarbonLedgerByIds(Long[] ledgerIds) {
        return stadCarbonLedgerMapper.deleteStadCarbonLedgerByIds(ledgerIds);
    }

    @Override
    public Map<String, Object> getCarbonOverview(Long userId) {
        Map<String, Object> overview = new HashMap<>();
        
        MineStadUserProfile profile = stadUserProfileService.selectStadUserProfileById(userId);
        if (profile != null) {
            overview.put("points", profile.getBalance());
            overview.put("totalEarned", profile.getTotalEarned());
            overview.put("totalSpent", profile.getTotalSpent());
            overview.put("earnedPoints", profile.getTotalEarned());
            overview.put("spentPoints", profile.getTotalSpent());
            overview.put("redeemedPoints", 0);
            overview.put("totalReduction", profile.getBalance() * 0.05);
        } else {
            overview.put("points", 0);
            overview.put("totalEarned", 0);
            overview.put("totalSpent", 0);
            overview.put("earnedPoints", 0);
            overview.put("spentPoints", 0);
            overview.put("redeemedPoints", 0);
            overview.put("totalReduction", 0);
        }
        
        return overview;
    }

    @Override
    public List<Map<String, Object>> getCarbonEarnWays() {
        List<Map<String, Object>> ways = new ArrayList<>();

        Map<String, Object> way1 = new HashMap<>();
        way1.put("type", "charge");
        way1.put("name", "充电获得");
        way1.put("desc", "订单支付后每1kWh获得10积分");
        way1.put("points", 10);
        ways.add(way1);

        Map<String, Object> way2 = new HashMap<>();
        way2.put("type", "checkin");
        way2.put("name", "每日签到");
        way2.put("desc", "每日签到获得5积分");
        way2.put("points", 5);
        ways.add(way2);

        Map<String, Object> way3 = new HashMap<>();
        way3.put("type", "purchase");
        way3.put("name", "购车获得");
        way3.put("desc", "支付完成后一次性获得500积分");
        way3.put("points", 500);
        ways.add(way3);

        Map<String, Object> way4 = new HashMap<>();
        way4.put("type", "read");
        way4.put("name", "阅读获得");
        way4.put("desc", "阅读环保文章获得积分");
        way4.put("points", 2);
        ways.add(way4);

        return ways;
    }

    @Override
    public List<Map<String, Object>> getFormattedCarbonRecords(Long userId, MineStadCarbonLedger ledger) {
        ledger.setUserId(userId);
        List<MineStadCarbonLedger> list = selectStadCarbonLedgerList(ledger);

        List<Map<String, Object>> resultList = new ArrayList<>();
        for (MineStadCarbonLedger item : list) {
            Map<String, Object> map = new HashMap<>();
            map.put("ledger_id", item.getLedgerId());
            map.put("user_id", item.getUserId());
            map.put("record_type", item.getRecordType());
            map.put("rule_id", item.getRuleId());
            map.put("points", item.getPoints());
            map.put("balance_after", item.getBalanceAfter());
            map.put("source_type", item.getSourceType());
            map.put("source_id", item.getSourceId());
            map.put("remark", item.getRemark());
            map.put("create_time", item.getCreateTime());
            resultList.add(map);
        }
        
        return resultList;
    }

    @Override
    public boolean exchangePoints(Long userId, Map<String, Object> data) {
        return false;
    }

    @Override
    public List<Map<String, Object>> getExchangeProducts() {
        List<Map<String, Object>> products = new ArrayList<>();
        
        Map<String, Object> product1 = new HashMap<>();
        product1.put("id", 1);
        product1.put("name", "充电优惠券");
        product1.put("points", 100);
        product1.put("description", "满50减10");
        product1.put("image", "");
        products.add(product1);

        Map<String, Object> product2 = new HashMap<>();
        product2.put("id", 2);
        product2.put("name", "洗车服务");
        product2.put("points", 200);
        product2.put("description", "免费洗车一次");
        product2.put("image", "");
        products.add(product2);

        return products;
    }

    @Override
    @Transactional
    public boolean doCheckIn(Long userId) {
        MineStadCarbonLedger ledger = new MineStadCarbonLedger();
        ledger.setUserId(userId);
        ledger.setRecordType(0);
        ledger.setPoints(5);
        ledger.setSourceType(3);
        ledger.setRemark("每日签到");
        insertStadCarbonLedger(ledger);

        MineStadUserProfile profile = stadUserProfileService.selectStadUserProfileById(userId);
        if (profile != null) {
            profile.setTotalEarned(profile.getTotalEarned() + 5);
            profile.setBalance(profile.getBalance() + 5);
            stadUserProfileService.updateStadUserProfile(profile);
        } else {
            profile = new MineStadUserProfile();
            profile.setUserId(userId);
            profile.setTotalEarned(5);
            profile.setTotalSpent(0);
            profile.setBalance(5);
            stadUserProfileService.insertStadUserProfile(profile);
        }
        
        return true;
    }
}
