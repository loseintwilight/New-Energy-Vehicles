package com.ruoyi.web.controller.vehicle;

import com.github.pagehelper.PageInfo;
import com.ruoyi.common.core.domain.R;
import com.ruoyi.domain.VehicleOrders;
import com.ruoyi.service.VehicleOrdersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @Description: 订单管理
 * @Author: 刘文丽
 * @CreateTime: 2026-06-05 15:09
 */
@RestController
@RequestMapping("/business/vehicle/order")
public class VehicleOrderController {

    @Autowired
    private VehicleOrdersService vehicleOrderService;

//    分页查询订单列表
    @GetMapping("/list")
    public R listOrder(VehicleOrders query, @RequestParam(defaultValue = "1") Integer pageNum, @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<VehicleOrders> page = vehicleOrderService.getOrderList(query.getOrderType(), query.getStatus(), null, pageNum, pageSize);
        return R.success(page);
    }

//    订单详情
    @GetMapping("/{orderId}")
    public R getOrderDetail(@PathVariable Long orderId) {
        VehicleOrders order = vehicleOrderService.getOrderById(orderId);
        return R.success(order);
    }
}
