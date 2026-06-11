package com.ruoyi.web.controller.mine;

import com.ruoyi.mine.domain.MineStadChargingOrder;
import com.ruoyi.mine.domain.MineStadUnifiedOrder;
import com.ruoyi.mine.service.IStadChargingOrderService;
import com.ruoyi.mine.service.IStadUnifiedOrderService;
import com.ruoyi.mine.vo.OrderListVO;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.business.domain.StadMaintenanceOrder;
import com.ruoyi.business.service.IStadMaintenanceOrderService;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 小程序订单管理（合并购车订单、充电订单、维保订单）
 */
@RestController
@RequestMapping("/app/order")
public class AppOrderController extends BaseController {

    @Autowired
    private IStadUnifiedOrderService stadUnifiedOrderService;

    @Autowired
    private IStadChargingOrderService stadChargingOrderService;

    @Autowired
    private IStadMaintenanceOrderService stadMaintenanceOrderService;

    // ==================== 订单状态文字映射 ====================
    private static final Map<String, String> STATUS_TEXT = new HashMap<>();
    static {
        STATUS_TEXT.put("0", "待支付");
        STATUS_TEXT.put("1", "待服务");
        STATUS_TEXT.put("2", "已完成");
        STATUS_TEXT.put("3", "已取消");
    }

    // ==================== 订单类型标签映射 ====================
    private static final Map<String, String> UNIFIED_TYPE_LABEL = new HashMap<>();
    static {
        UNIFIED_TYPE_LABEL.put("purchase", "购车");
        UNIFIED_TYPE_LABEL.put("test_drive", "试驾");
        UNIFIED_TYPE_LABEL.put("trade_in", "置换");
    }

    /**
     * 获取订单列表（合并统一订单 + 充电订单 + 维保订单）
     */
    @GetMapping("/list")
    public AjaxResult getOrderList(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String status) {
        Long userId = SecurityUtils.getUserId();
        List<OrderListVO> combined = new ArrayList<>();

        // 1. 统一订单（购车/试驾/以旧换新）
        MineStadUnifiedOrder unifiedQuery = new MineStadUnifiedOrder();
        unifiedQuery.setUserId(userId);
        for (MineStadUnifiedOrder o : stadUnifiedOrderService.selectStadUnifiedOrderList(unifiedQuery)) {
            combined.add(buildFromUnified(o));
        }

        // 2. 充电订单
        MineStadChargingOrder chargeQuery = new MineStadChargingOrder();
        chargeQuery.setUserId(userId);
        for (MineStadChargingOrder o : stadChargingOrderService.selectStadChargingOrderList(chargeQuery)) {
            combined.add(buildFromCharging(o));
        }

        // 3. 维保订单
        StadMaintenanceOrder maintQuery = new StadMaintenanceOrder();
        maintQuery.setUserId(userId);
        for (StadMaintenanceOrder o : stadMaintenanceOrderService.selectStadMaintenanceOrderList(maintQuery)) {
            combined.add(buildFromMaintenance(o));
        }

        // 4. 按创建时间倒序排列
        combined.sort((a, b) -> {
            String sa = a.getCreateTime();
            String sb = b.getCreateTime();
            if (sa == null && sb == null) return 0;
            if (sa == null) return 1;
            if (sb == null) return -1;
            return sb.compareTo(sa);
        });

        // 5. 按状态筛选
        if (status != null && !status.isEmpty()) {
            combined = combined.stream()
                    .filter(item -> status.equals(item.getStatus()))
                    .collect(Collectors.toList());
        }

        // 6. 手动分页
        int total = combined.size();
        int fromIndex = (pageNum - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, total);
        List<OrderListVO> pageList = fromIndex >= total ? new ArrayList<>() : combined.subList(fromIndex, toIndex);

        Map<String, Object> result = new HashMap<>();
        result.put("rows", pageList);
        result.put("total", total);
        return AjaxResult.success(result);
    }

