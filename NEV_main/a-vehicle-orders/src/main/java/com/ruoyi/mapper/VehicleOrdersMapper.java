package com.ruoyi.mapper;

import com.ruoyi.domain.VehicleOrders;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface VehicleOrdersMapper {

    List<VehicleOrders> selectOrderList(@Param("orderType") String orderType, @Param("paymentStatus") String paymentStatus, @Param("keyword") String keyword);

    VehicleOrders selectOrderById(@Param("orderId") Long orderId);

    int updateOrderStatus(@Param("orderId") Long orderId, @Param("status") String status);

    int deleteOrderById(@Param("orderId") Long orderId);
}
