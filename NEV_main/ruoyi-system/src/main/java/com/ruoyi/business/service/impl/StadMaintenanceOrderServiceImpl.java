package com.ruoyi.business.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadMaintenanceOrderMapper;
import com.ruoyi.business.domain.StadMaintenanceOrder;
import com.ruoyi.business.service.IStadMaintenanceOrderService;

@Service
public class StadMaintenanceOrderServiceImpl implements IStadMaintenanceOrderService {

    @Autowired
    private StadMaintenanceOrderMapper stadMaintenanceOrderMapper;

    @Override
    public StadMaintenanceOrder selectStadMaintenanceOrderById(Long orderId) {
        return stadMaintenanceOrderMapper.selectStadMaintenanceOrderById(orderId);
    }

    @Override
    public List<StadMaintenanceOrder> selectStadMaintenanceOrderList(StadMaintenanceOrder order) {
        return stadMaintenanceOrderMapper.selectStadMaintenanceOrderList(order);
    }

    @Override
    public int insertStadMaintenanceOrder(StadMaintenanceOrder order) {
        return stadMaintenanceOrderMapper.insertStadMaintenanceOrder(order);
    }

    @Override
    public int updateStadMaintenanceOrder(StadMaintenanceOrder order) {
        return stadMaintenanceOrderMapper.updateStadMaintenanceOrder(order);
    }

    @Override
    public int deleteStadMaintenanceOrderByIds(Long[] orderIds) {
        return stadMaintenanceOrderMapper.deleteStadMaintenanceOrderByIds(orderIds);
    }

    @Override
    public List<Map<String, Object>> getFormattedReservationList(Long userId, StadMaintenanceOrder query) {
        if (query == null) {
            query = new StadMaintenanceOrder();
        }
        query.setUserId(userId);
        List<StadMaintenanceOrder> list = stadMaintenanceOrderMapper.selectStadMaintenanceOrderList(query);
        List<Map<String, Object>> result = new ArrayList<>(list.size());
        for (StadMaintenanceOrder o : list) {
            result.add(orderToMap(o));
        }
        return result;
    }

    @Override
    public Map<String, Object> getFormattedReservationDetail(Long orderId) {
        StadMaintenanceOrder o = stadMaintenanceOrderMapper.selectStadMaintenanceOrderById(orderId);
        if (o == null) {
            return null;
        }
        return orderToMap(o);
    }

    @Override
    public boolean cancelReservation(Long orderId) {
        StadMaintenanceOrder o = stadMaintenanceOrderMapper.selectStadMaintenanceOrderById(orderId);
        if (o == null || !"0".equals(o.getOrderStatus())) {
            return false;
        }
        StadMaintenanceOrder update = new StadMaintenanceOrder();
        update.setOrderId(orderId);
        update.setOrderStatus("4");
        update.setCancelReason("用户主动取消");
        return stadMaintenanceOrderMapper.updateStadMaintenanceOrder(update) > 0;
    }

    @Override
    public boolean createReservation(Long userId, Map<String, Object> data) {
        StadMaintenanceOrder order = new StadMaintenanceOrder();
        order.setUserId(userId);
        order.setShopId(Long.valueOf(data.get("shop_id").toString()));
        if (data.containsKey("vehicle_id")) {
            order.setVehicleId(Long.valueOf(data.get("vehicle_id").toString()));
        }
        order.setServiceItem((String) data.getOrDefault("service_item", ""));
        order.setServicePrice(new java.math.BigDecimal(data.getOrDefault("service_price", "0").toString()));
        order.setTotalAmount(new java.math.BigDecimal(data.getOrDefault("total_amount", "0").toString()));
        order.setPaidAmount(java.math.BigDecimal.ZERO);
        order.setOrderStatus("0");
        order.setPayStatus("0");
        order.setOrderNo("RES" + System.currentTimeMillis());
        return stadMaintenanceOrderMapper.insertStadMaintenanceOrder(order) > 0;
    }

    private Map<String, Object> orderToMap(StadMaintenanceOrder o) {
        Map<String, Object> map = new HashMap<>();
        map.put("orderId", o.getOrderId());
        map.put("orderNo", o.getOrderNo());
        map.put("userId", o.getUserId());
        map.put("shopId", o.getShopId());
        map.put("vehicleId", o.getVehicleId());
        map.put("serviceItem", o.getServiceItem());
        map.put("servicePrice", o.getServicePrice());
        map.put("totalAmount", o.getTotalAmount());
        map.put("paidAmount", o.getPaidAmount());
        map.put("expectDate", o.getExpectDate());
        map.put("expectTimeSlot", o.getExpectTimeSlot());
        map.put("orderStatus", o.getOrderStatus());
        map.put("cancelReason", o.getCancelReason());
        map.put("finishTime", o.getFinishTime());
        map.put("rating", o.getRating());
        map.put("commentContent", o.getCommentContent());
        map.put("payStatus", o.getPayStatus());
        map.put("paymentMethod", o.getPaymentMethod());
        map.put("createTime", o.getCreateTime());
        map.put("shopName", o.getShopName());
        map.put("nickName", o.getNickName());
        map.put("shopAddress", o.getShopAddress());
        map.put("contactName", o.getContactName());
        map.put("contactPhone", o.getContactPhone());
        map.put("vehicleName", o.getVehicleName());
        return map;
    }
}
