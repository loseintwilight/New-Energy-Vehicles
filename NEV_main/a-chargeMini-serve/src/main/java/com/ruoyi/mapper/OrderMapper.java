package com.ruoyi.mapper;

import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

public interface OrderMapper {

    /** 分页查询用户订单列表 */
    List<Map<String, Object>> selectOrderList(@Param("userId") Long userId,
                                             @Param("status") String status,
                                             @Param("offset") Integer offset,
                                             @Param("limit") Integer limit);

    /** 查询用户订单总数 */
    Long selectOrderCount(@Param("userId") Long userId, @Param("status") String status);

    /** 根据订单号查询订单 */
    Map<String, Object> selectOrderByOrderNo(@Param("orderNo") String orderNo);

    /** 插入订单 */
    int insertOrder(Map<String, Object> order);

    /** 更新充电订单（停止充电） */
    int updateOrderForStop(Map<String, Object> params);

    /** 更新订单支付 */
    int updateOrderPay(@Param("orderNo") String orderNo, @Param("payStatus") String payStatus, @Param("payMethod") String payMethod);

    /** 取消订单 */
    int cancelOrder(@Param("orderNo") String orderNo);
}