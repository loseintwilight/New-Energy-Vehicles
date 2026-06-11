package com.ruoyi.charging.service;

import java.util.List;
import com.ruoyi.charging.domain.ChargingStation;

/**
 * 充电站Service接口
 *
 * @author ruoyi
 */
public interface IChargingStationService
{
    /**
     * 查询充电站
     */
    public ChargingStation selectChargingStationById(Long stationId);

    /**
     * 查询充电站列表
     */
    public List<ChargingStation> selectChargingStationList(ChargingStation station);

    /**
     * 根据商户ID查询充电站列表
     */
    public List<ChargingStation> selectChargingStationListByMerchantId(Long merchantId);

    /**
     * 新增充电站
     */
    public int insertChargingStation(ChargingStation station);

    /**
     * 修改充电站
     */
    public int updateChargingStation(ChargingStation station);

    /**
     * 批量删除充电站
     */
    public int deleteChargingStationByIds(Long[] stationIds);

    /**
     * 删除充电站信息
     */
    public int deleteChargingStationById(Long stationId);
}
