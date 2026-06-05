package com.ruoyi.web.controller.chargeMini;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 小程序端 - 充电订单接口
 */
@RestController
@RequestMapping("/app/charge/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    /**
     * 3.1 获取订单列表
     */
    @GetMapping("/list")
    public AjaxResult list(@RequestParam(defaultValue = "1") Integer pageNum,
                           @RequestParam(defaultValue = "10") Integer pageSize,
                           @RequestParam(required = false) String status) {
        Long userId = SecurityUtils.getUserId();
        return orderService.getOrderList(userId, status, pageNum, pageSize);
    }

    /**
     * 3.2 开始充电
     */
    @PostMapping("/start")
    public AjaxResult start(@RequestBody Map<String, Object> params) {
        Long userId = SecurityUtils.getUserId();
        Long stationId = Long.valueOf(params.get("stationId").toString());
        String pileNo = (String) params.get("pileNo");
        Double energy = params.get("energy") != null ? Double.valueOf(params.get("energy").toString()) : null;
        Integer soc = params.get("soc") != null ? Integer.valueOf(params.get("soc").toString()) : null;
        return orderService.startCharge(userId, stationId, pileNo, energy, soc);
    }

    /**
     * 3.3 获取充电状态
     */
    @GetMapping("/status/{orderId}")
    public AjaxResult status(@PathVariable String orderId) {
        return orderService.getChargeStatus(orderId);
    }

    /**
     * 3.4 停止充电
     */
    @PostMapping("/stop")
    public AjaxResult stop(@RequestBody Map<String, Object> params) {
        String orderId = (String) params.get("orderId");
        return orderService.stopCharge(orderId);
    }

    /**
     * 3.5 支付订单
     */
    @PostMapping("/pay")
    public AjaxResult pay(@RequestBody Map<String, Object> params) {
        String orderId = (String) params.get("orderId");
        String payMethod = (String) params.get("payMethod");
        return orderService.payOrder(orderId, payMethod);
    }

    /**
     * 3.6 取消订单
     */
    @PostMapping("/cancel")
    public AjaxResult cancel(@RequestBody Map<String, Object> params) {
        String orderId = (String) params.get("orderId");
        return orderService.cancelOrder(orderId);
    }
}