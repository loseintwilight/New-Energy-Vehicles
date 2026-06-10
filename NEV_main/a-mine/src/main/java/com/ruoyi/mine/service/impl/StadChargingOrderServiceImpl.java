package com.ruoyi.mine.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import com.ruoyi.mine.mapper.StadChargingOrderMapper;
import com.ruoyi.mine.domain.MineStadChargingOrder;
import com.ruoyi.mine.service.IStadChargingOrderService;
import com.ruoyi.mine.vo.ChargingOrderListVO;

@Service("mineStadChargingOrderServiceImpl")
public class StadChargingOrderServiceImpl implements IStadChargingOrderService {

    @Autowired
    @Qualifier("mineStadChargingOrderMapper")
    private StadChargingOrderMapper stadChargingOrderMapper;

    @Override
    public MineStadChargingOrder selectStadChargingOrderById(Long orderId) {
        return stadChargingOrderMapper.selectStadChargingOrderById(orderId);
    }

    @Override
    public List<MineStadChargingOrder> selectStadChargingOrderList(MineStadChargingOrder order) {
        return stadChargingOrderMapper.selectStadChargingOrderList(order);
    }

    @Override
    public int insertStadChargingOrder(MineStadChargingOrder order) {
        return stadChargingOrderMapper.insertStadChargingOrder(order);
    }

    @Override
    public int updateStadChargingOrder(MineStadChargingOrder order) {
        return stadChargingOrderMapper.updateStadChargingOrder(order);
    }

    @Override
    public int deleteStadChargingOrderById(Long orderId) {
        return stadChargingOrderMapper.deleteStadChargingOrderById(orderId);
    }

    @Override
    public int deleteStadChargingOrderByIds(Long[] orderIds) {
        return stadChargingOrderMapper.deleteStadChargingOrderByIds(orderIds);
    }

    @Override
    public List<ChargingOrderListVO> selectFormattedChargingOrderList(MineStadChargingOrder order) {
        List<MineStadChargingOrder> list = stadChargingOrderMapper.selectStadChargingOrderList(order);
        List<ChargingOrderListVO> voList = new ArrayList<>();
        for (MineStadChargingOrder item : list) {
            voList.add(convertToVO(item));
        }
        return voList;
    }

    @Override
    public ChargingOrderListVO selectFormattedChargingOrderDetail(Long orderId) {
        MineStadChargingOrder item = stadChargingOrderMapper.selectStadChargingOrderById(orderId);
        if (item == null) return null;
        return convertToVO(item);
    }

    @Override
    public Map<String, Object> getChargingStatistics(Long userId) {
        Map<String, Object> stats = new HashMap<>();
        // 使用 Mapper 统计数据
        List<Map<String, Object>> rawStats = stadChargingOrderMapper.selectChargingStatisticsByUserId(userId);
        if (rawStats != null && !rawStats.isEmpty()) {
            Map<String, Object> row = rawStats.get(0);
            stats.put("count", row.get("totalCount") != null ? row.get("totalCount") : 0);
            stats.put("totalEnergy", row.get("totalEnergy") != null ? row.get("totalEnergy") : BigDecimal.ZERO);
            stats.put("totalAmount", row.get("totalAmount") != null ? row.get("totalAmount") : BigDecimal.ZERO);
        } else {
            stats.put("count", 0);
            stats.put("totalEnergy", BigDecimal.ZERO);
            stats.put("totalAmount", BigDecimal.ZERO);
        }
        return stats;
    }

    /**
     * 将实体转换为VO（格式化时长等）
     */
    private ChargingOrderListVO convertToVO(MineStadChargingOrder item) {
        ChargingOrderListVO vo = new ChargingOrderListVO();
        vo.setOrderId(item.getOrderId());
        vo.setOrderNo(item.getOrderNo());
        vo.setStationName(item.getStationName());
        vo.setAddress(item.getAddress());
        vo.setStartTime(item.getStartTime());
        vo.setEndTime(item.getEndTime());
        vo.setDuration(item.getDuration());
        // 格式化时长：秒 -> 时:分:秒
        Integer duration = item.getDuration();
        if (duration == null || duration == 0) {
            // 如果库中duration为0或null，用开始结束时间计算
            if (item.getStartTime() != null && item.getEndTime() != null) {
                long diff = item.getEndTime().getTime() - item.getStartTime().getTime();
                if (diff > 0) {
                    duration = (int) (diff / 1000);
                    vo.setDuration(duration);
                }
            }
        }
        if (duration != null && duration > 0) {
            int seconds = duration;
            int h = seconds / 3600;
            int m = (seconds % 3600) / 60;
            int s = seconds % 60;
            StringBuilder sb = new StringBuilder();
            if (h > 0) sb.append(h).append("时");
            if (m > 0) sb.append(m).append("分");
            sb.append(s).append("秒");
            vo.setDurationText(sb.toString());
        } else {
            vo.setDurationText("--");
        }
        vo.setTotalEnergy(item.getTotalEnergy());
        vo.setEnergyPrice(item.getEnergyPrice());
        vo.setServicePrice(item.getServicePrice());
        vo.setTotalAmount(item.getTotalAmount());
        vo.setOrderStatus(item.getOrderStatus());
        vo.setPayStatus(item.getPayStatus());
        vo.setPaymentMethod(item.getPaymentMethod());
        vo.setCreateTime(item.getCreateTime());
        return vo;
    }
}