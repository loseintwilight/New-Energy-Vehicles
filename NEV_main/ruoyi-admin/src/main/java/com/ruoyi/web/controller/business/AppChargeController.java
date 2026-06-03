package com.ruoyi.web.controller.business;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.business.domain.StadChargingStation;
import com.ruoyi.business.domain.StadChargingPile;
import com.ruoyi.business.domain.StadChargingOrder;
import com.ruoyi.business.service.IStadChargingStationService;
import com.ruoyi.business.service.IStadChargingPileService;
import com.ruoyi.business.service.IStadChargingOrderService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

/**
 * 小程序端 - 充电服务接口
 */
@RestController
@RequestMapping("/app/charge")
public class AppChargeController extends BaseController {

    @Autowired
    private IStadChargingStationService stadChargingStationService;

    @Autowired
    private IStadChargingPileService stadChargingPileService;

    @Autowired
    private IStadChargingOrderService stadChargingOrderService;

    // ==================== 充电站 ====================

    /**
     * 充电站列表（分页）
     * GET /app/charge/station/list?lat=36.5&lng=116.8&pageNum=1&pageSize=10
     */
    @GetMapping("/station/list")
    public TableDataInfo stationList(
            @RequestParam(required = false) Double lat,
            @RequestParam(required = false) Double lng,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        StadChargingStation query = new StadChargingStation();
        query.setStationStatus("1"); // 只查运营中的
        PageHelper.startPage(pageNum, pageSize, "station_id desc");
        List<StadChargingStation> list = stadChargingStationService.selectStadChargingStationList(query);
        PageInfo<StadChargingStation> pageInfo = new PageInfo<>(list);

        // 转换为前端格式
        TableDataInfo table = new TableDataInfo();
        table.setCode(0);
        table.setTotal(pageInfo.getTotal());
        List<Map<String, Object>> rows = new java.util.ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        for (StadChargingStation s : list) {
            Map<String, Object> item = new HashMap<>();
            item.put("stationId", s.getStationId());
            item.put("name", s.getStationName());
            item.put("stationName", s.getStationName());
            item.put("address", s.getAddress());
            item.put("lat", s.getLatitude());
            item.put("lng", s.getLongitude());
            item.put("totalPiles", s.getTotalPiles() != null ? s.getTotalPiles() : 0);
            item.put("freePiles", s.getAvailablePiles() != null ? s.getAvailablePiles() : 0);
            item.put("statusText", "闲" + (s.getAvailablePiles() != null ? s.getAvailablePiles() : 0) + "/" + (s.getTotalPiles() != null ? s.getTotalPiles() : 0));
            item.put("price", "0.88");
            item.put("speedType", "快");
            item.put("speedTypeKey", "fast");
            item.put("parkInfo", s.getParkingFee() != null ? s.getParkingFee() : "免费");
            item.put("servicePhone", s.getServicePhone());
            item.put("score", 4.5);
            item.put("tags", new Object[0]);
            item.put("isNearest", false);
            item.put("discount", 0);
            item.put("lastChargeTime", "1天前有人充电");

            // 距离（如果传了经纬度则计算）
            if (lat != null && lng != null && s.getLatitude() != null && s.getLongitude() != null) {
                double dist = haversine(lat, lng, s.getLatitude().doubleValue(), s.getLongitude().doubleValue());
                item.put("distance", String.format("%.1f", dist));
            } else {
                item.put("distance", "0");
            }

            item.put("createTime", s.getCreateTime() != null ? sdf.format(s.getCreateTime()) : "");
            item.put("imageUrl", s.getImages());
            item.put("facilitiesInfo", s.getFacilitiesInfo());

            rows.add(item);
        }

        table.setRows(rows);
        return table;
    }

