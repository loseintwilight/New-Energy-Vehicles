package com.ruoyi.charging.mapper;

import com.ruoyi.charging.domain.ChargingStation;
import com.ruoyi.charging.domain.DashboardStationVO;
import com.ruoyi.charging.domain.DashboardOrderVO;
import com.ruoyi.charging.domain.DashboardVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 充电站Mapper接口
 *
 * @author ruoyi
 */
public interface ChargingStationMapper
{
    public ChargingStation selectChargingStationById(Long stationId);

    public List<ChargingStation> selectChargingStationList(ChargingStation station);

    public List<ChargingStation> selectChargingStationListByMerchantId(Long merchantId);

    public int insertChargingStation(ChargingStation station);

    public int updateChargingStation(ChargingStation station);

    public int deleteChargingStationById(Long stationId);

    /** 工作台：查询商户今日各站统计 */
    public List<DashboardStationVO> selectDashboardStations(@Param("merchantId") Long merchantId);

    /** 工作台：查询商户今日汇总统计 */
    public DashboardVO selectDashboardTodayStats(@Param("merchantId") Long merchantId);

    /** 工作台：查询商户最近订单 */
    public List<DashboardOrderVO> selectDashboardRecentOrders(@Param("merchantId") Long merchantId, @Param("limit") Integer limit);
}
