package com.ruoyi.service.impl;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.mapper.OrderMapper;
import com.ruoyi.mapper.PileMapper;
import com.ruoyi.mapper.StationMapper;
import com.ruoyi.service.OrderService;
import com.ruoyi.vo.OrderVO;
import com.ruoyi.vo.PileVO;
import com.ruoyi.vo.RateVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalTime;
import java.util.*;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private PileMapper pileMapper;

    @Autowired
    private StationMapper stationMapper;

    @Override
    public AjaxResult getOrderList(Long userId, String status, Integer pageNum, Integer pageSize) {
        if (userId == null) {
            return AjaxResult.error("用户未登录");
        }
        int offset = (pageNum - 1) * pageSize;
        List<OrderVO> list = orderMapper.selectOrderList(userId, status, offset, pageSize);
        Long total = orderMapper.selectOrderCount(userId, status);

        // 格式化返回数据
        for (OrderVO item : list) {
            if (item.getDuration() != null) {
                int secs = item.getDuration();
                int hours = secs / 3600;
                int mins = (secs % 3600) / 60;
                if (hours > 0) {
                    item.setDurationText(hours + "小时" + mins + "分");
                } else {
                    item.setDurationText(mins + "分");
                }
            }
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("rows", list);
        result.put("total", total);
        return AjaxResult.success(result);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AjaxResult startCharge(Long userId, Long stationId, String pileNo, Double energy, Integer soc) {
        if (userId == null) {
            return AjaxResult.error("用户未登录");
        }
        if (stationId == null || pileNo == null) {
            return AjaxResult.error("参数不完整");
        }

        // 查询充电桩
        PileVO pile = pileMapper.selectPileByPileNo(stationId, pileNo);
        if (pile == null) {
            return AjaxResult.error("充电桩不存在");
        }
        if (!"0".equals(pile.getPileStatus())) {
            return AjaxResult.error("充电桩不可用");
        }

        // 查询充电站费率 查找当前时段单价
        String pileType = pile.getPileType() != null ? pile.getPileType() : "dc";
        List<RateVO> rates = stationMapper.selectRatesByStationId(stationId);
        Long matchedRateId = null;
        Long matchedPeriodId = null;
        Double electricPrice = null;
        Double servicePrice = null;
        Double totalPrice = null;

        if (rates != null && !rates.isEmpty()) {
            for (RateVO rate : rates) {
                // 匹配费率组：pileType 一致或为 all
                if (rate.getPileType() == null) continue;
                String rt = rate.getPileType().trim();
                if (!rt.equals(pileType) && !rt.equals("all")) continue;

                matchedRateId = rate.getRateId();
                if (rate.getStartTime() == null || rate.getEndTime() == null) continue;

                try {
                    // 判断当前时间是否在时段内（支持跨天，如 22:00-07:00）
                    LocalTime now = LocalTime.now();
                    LocalTime start = LocalTime.parse(rate.getStartTime().substring(0, 5));
                    // 处理 end_time = '24:00' 的情况（等同 23:59:59）
                    String endStr = rate.getEndTime().substring(0, 5);
                    LocalTime end = "24:00".equals(endStr) ? LocalTime.MAX : LocalTime.parse(endStr);
                    boolean inPeriod;
                    if (end.isAfter(start)) {
                        inPeriod = !now.isBefore(start) && now.isBefore(end);
                    } else {
                        // 跨天时段（如 22:00-07:00）
                        inPeriod = !now.isBefore(start) || now.isBefore(end);
                    }
                    if (inPeriod) {
                        matchedPeriodId = rate.getPeriodId();
                        electricPrice = rate.getElectricPrice() != null ? rate.getElectricPrice() : 0D;
                        servicePrice = rate.getServicePrice() != null ? rate.getServicePrice() : 0D;
                        totalPrice = rate.getTotalPrice() != null ? rate.getTotalPrice() : (electricPrice + servicePrice);
                        break;  // 找到第一个匹配时段即停止
                    }
                } catch (Exception e) {
                    // 时间解析失败，跳过该时段
                    continue;
                }
            }
        }

        // ⭐ 兜底：如果费率查找失败，使用站点默认价格（0.35元/度电费 + 0.55元/度服务费 = 0.90元/度）
        if (electricPrice == null) electricPrice = 0.35D;
        if (servicePrice == null) servicePrice = 0.55D;
        if (totalPrice == null) totalPrice = electricPrice + servicePrice;

        // 生成订单
        String orderNo = "CO" + System.currentTimeMillis();
        Map<String, Object> order = new LinkedHashMap<>();
        order.put("orderNo", orderNo);
        order.put("userId", userId);
        order.put("stationId", stationId);
        order.put("pileNo", pileNo);
        order.put("pileId", pile.getPileId());
        order.put("energy", energy != null ? energy : 0);
        order.put("amount", 0);
        order.put("electricPrice", electricPrice);
        order.put("servicePrice", servicePrice);
        order.put("rateId", matchedRateId);
        order.put("ratePeriodId", matchedPeriodId);
        orderMapper.insertOrder(order);

        // 更新充电桩状态为充电中
        pileMapper.updatePileStatus(pile.getPileId(), "1");
        // 同步更新充电站表的可用/占用桩数
        stationMapper.syncStationPileCounts(stationId);

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("orderNo", orderNo);
        data.put("electricPrice", electricPrice);
        data.put("servicePrice", servicePrice);
        data.put("totalPrice", totalPrice);
        return AjaxResult.success(data);
    }

    @Override
    public AjaxResult getChargeStatus(String orderNo) {
        OrderVO order = orderMapper.selectOrderByOrderNo(orderNo);
        if (order == null) {
            return AjaxResult.error("订单不存在");
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("orderId", orderNo);
        data.put("status", order.getStatus());
        data.put("orderNo", order.getOrderNo());
        data.put("stationName", order.getStationName());
        data.put("pileNo", order.getPileNo());
        data.put("chargeType", order.getChargeType());
        data.put("startTime", order.getStartTime());
        data.put("endTime", order.getEndTime());

        String status = order.getStatus();
        Double targetEnergy = order.getEnergy() != null ? order.getEnergy() : 0D;
        Double electricUnitPrice = order.getElectricFee() != null ? order.getElectricFee() : 0D;
        Double serviceUnitPrice = order.getServiceFee() != null ? order.getServiceFee() : 0D;

        // 计算充电时长
        int durationSecs = 0;
        if (order.getStartTime() != null) {
            durationSecs = (int) ((System.currentTimeMillis() - order.getStartTime().getTime()) / 1000);
            if (durationSecs < 0) durationSecs = 0;
        }

        // 测试模式下：5秒充满
        final int TEST_FULL_CHARGE_SECS = 5;
        int chargePercent;
        double actualEnergy;
        String chargedTime;

        if ("1".equals(status) || "2".equals(status)) {
            // 已完成或已取消
            chargePercent = 100;
            actualEnergy = targetEnergy;
        } else {
            // 充电中：按时间比例计算进度
            chargePercent = Math.min(99, (int)(durationSecs * 100.0 / TEST_FULL_CHARGE_SECS));
            actualEnergy = targetEnergy * chargePercent / 100.0;

            // 达到5秒自动完成充电
            if (durationSecs >= TEST_FULL_CHARGE_SECS) {
                double electricFee, serviceFee;
                if (electricUnitPrice < 10 && serviceUnitPrice < 10) {
                    electricFee = Math.round(targetEnergy * electricUnitPrice * 100.0) / 100.0;
                    serviceFee = Math.round(targetEnergy * serviceUnitPrice * 100.0) / 100.0;
                } else {
                    electricFee = electricUnitPrice;
                    serviceFee = serviceUnitPrice;
                }
                double totalAmount = Math.round((electricFee + serviceFee) * 100.0) / 100.0;

                Map<String, Object> params = new LinkedHashMap<>();
                params.put("orderNo", orderNo);
                params.put("duration", durationSecs);
                params.put("energy", targetEnergy);
                params.put("totalAmount", totalAmount);
                params.put("electricFee", electricFee);
                params.put("serviceFee", serviceFee);
                orderMapper.updateOrderForStop(params);

                // 释放充电桩
                String pileNo = order.getPileNo();
                if (pileNo != null && order.getStationId() != null) {
                    PileVO pile = pileMapper.selectPileByPileNo(order.getStationId(), pileNo);
                    if (pile != null) {
                        pileMapper.updatePileStatus(pile.getPileId(), "0");
                        // 同步更新充电站表的可用/占用桩数
                        stationMapper.syncStationPileCounts(order.getStationId());
                    }
                }

                data.put("status", "1");
                chargePercent = 100;
                // 用目标电量计算费用
                actualEnergy = targetEnergy;
            }
        }

        // 格式化充电时长
        if (durationSecs < 60) {
            chargedTime = durationSecs + "秒";
        } else {
            int hours = durationSecs / 3600;
            int mins = (durationSecs % 3600) / 60;
            chargedTime = (hours > 0 ? hours + "小时" + mins + "分" : mins + "分");
        }

        // 计算已充金额
        double chargedAmount = 0;
        double electricFee = 0;
        double serviceFee = 0;
        if (electricUnitPrice < 10 && serviceUnitPrice < 10) {
            electricFee = Math.round(actualEnergy * electricUnitPrice * 100.0) / 100.0;
            serviceFee = Math.round(actualEnergy * serviceUnitPrice * 100.0) / 100.0;
        }
        chargedAmount = Math.round((electricFee + serviceFee) * 100.0) / 100.0;

        data.put("chargedTime", chargedTime);
        data.put("chargedEnergy", String.format("%.1f", actualEnergy));
        data.put("chargedAmount", String.format("%.2f", chargedAmount));
        data.put("electricFee", String.format("%.2f", electricFee));
        data.put("serviceFee", String.format("%.2f", serviceFee));
        data.put("totalEstimate", String.format("%.2f", chargedAmount));
        data.put("chargePercent", chargePercent);

        return AjaxResult.success(data);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AjaxResult stopCharge(String orderNo) {
        OrderVO order = orderMapper.selectOrderByOrderNo(orderNo);
        if (order == null) {
            return AjaxResult.error("订单不存在");
        }

        // 如果订单已完成或已取消，直接返回成功（避免重复操作）
        if (!"0".equals(order.getStatus())) {
            Map<String, Object> data = new LinkedHashMap<>();
            data.put("orderNo", orderNo);
            data.put("chargedAmount", order.getAmount() != null ? order.getAmount() : 0D);
            data.put("energy", order.getEnergy() != null ? order.getEnergy() : 0D);
            data.put("electricFee", order.getElectricFee() != null ? order.getElectricFee() : 0D);
            data.put("serviceFee", order.getServiceFee() != null ? order.getServiceFee() : 0D);
            data.put("total", order.getAmount() != null ? order.getAmount() : 0D);
            int d = order.getDuration() != null ? order.getDuration() : 0;
            data.put("duration", d);
            data.put("durationText", (d / 60) + "分");
            return AjaxResult.success(data);
        }

        // 计算实际充电量：按时间比例（5秒充满测试模式）
        Double targetEnergy = order.getEnergy() != null ? order.getEnergy() : 0D;
        Double electricUnitPrice = order.getElectricFee() != null ? order.getElectricFee() : 0D;
        Double serviceUnitPrice = order.getServiceFee() != null ? order.getServiceFee() : 0D;

        int durationSecs = 0;
        if (order.getStartTime() != null) {
            durationSecs = (int) ((System.currentTimeMillis() - order.getStartTime().getTime()) / 1000);
            if (durationSecs < 0) durationSecs = 0;
        }

        // 根据已过时间计算实际充电量
        double progress = Math.min(1.0, durationSecs / 5.0);
        double actualEnergy = Math.round(targetEnergy * progress * 10.0) / 10.0;
        if (actualEnergy < 0.1) actualEnergy = 0.1; // 至少0.1度

        // 计算费用
        Double electricFee, serviceFee;
        if (electricUnitPrice < 10 && serviceUnitPrice < 10) {
            electricFee = Math.round(actualEnergy * electricUnitPrice * 100.0) / 100.0;
            serviceFee = Math.round(actualEnergy * serviceUnitPrice * 100.0) / 100.0;
        } else {
            electricFee = electricUnitPrice;
            serviceFee = serviceUnitPrice;
        }
        Double totalAmount = Math.round((electricFee + serviceFee) * 100.0) / 100.0;

        Map<String, Object> params = new LinkedHashMap<>();
        params.put("orderNo", orderNo);
        params.put("duration", durationSecs);
        params.put("energy", actualEnergy);
        params.put("totalAmount", totalAmount);
        params.put("electricFee", electricFee);
        params.put("serviceFee", serviceFee);
        orderMapper.updateOrderForStop(params);

        // 更新充电桩状态为空闲，同步更新充电站表的可用/占用桩数
        String pileNo = order.getPileNo();
        if (pileNo != null && order.getStationId() != null) {
            PileVO pile = pileMapper.selectPileByPileNo(order.getStationId(), pileNo);
            if (pile != null) {
                pileMapper.updatePileStatus(pile.getPileId(), "0");
                stationMapper.syncStationPileCounts(order.getStationId());
            }
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("orderNo", orderNo);
        data.put("duration", durationSecs);
        int hours = durationSecs / 3600;
        int mins = (durationSecs % 3600) / 60;
        data.put("durationText", hours > 0 ? hours + "小时" + mins + "分" : mins + "分");
        data.put("energy", actualEnergy);
        data.put("chargedAmount", totalAmount);
        data.put("electricFee", electricFee);
        data.put("serviceFee", serviceFee);
        data.put("total", totalAmount);
        return AjaxResult.success(data);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AjaxResult payOrder(String orderNo, String payMethod) {
        if (orderNo == null) {
            return AjaxResult.error("订单号不能为空");
        }
        OrderVO order = orderMapper.selectOrderByOrderNo(orderNo);
        if (order == null) {
            return AjaxResult.error("订单不存在");
        }
        if ("1".equals(order.getPayStatus())) {
            return AjaxResult.error("订单已支付");
        }
        orderMapper.updateOrderPay(orderNo, "1", payMethod);
        return AjaxResult.success();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AjaxResult cancelOrder(String orderNo) {
        if (orderNo == null) {
            return AjaxResult.error("订单号不能为空");
        }
        OrderVO order = orderMapper.selectOrderByOrderNo(orderNo);
        if (order == null) {
            return AjaxResult.error("订单不存在");
        }
        if (!"0".equals(order.getStatus())) {
            return AjaxResult.error("只能取消充电中的订单");
        }
        orderMapper.cancelOrder(orderNo);

        // 恢复充电桩状态，同步更新充电站表的可用/占用桩数
        String pileNo = order.getPileNo();
        if (pileNo != null && order.getStationId() != null) {
            PileVO pile = pileMapper.selectPileByPileNo(order.getStationId(), pileNo);
            if (pile != null) {
                pileMapper.updatePileStatus(pile.getPileId(), "0");
                stationMapper.syncStationPileCounts(order.getStationId());
            }
        }

        return AjaxResult.success();
    }
}