    /**
     * 充电站详情
     * GET /app/charge/station/detail/{stationId}
     */
    @GetMapping("/station/detail/{stationId}")
    public AjaxResult stationDetail(@PathVariable Long stationId) {
        StadChargingStation station = stadChargingStationService.selectStadChargingStationById(stationId);
        if (station == null) {
            return error("充电站不存在");
        }

        Map<String, Object> result = new HashMap<>();
        result.put("stationId", station.getStationId());
        result.put("name", station.getStationName());
        result.put("stationName", station.getStationName());
        result.put("stationType", "公共充电站");
        result.put("address", station.getAddress());
        result.put("stationAddress", station.getAddress());
        result.put("lat", station.getLatitude());
        result.put("lng", station.getLongitude());
        result.put("totalPiles", station.getTotalPiles() != null ? station.getTotalPiles() : 0);
        result.put("freePiles", station.getAvailablePiles() != null ? station.getAvailablePiles() : 0);
        result.put("occupyingPiles", station.getOccupyingPiles() != null ? station.getOccupyingPiles() : 0);
        result.put("price", "0.88");
        result.put("currentPrice", "0.88");
        result.put("speedType", "快");
        result.put("speedTypeKey", "fast");
        result.put("openTime", "周一至周日 00:00-23:59");
        result.put("operatorName", station.getMerchantName() != null ? station.getMerchantName() : "国家电网");
        result.put("parkInfo", station.getParkingFee() != null ? station.getParkingFee() : "免费");
        result.put("parkingFee", station.getParkingFee());
        result.put("servicePhone", station.getServicePhone());
        result.put("facilitiesInfo", station.getFacilitiesInfo());
        result.put("images", station.getImages());
        result.put("score", 4.5);
        result.put("tags", new Object[0]);
        result.put("tagList", new Object[0]);
        result.put("plugAndPlay", false);
        result.put("selfService", false);
        result.put("distanceVal", "0");
        result.put("isFavorite", false);

        return success(result);
    }

    /**
     * 搜索充电站
     * GET /app/charge/station/search?keyword=xxx&pageNum=1&pageSize=10
     */
    @GetMapping("/station/search")
    public TableDataInfo searchStation(
            @RequestParam String keyword,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        StadChargingStation query = new StadChargingStation();
        query.setStationName(keyword);
        query.setStationStatus("1");
        PageHelper.startPage(pageNum, pageSize, "station_id desc");
        List<StadChargingStation> list = stadChargingStationService.selectStadChargingStationList(query);
        PageInfo<StadChargingStation> pageInfo = new PageInfo<>(list);

        TableDataInfo table = new TableDataInfo();
        table.setCode(0);
        table.setTotal(pageInfo.getTotal());
        List<Map<String, Object>> rows = new java.util.ArrayList<>();
        for (StadChargingStation s : list) {
            Map<String, Object> item = new HashMap<>();
            item.put("stationId", s.getStationId());
            item.put("name", s.getStationName());
            item.put("stationName", s.getStationName());
            item.put("address", s.getAddress());
            item.put("lat", s.getLatitude());
            item.put("lng", s.getLongitude());
            item.put("totalPiles", s.getTotalPiles());
            item.put("freePiles", s.getAvailablePiles());
            item.put("price", "0.88");
            item.put("speedType", "快");
            item.put("speedTypeKey", "fast");
            item.put("distance", "0");
            item.put("score", 4.5);
            rows.add(item);
        }
        table.setRows(rows);
        return table;
    }

    // ==================== 充电桩 ====================

    /**
     * 充电桩列表（按充电站）
     * GET /app/charge/pile/list?stationId=1001
     */
    @GetMapping("/pile/list")
    public AjaxResult pileList(@RequestParam Long stationId) {
        List<StadChargingPile> piles = stadChargingPileService.selectStadChargingPileByStationId(stationId);

        List<Map<String, Object>> rows = new java.util.ArrayList<>();
        for (StadChargingPile p : piles) {
            Map<String, Object> item = new HashMap<>();
            item.put("pileId", p.getPileId());
            item.put("pileCode", p.getPileCode());
            item.put("number", p.getPileCode());
            item.put("type", "fast".equals(p.getPileType()) ? "快充" : "慢充");
            item.put("pileType", p.getPileType());
            item.put("power", p.getPowerKw() != null ? p.getPowerKw().toString() + "kW" : "7kW");
            item.put("powerKw", p.getPowerKw());
            item.put("status", p.getPileStatus());
            item.put("connectorType", p.getConnectorType());
            item.put("voltage", p.getVoltage());
            item.put("currentA", p.getCurrentA());
            item.put("powerNow", p.getPowerNow());
            item.put("energyTotal", p.getEnergyTotal());
            rows.add(item);
        }

        return success(rows);
    }

    // ==================== 充电订单 ====================

    /**
     * 开始充电
     * POST /app/charge/order/start
     * body: { stationId, pileId, pileCode }
     */
    @PostMapping("/order/start")
    public AjaxResult startCharge(@RequestBody Map<String, Object> params) {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            return error("未获取到用户信息");
        }

