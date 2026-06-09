package com.ruoyi.mine.mapper;

import java.util.List;
import java.util.Map;
import com.ruoyi.mine.domain.MineStadChargingOrder;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository("mineStadChargingOrderMapper")
public interface StadChargingOrderMapper {
    public MineStadChargingOrder selectStadChargingOrderById(Long orderId);
    public List<MineStadChargingOrder> selectStadChargingOrderList(MineStadChargingOrder order);
    public int insertStadChargingOrder(MineStadChargingOrder order);
    public int updateStadChargingOrder(MineStadChargingOrder order);
    public int deleteStadChargingOrderById(Long orderId);
    public int deleteStadChargingOrderByIds(Long[] orderIds);

    /** 按用户统计充电次数、总电量、总金额 */
    public List<Map<String, Object>> selectChargingStatisticsByUserId(Long userId);
}
