package com.ruoyi.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ruoyi.domain.VehicleOrders;
import com.ruoyi.mapper.VehicleOrdersMapper;
import com.ruoyi.service.VehicleOrdersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
/**
 * @Description: 订单管理
 * @Author: 刘文丽
 * @CreateTime: 2026-06-05 09:54
 */
@Service
public class VehicleOrdersServiceImpl implements VehicleOrdersService {

    @Autowired
    private VehicleOrdersMapper vehicleOrdersMapper;

    @Override
    public PageInfo<VehicleOrders> getOrderList(String orderType, String paymentStatus, String keyword, Integer pageNum, Integer pageSize) {
        if (pageNum == null || pageNum < 1) pageNum = 1;
        if (pageSize == null || pageSize < 1) pageSize = 10;
        PageHelper.startPage(pageNum, pageSize);
        List<VehicleOrders> list = vehicleOrdersMapper.selectOrderList(orderType, paymentStatus, keyword);
        return new PageInfo<>(list);
    }

    @Override
    public VehicleOrders getOrderById(Long orderId) {
        return vehicleOrdersMapper.selectOrderById(orderId);
    }

    @Override
    public int updateOrderStatus(Long orderId, String status) {
        return vehicleOrdersMapper.updateOrderStatus(orderId, status);
    }

    @Override
    public int deleteOrderById(Long orderId) {
        return vehicleOrdersMapper.deleteOrderById(orderId);
    }
}