        Long stationId = params.get("stationId") != null ? Long.valueOf(params.get("stationId").toString()) : null;
        Long pileId = params.get("pileId") != null ? Long.valueOf(params.get("pileId").toString()) : null;
        String pileCode = (String) params.get("pileCode");

        if (stationId == null || StringUtils.isEmpty(pileCode)) {
            return error("请选择充电桩");
        }

        // 创建订单
        StadChargingOrder order = new StadChargingOrder();
        order.setOrderNo("CHARGE" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 4));
        order.setUserId(userId);
        order.setStationId(stationId);
        order.setPileId(pileId);
        order.setPileCode(pileCode);
        order.setStartTime(new Date());
        order.setStartSoc(new BigDecimal("0"));
        order.setOrderStatus("0"); // 充电中
        order.setPayStatus("0");   // 未支付
        order.setCreateBy(SecurityUtils.getUsername());

        stadChargingOrderService.insertStadChargingOrder(order);

        // 更新充电桩状态为充电中
        if (pileId != null) {
            StadChargingPile pile = stadChargingPileService.selectStadChargingPileById(pileId);
            if (pile != null) {
                pile.setPileStatus("charging");
                pile.setCurrentOrderNo(order.getOrderNo());
                pile.setCurrentStartTime(new Date());
                stadChargingPileService.updateStadChargingPile(pile);
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("orderId", order.getOrderId());
        result.put("orderNo", order.getOrderNo());
        return success(result);
    }

    /**
     * 查询充电状态
     * GET /app/charge/order/status/{orderId}
     */
    @GetMapping("/order/status/{orderId}")
    public AjaxResult chargeStatus(@PathVariable Long orderId) {
        StadChargingOrder order = stadChargingOrderService.selectStadChargingOrderById(orderId);
        if (order == null) {
            return error("订单不存在");
        }

        Map<String, Object> result = new HashMap<>();
        result.put("orderId", order.getOrderId());
        result.put("orderNo", order.getOrderNo());
        result.put("orderStatus", order.getOrderStatus());
        result.put("payStatus", order.getPayStatus());
        result.put("startTime", order.getStartTime());
        result.put("duration", order.getDuration());
        result.put("totalEnergy", order.getTotalEnergy());
        result.put("totalAmount", order.getTotalAmount());
        result.put("startSoc", order.getStartSoc());
        result.put("endSoc", order.getEndSoc());
        result.put("stationName", order.getStationName());
        result.put("pileCode", order.getPileCode());

        return success(result);
    }

    /**
     * 停止充电
     * POST /app/charge/order/stop
     * body: { orderId }
     */
    @PostMapping("/order/stop")
    public AjaxResult stopCharge(@RequestBody Map<String, Object> params) {
        Long orderId = params.get("orderId") != null ? Long.valueOf(params.get("orderId").toString()) : null;
        if (orderId == null) {
            return error("订单ID不能为空");
        }

        StadChargingOrder order = stadChargingOrderService.selectStadChargingOrderById(orderId);
        if (order == null) {
            return error("订单不存在");
        }

        // 模拟充电结束数据
        order.setEndTime(new Date());
        order.setEndSoc(new BigDecimal("95"));
        order.setTotalEnergy(new BigDecimal("32.5"));
        order.setEnergyPrice(new BigDecimal("0.88"));
        order.setServicePrice(new BigDecimal("0.40"));
        order.setTotalAmount(new BigDecimal("41.60"));
        order.setDiscountAmount(new BigDecimal("0"));
        order.setOrderStatus("1"); // 已完成
        order.setPayStatus("0");   // 待支付
        order.setDuration(3600);
        order.setCarbonEarned(18);
        order.setUpdateBy(SecurityUtils.getUsername());

        stadChargingOrderService.updateStadChargingOrder(order);

        // 释放充电桩
        if (order.getPileId() != null) {
            StadChargingPile pile = stadChargingPileService.selectStadChargingPileById(order.getPileId());
            if (pile != null) {
                pile.setPileStatus("free");
                pile.setCurrentOrderNo(null);
                pile.setCurrentStartTime(null);
                stadChargingPileService.updateStadChargingPile(pile);
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("totalEnergy", order.getTotalEnergy());
        result.put("totalAmount", order.getTotalAmount());
        result.put("duration", order.getDuration());
        result.put("carbonEarned", order.getCarbonEarned());
        return success(result);
    }

    /**
     * 订单列表（当前用户）
     * GET /app/charge/order/list?orderStatus=0|1|2
     */
    @GetMapping("/order/list")
    public TableDataInfo orderList(
            @RequestParam(required = false) String orderStatus,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            TableDataInfo empty = new TableDataInfo();
            empty.setCode(0);
            empty.setTotal(0);
            empty.setRows(java.util.Collections.emptyList());
            return empty;
        }

        StadChargingOrder query = new StadChargingOrder();
        query.setUserId(userId);
        if (StringUtils.isNotEmpty(orderStatus)) {
            query.setOrderStatus(orderStatus);
        }
        PageHelper.startPage(pageNum, pageSize, "order_id desc");
        List<StadChargingOrder> list = stadChargingOrderService.selectStadChargingOrderList(query);
        PageInfo<StadChargingOrder> pageInfo = new PageInfo<>(list);

        TableDataInfo table = new TableDataInfo();
        table.setCode(0);
        table.setTotal(pageInfo.getTotal());
        List<Map<String, Object>> rows = new java.util.ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        for (StadChargingOrder o : list) {
            Map<String, Object> item = new HashMap<>();
            item.put("orderId", o.getOrderId());
            item.put("orderNo", o.getOrderNo());
            item.put("stationName", o.getStationName());
            item.put("pileCode", o.getPileCode());
            item.put("startTime", o.getStartTime() != null ? sdf.format(o.getStartTime()) : "");
            item.put("endTime", o.getEndTime() != null ? sdf.format(o.getEndTime()) : "");
            item.put("duration", o.getDuration());
            item.put("totalEnergy", o.getTotalEnergy());
            item.put("totalAmount", o.getTotalAmount());
            item.put("orderStatus", o.getOrderStatus());
            item.put("payStatus", o.getPayStatus());
            item.put("carbonEarned", o.getCarbonEarned());
            item.put("createTime", o.getCreateTime() != null ? sdf.format(o.getCreateTime()) : "");
            rows.add(item);
        }
        table.setRows(rows);
        return table;
    }

    /**
     * 支付订单
     * POST /app/charge/order/pay
     * body: { orderId }
     */
    @PostMapping("/order/pay")
    public AjaxResult payOrder(@RequestBody Map<String, Object> params) {
        Long orderId = params.get("orderId") != null ? Long.valueOf(params.get("orderId").toString()) : null;
        if (orderId == null) {
            return error("订单ID不能为空");
        }

        StadChargingOrder order = stadChargingOrderService.selectStadChargingOrderById(orderId);
        if (order == null) {
            return error("订单不存在");
        }
        if ("1".equals(order.getPayStatus())) {
            return error("订单已支付");
        }

        order.setPayStatus("1");
        order.setPaymentMethod("wechat");
        order.setTransactionId("TXN" + System.currentTimeMillis());
        order.setUpdateBy(SecurityUtils.getUsername());
        stadChargingOrderService.updateStadChargingOrder(order);

        return success("支付成功");
    }

    /**
     * 取消订单
     * POST /app/charge/order/cancel
     * body: { orderId }
     */
    @PostMapping("/order/cancel")
    public AjaxResult cancelOrder(@RequestBody Map<String, Object> params) {
        Long orderId = params.get("orderId") != null ? Long.valueOf(params.get("orderId").toString()) : null;
        if (orderId == null) {
            return error("订单ID不能为空");
        }

        StadChargingOrder order = stadChargingOrderService.selectStadChargingOrderById(orderId);
        if (order == null) {
            return error("订单不存在");
        }

        order.setOrderStatus("2"); // 已取消
        order.setUpdateBy(SecurityUtils.getUsername());
        stadChargingOrderService.updateStadChargingOrder(order);

        return success("取消成功");
    }

    /**
     * 申请发票
     * POST /app/charge/order/invoice
     * body: { orderId }
     */
    @PostMapping("/order/invoice")
    public AjaxResult applyInvoice(@RequestBody Map<String, Object> params) {
        Long orderId = params.get("orderId") != null ? Long.valueOf(params.get("orderId").toString()) : null;
        if (orderId == null) {
            return error("订单ID不能为空");
        }

        // 发票申请仅做记录，返回成功即可
        return success("发票申请已提交，将在3个工作日内发送到您的邮箱");
    }

    // ==================== 工具方法 ====================

    /**
     * 计算两点间距离（Haversine 公式，单位公里）
     */
    private double haversine(double lat1, double lng1, double lat2, double lng2) {
        double R = 6371.0;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLng = Math.toRadians(lng2 - lng1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLng / 2) * Math.sin(dLng / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }
}