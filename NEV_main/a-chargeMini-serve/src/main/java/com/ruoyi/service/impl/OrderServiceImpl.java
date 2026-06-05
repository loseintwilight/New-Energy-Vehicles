package com.ruoyi.service.impl;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.mapper.OrderMapper;
import com.ruoyi.mapper.PileMapper;
import com.ruoyi.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
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
        List<Map<String, Object>> list = orderMapper.selectOrderList(userId, status, offset, pageSize);
        Long total = orderMapper.selectOrderCount(userId, status);
        Map<String, Object> result = new LinkedHashMap<>();
        // 格式化返回
        for (Map<String, Object> item : list) {
            Object durationObj = item.get("duration");
            if (durationObj instanceof Number) {
                int secs = ((Number) durationObj).intValue();
                int mins = secs / 60;
                item.put("duration", (mins / 60) + "小时" + (mins % 60) + "分");
            }
        }
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
        Map<String, Object> pile = pileMapper.selectPileByPileNo(stationId, pileNo);
        if (pile == null) {
            return AjaxResult.error("充电桩不存在");
        }
        String status = (String) pile.get("status");
        if (!"0".equals(status)) {
            return AjaxResult.error("充电桩不可用");
        }

        // 生成订单并插入数据库
        String orderNo = "ORD" + System.currentTimeMillis();
        Map<String, Object> order = new LinkedHashMap<>();
        order.put("orderNo", orderNo);
        order.put("userId", userId);
        order.put("stationId", stationId);
        order.put("pileNo", pileNo);
        order.put("pileId", pile.get("pileId"));
        order.put("energy", energy != null ? energy : 0);
        order.put("amount", 0);
        order.put("electricPrice", 0);
        order.put("servicePrice", 0);
        orderMapper.insertOrder(order);

        // 更新充电桩状态为充电中
        pileMapper.updatePileStatus((Long) pile.get("pileId"), "1");

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("orderNo", orderNo);
        return AjaxResult.success(data);
    }

    @Override
    public AjaxResult getChargeStatus(String orderNo) {
        Map<String, Object> order = orderMapper.selectOrderByOrderNo(orderNo);
        if (order == null) {
            return AjaxResult.error("订单不存在");
        }
        // 模拟充电状态数据
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("orderId", orderNo);
        data.put("status", order.get("status"));
        data.put("chargePercent", 65);
        data.put("chargedEnergy", "19.5");
        data.put("chargedAmount", "24.96");
        data.put("chargedTime", "45分钟");
        data.put("realTimePower", "36.5");
        data.put("current", 60);
        data.put("voltage", 380);
        data.put("temperature", 42);
        data.put("estimatedEndTime", "14:45");
        data.put("totalEstimate", "38.40");
        data.put("powerHistory", Arrays.asList(0, 12, 28, 36, 35, 32, 30));
        return AjaxResult.success(data);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AjaxResult stopCharge(String orderNo) {
        Map<String, Object> order = orderMapper.selectOrderByOrderNo(orderNo);
        if (order == null) {
            return AjaxResult.error("订单不存在");
        }

        // 计算实际充电数据（模拟）
        long startTimeMs = System.currentTimeMillis() - 45 * 60 * 1000L; // 假设充了45分钟
        int durationSecs = 2700; // 45分钟=2700秒
        double energy = 19.5; // 充了19.5度电
        double electricPrice = 0.88;
        double servicePrice = 0.40;
        double totalAmount = energy * (electricPrice + servicePrice);
        totalAmount = Math.round(totalAmount * 100.0) / 100.0;

        Map<String, Object> params = new LinkedHashMap<>();
        params.put("orderNo", orderNo);
        params.put("duration", durationSecs);
        params.put("energy", energy);
        params.put("totalAmount", totalAmount);
        params.put("electricFee", energy * electricPrice);
        params.put("serviceFee", energy * servicePrice);
        orderMapper.updateOrderForStop(params);

        // 更新充电桩状态为空闲
        Object pileId = order.get("pileId");
        if (pileId instanceof Number) {
            pileMapper.updatePileStatus(((Number) pileId).longValue(), "0");
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("orderNo", orderNo);
        data.put("duration", durationSecs);
        data.put("durationText", "45分钟");
        data.put("energy", energy);
        data.put("chargedAmount", totalAmount);
        data.put("electricFee", energy * electricPrice);
        data.put("serviceFee", energy * servicePrice);
        data.put("total", totalAmount);
        return AjaxResult.success(data);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AjaxResult payOrder(String orderNo, String payMethod) {
        if (orderNo == null) {
            return AjaxResult.error("订单号不能为空");
        }
        Map<String, Object> order = orderMapper.selectOrderByOrderNo(orderNo);
        if (order == null) {
            return AjaxResult.error("订单不存在");
        }
        String payStatus = (String) order.get("payStatus");
        if ("1".equals(payStatus)) {
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
        Map<String, Object> order = orderMapper.selectOrderByOrderNo(orderNo);
        if (order == null) {
            return AjaxResult.error("订单不存在");
        }
        String status = (String) order.get("status");
        if (!"0".equals(status)) {
            return AjaxResult.error("只能取消充电中的订单");
        }
        orderMapper.cancelOrder(orderNo);

        // 恢复充电桩状态
        Object pileId = order.get("pileId");
        if (pileId instanceof Number) {
            pileMapper.updatePileStatus(((Number) pileId).longValue(), "0");
        }

        return AjaxResult.success();
    }
}