package com.ruoyi.mine.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.mine.domain.MineStadChargingOrder;
import com.ruoyi.mine.vo.ChargingOrderListVO;

public interface IStadChargingOrderService {
    public MineStadChargingOrder selectStadChargingOrderById(Long orderId);
    public List<MineStadChargingOrder> selectStadChargingOrderList(MineStadChargingOrder order);
    public int insertStadChargingOrder(MineStadChargingOrder order);
    public int updateStadChargingOrder(MineStadChargingOrder order);
    public int deleteStadChargingOrderById(Long orderId);
    public int deleteStadChargingOrderByIds(Long[] orderIds);

    /**
     * 获取充电记录列表（格式化 vo）
     */
    public List<ChargingOrderListVO> selectFormattedChargingOrderList(MineStadChargingOrder order);

    /**
     * 获取充电记录详情（格式化）
     */
    public ChargingOrderListVO selectFormattedChargingOrderDetail(Long orderId);

    /**
     * 获取充电统计（总次数、总电量、总金额）
     */
    public Map<String, Object> getChargingStatistics(Long userId);
}
