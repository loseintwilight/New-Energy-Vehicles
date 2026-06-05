package com.ruoyi.service.impl;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.mapper.OrderMapper;
import com.ruoyi.mapper.PileMapper;
import com.ruoyi.service.OrderService;
import com.ruoyi.vo.OrderVO;
import com.ruoyi.vo.PileVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private PileMapper pileMapper;

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

        // 生成订单并插入数据库
        String orderNo = "ORD" + System.currentTimeMillis();
        Map<String, Object> order = new LinkedHashMap<>();
        order.put("orderNo", orderNo);
        order.put("userId", userId);
        order.put("stationId", stationId);
        order.put("pileNo", pileNo);
        order.put("pileId", pile.getPileId());
        order.put("energy", energy != null ? energy : 0);
        order.put("amount", 0);
        order.put("electricPrice", 0);
        order.put("servicePrice", 0);
        orderMapper.insertOrder(order);

        // 更新充电桩状态为充电中
        pileMapper.updatePileStatus(pile.getPileId(), "1");

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("orderNo", orderNo);
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

        // 从数据库读取实际充电数据
        if (order.getDuration() != null) {
            int secs = order.getDuration();
            int hours = secs / 3600;
            int mins = (secs % 3600) / 60;
            data.put("chargedTime", hours > 0 ? hours + "小时" + mins + "分" : mins + "分");
        } else {
            data.put("chargedTime", "0分");
        }

        data.put("chargedEnergy", order.getEnergy() != null ? order.getEnergy().toString() : "0");
        data.put("chargedAmount", order.getAmount() != null ? order.getAmount().toString() : "0.00");
        data.put("electricFee", order.getElectricFee() != null ? order.getElectricFee().toString() : "0.00");
        data.put("serviceFee", order.getServiceFee() != null ? order.getServiceFee().toString() : "0.00");
        data.put("totalEstimate", order.getAmount() != null ? order.getAmount().toString() : "0.00");

        // 充电进度：根据实际数据估算
        if ("1".equals(order.getStatus()) || "2".equals(order.getStatus())) {
            data.put("chargePercent", 100);
        } else {
            // 充电中按时间估算进度
            data.put("chargePercent", 0);
        }

        return AjaxResult.success(data);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AjaxResult stopCharge(String orderNo) {
        OrderVO order = orderMapper.selectOrderByOrderNo(orderNo);
        if (order == null) {
            return AjaxResult.error("订单不存在");
        }

        if (!"0".equals(order.getStatus())) {
            return AjaxResult.error("订单不是充电中状态");
        }

        // 从数据库读取费率计算实际充电费用
        Double energy = order.getEnergy() != null ? order.getEnergy() : 0D;
        Double electricFee = order.getElectricFee() != null ? order.getElectricFee() : 0D;
        Double serviceFee = order.getServiceFee() != null ? order.getServiceFee() : 0D;
        Double totalAmount = electricFee + serviceFee;

        // 计算充电时长
        int durationSecs = 0;
        if (order.getStartTime() != null) {
            durationSecs = (int) ((System.currentTimeMillis() - order.getStartTime().getTime()) / 1000);
            if (durationSecs < 0) durationSecs = 0;
        }

        Map<String, Object> params = new LinkedHashMap<>();
        params.put("orderNo", orderNo);
        params.put("duration", durationSecs);
        params.put("energy", energy);
        params.put("totalAmount", totalAmount);
        params.put("electricFee", electricFee);
        params.put("serviceFee", serviceFee);
        orderMapper.updateOrderForStop(params);

        // 更新充电桩状态为空闲
        String pileNo = order.getPileNo();
        if (pileNo != null && order.getStationId() != null) {
            PileVO pile = pileMapper.selectPileByPileNo(order.getStationId(), pileNo);
            if (pile != null) {
                pileMapper.updatePileStatus(pile.getPileId(), "0");
            }
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("orderNo", orderNo);
        data.put("duration", durationSecs);
        int hours = durationSecs / 3600;
        int mins = (durationSecs % 3600) / 60;
        data.put("durationText", hours > 0 ? hours + "小时" + mins + "分" : mins + "分");
        data.put("energy", energy);
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

        // 恢复充电桩状态
        String pileNo = order.getPileNo();
        if (pileNo != null && order.getStationId() != null) {
            PileVO pile = pileMapper.selectPileByPileNo(order.getStationId(), pileNo);
            if (pile != null) {
                pileMapper.updatePileStatus(pile.getPileId(), "0");
            }
        }

        return AjaxResult.success();
    }
}