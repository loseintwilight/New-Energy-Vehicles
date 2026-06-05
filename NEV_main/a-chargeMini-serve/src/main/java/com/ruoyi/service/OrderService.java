package com.ruoyi.service;

import com.ruoyi.common.core.domain.AjaxResult;

public interface OrderService {

    /** 分页获取用户订单列表 */
    AjaxResult getOrderList(Long userId, String status, Integer pageNum, Integer pageSize);

    /** 开始充电 */
    AjaxResult startCharge(Long userId, Long stationId, String pileNo, Double energy, Integer soc);

    /** 获取充电状态 */
    AjaxResult getChargeStatus(String orderNo);

    /** 停止充电 */
    AjaxResult stopCharge(String orderNo);

    /** 支付订单 */
    AjaxResult payOrder(String orderNo, String payMethod);

    /** 取消订单 */
    AjaxResult cancelOrder(String orderNo);
}