    /**
     * 获取订单状态统计（合并所有类型订单）
     */
    @GetMapping("/status")
    public AjaxResult getOrderStatusCount() {
        Long userId = SecurityUtils.getUserId();
        int unpaid = 0, pending = 0, completed = 0, cancelled = 0;

        // 统一订单统计
        MineStadUnifiedOrder uq = new MineStadUnifiedOrder();
        uq.setUserId(userId);
        for (MineStadUnifiedOrder o : stadUnifiedOrderService.selectStadUnifiedOrderList(uq)) {
            String s = normalizeUnifiedStatus(o.getStatus());
            switch (s) {
                case "0": unpaid++; break;
                case "1": pending++; break;
                case "2": completed++; break;
                case "3": cancelled++; break;
            }
        }

        // 充电订单统计
        MineStadChargingOrder cq = new MineStadChargingOrder();
        cq.setUserId(userId);
        for (MineStadChargingOrder o : stadChargingOrderService.selectStadChargingOrderList(cq)) {
            // 已完成但未支付 → 待支付
            if ("1".equals(o.getOrderStatus()) && "0".equals(o.getPayStatus())) {
                unpaid++;
                continue;
            }
            String s = normalizeChargeStatus(o.getOrderStatus());
            switch (s) {
                case "1": pending++; break;
                case "2": completed++; break;
                case "3": cancelled++; break;
            }
        }

        // 维保订单统计
        StadMaintenanceOrder mq = new StadMaintenanceOrder();
        mq.setUserId(userId);
        for (StadMaintenanceOrder o : stadMaintenanceOrderService.selectStadMaintenanceOrderList(mq)) {
            String s = normalizeMaintStatus(o.getOrderStatus());
            switch (s) {
                case "0": unpaid++; break;
                case "1": pending++; break;
                case "2": completed++; break;
                case "3": cancelled++; break;
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("unpaid", unpaid);
        result.put("pending", pending);
        result.put("completed", completed);
        result.put("cancelled", cancelled);
        return AjaxResult.success(result);
    }

    /**
     * 获取订单详情（支持三种订单类型）
     */
    @GetMapping("/{id}")
    public AjaxResult getOrderDetail(@PathVariable Long id,
                                     @RequestParam(required = false) String bizType) {
        if (bizType == null) {
            // 兼容旧版本：逐个尝试
            Object order;
            order = stadUnifiedOrderService.selectStadUnifiedOrderById(id);
            if (order != null) return AjaxResult.success(buildFromUnified((MineStadUnifiedOrder) order));

            MineStadChargingOrder c = stadChargingOrderService.selectStadChargingOrderById(id);
            if (c != null) return AjaxResult.success(buildFromCharging(c));

            StadMaintenanceOrder m = stadMaintenanceOrderService.selectStadMaintenanceOrderById(id);
            if (m != null) return AjaxResult.success(buildFromMaintenance(m));

            return AjaxResult.error("订单不存在");
        }

        switch (bizType) {
            case "charging": {
                MineStadChargingOrder o = stadChargingOrderService.selectStadChargingOrderById(id);
                return o != null ? AjaxResult.success(buildFromCharging(o)) : AjaxResult.error("订单不存在");
            }
            case "maintenance": {
                StadMaintenanceOrder o = stadMaintenanceOrderService.selectStadMaintenanceOrderById(id);
                return o != null ? AjaxResult.success(buildFromMaintenance(o)) : AjaxResult.error("订单不存在");
            }
            case "unified":
            default: {
                MineStadUnifiedOrder o = stadUnifiedOrderService.selectStadUnifiedOrderById(id);
                return o != null ? AjaxResult.success(buildFromUnified(o)) : AjaxResult.error("订单不存在");
            }
        }
    }

    /**
     * 取消订单
     */
    @Log(title = "订单", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/cancel")
    public AjaxResult cancelOrder(@PathVariable Long id) {
        MineStadUnifiedOrder order = new MineStadUnifiedOrder();
        order.setOrderId(id);
        order.setStatus("2");
        return toAjax(stadUnifiedOrderService.updateStadUnifiedOrder(order));
    }

    /**
     * 完成订单
     */
    @Log(title = "订单", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/complete")
    public AjaxResult completeOrder(@PathVariable Long id) {
        MineStadUnifiedOrder order = new MineStadUnifiedOrder();
        order.setOrderId(id);
        order.setStatus("1");
        return toAjax(stadUnifiedOrderService.updateStadUnifiedOrder(order));
    }

    /**
     * 删除订单
     */
    @Log(title = "订单", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public AjaxResult deleteOrder(@PathVariable Long id) {
        return toAjax(stadUnifiedOrderService.deleteStadUnifiedOrderById(id));
    }

    // ==================== VO 构建方法 ====================

    /** 统一订单 → VO */
    private OrderListVO buildFromUnified(MineStadUnifiedOrder o) {
        String normStatus = normalizeUnifiedStatus(o.getStatus());
        String typeLabel = UNIFIED_TYPE_LABEL.getOrDefault(o.getOrderType(), "车辆");
        OrderListVO vo = new OrderListVO();
        vo.setOrderId(o.getOrderId());
        vo.setOrderNo(o.getOrderNo());
        vo.setBizType("unified");
        vo.setBizTypeLabel(typeLabel);
        vo.setStatus(normStatus);
        vo.setStatusText(STATUS_TEXT.getOrDefault(normStatus, "处理中"));
        vo.setShopName(o.getMerchantName() != null ? o.getMerchantName() : "官方店铺");
        vo.setTotalAmount(o.getTotalAmount());
        vo.setPaidAmount(o.getPaidAmount());
        vo.setCreateTime(formatDate(o.getCreateTime()));
        vo.setTitle(getOrderTypeName(o.getOrderType()));
        vo.setDesc("车辆订单");

        // 统一订单特有字段
        vo.setUnifiedType(o.getOrderType());
        vo.setContactName(o.getContactName());
        vo.setContactPhone(o.getContactPhone());
        vo.setVehicleId(o.getVehicleId());
        vo.setVehiclePrice(o.getVehiclePrice());
        vo.setPaymentMethod(o.getPaymentMethod());
        return vo;
    }

    /** 充电订单 → VO */
    private OrderListVO buildFromCharging(MineStadChargingOrder o) {
        // 已完成但未支付 → 待支付
        String rawStatus = o.getOrderStatus();
        String payStatus = o.getPayStatus();
        String normStatus;
        if ("1".equals(rawStatus) && "0".equals(payStatus)) {
            normStatus = "0"; // 未支付
        } else {
            normStatus = normalizeChargeStatus(rawStatus);
        }
        OrderListVO vo = new OrderListVO();
        vo.setOrderId(o.getOrderId());
        vo.setOrderNo(o.getOrderNo());
        vo.setBizType("charging");
        vo.setBizTypeLabel("充电");
        vo.setStatus(normStatus);
        vo.setStatusText(STATUS_TEXT.getOrDefault(normStatus, "处理中"));
        vo.setShopName(o.getStationName() != null ? o.getStationName() : "充电站");
        vo.setTotalAmount(o.getTotalAmount());
        vo.setCreateTime(formatDate(o.getCreateTime()));
        vo.setTitle((o.getStationName() != null ? o.getStationName() : "") + "充电");
        vo.setDesc("充电订单");

        // 充电订单特有字段
        vo.setStationName(o.getStationName());
        vo.setStationAddress(o.getAddress());
        vo.setTotalEnergy(o.getTotalEnergy());
        vo.setCarbonEarned(o.getCarbonEarned());
        vo.setStartTime(formatDate(o.getStartTime()));
        vo.setEndTime(formatDate(o.getEndTime()));
        Integer duration = o.getDuration();
        if (duration == null || duration == 0) {
            // 从开始结束时间计算时长
            if (o.getStartTime() != null && o.getEndTime() != null) {
                long diff = o.getEndTime().getTime() - o.getStartTime().getTime();
                if (diff > 0) {
                    duration = (int) (diff / 1000);
                }
            }
        }
        if (duration != null && duration > 0) {
            vo.setDuration(duration);
            vo.setDurationText(formatDuration(duration));
        }
        return vo;
    }

    /** 维保订单 → VO */
    private OrderListVO buildFromMaintenance(StadMaintenanceOrder o) {
        String normStatus = normalizeMaintStatus(o.getOrderStatus());
        OrderListVO vo = new OrderListVO();
        vo.setOrderId(o.getOrderId());
        vo.setOrderNo(o.getOrderNo());
        vo.setBizType("maintenance");
        vo.setBizTypeLabel("维保");
        vo.setStatus(normStatus);
        vo.setStatusText(STATUS_TEXT.getOrDefault(normStatus, "处理中"));
        vo.setShopName(o.getShopName() != null ? o.getShopName() : "维保门店");
        vo.setTotalAmount(o.getTotalAmount());
        vo.setPaidAmount(o.getPaidAmount());
        vo.setCreateTime(formatDate(o.getCreateTime()));
        vo.setTitle(o.getServiceItem() != null ? o.getServiceItem() : "维保服务");
        vo.setDesc("维保订单");

        // 维保订单特有字段
        vo.setServiceItem(o.getServiceItem());
        vo.setServicePrice(o.getServicePrice());
        vo.setExpectDate(o.getExpectDate() != null ? DateUtils.parseDateToStr("yyyy-MM-dd", o.getExpectDate()) : null);
        vo.setExpectTimeSlot(o.getExpectTimeSlot());
        vo.setShopAddress(o.getShopAddress());
        vo.setPaymentMethod(o.getPaymentMethod());
        return vo;
    }

    // ==================== 工具方法 ====================

    /** 格式化日期 */
    private String formatDate(Date date) {
        return date != null ? DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD_HH_MM_SS, date) : "";
    }

    /** 格式化充电时长：秒 → "X时X分X秒" */
    private String formatDuration(Integer seconds) {
        if (seconds == null || seconds <= 0) return "";
        int h = seconds / 3600;
        int m = (seconds % 3600) / 60;
        int s = seconds % 60;
        StringBuilder sb = new StringBuilder();
        if (h > 0) sb.append(h).append("时");
        if (m > 0) sb.append(m).append("分");
        sb.append(s).append("秒");
        return sb.toString();
    }

    /**
     * 统一订单状态归一化
     */
    private String normalizeUnifiedStatus(String s) {
        if (s == null) return "0";
        switch (s) {
            case "0": return "0";  // 待支付 → unpaid
            case "1": return "1";  // 待服务 → pending
            case "2": return "3";  // 已取消 → cancelled
            case "3": return "2";  // 已完成 → completed
            default: return "0";
        }
    }

    /**
     * 充电订单状态归一化
     */
    private String normalizeChargeStatus(String s) {
        if (s == null) return "1";
        switch (s) {
            case "0": return "1";  // 充电中 → pending
            case "1": return "2";  // 已完成 → completed
            case "2": return "3";  // 已取消 → cancelled
            default: return "1";
        }
    }

    /**
     * 维保订单状态归一化
     */
    private String normalizeMaintStatus(String s) {
        if (s == null) return "0";
        switch (s) {
            case "0": return "0";
            case "1": return "1";
            case "2": return "1";
            case "3": return "2";
            case "4": return "3";
            default: return "0";
        }
    }

    /**
     * 统一订单类型中文名
     */
    private String getOrderTypeName(String type) {
        if (type == null) return "车辆订单";
        switch (type) {
            case "purchase":  return "购车订单";
            case "test_drive": return "试驾订单";
            case "trade_in":  return "以旧换新";
            default: return "车辆订单";
        }
    }
}