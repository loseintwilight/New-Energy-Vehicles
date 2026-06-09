package com.ruoyi.service;

import com.github.pagehelper.PageInfo;
import com.ruoyi.domain.VehicleOrders;

public interface VehicleOrdersService {

    PageInfo<VehicleOrders> getOrderList(String orderType, String paymentStatus, String keyword, Integer pageNum, Integer pageSize);

    VehicleOrders getOrderById(Long orderId);

    int updateOrderStatus(Long orderId, String status);

    int deleteOrderById(Long orderId);
}
