package com.ruoyi.charging.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.charging.mapper.ChargingStationMapper;
import com.ruoyi.charging.domain.ChargingStation;
import com.ruoyi.charging.service.IChargingStationService;

/**
 * 充电站Service业务层处理
 *
 * @author ruoyi
 */
@Service
public class ChargingStationServiceImpl implements IChargingStationService
{
    @Autowired
    private ChargingStationMapper chargingStationMapper;

    /**
     * 查询充电站
     */
    @Override
    public ChargingStation selectChargingStationById(Long stationId)
    {
        return chargingStationMapper.selectChargingStationById(stationId);
    }

    /**
     * 查询充电站列表
     */
    @Override
    public List<ChargingStation> selectChargingStationList(ChargingStation station)
    {
        return chargingStationMapper.selectChargingStationList(station);
    }

    /**
     * 根据商户ID查询充电站列表
     */
    @Override
    public List<ChargingStation> selectChargingStationListByMerchantId(Long merchantId)
    {
        return chargingStationMapper.selectChargingStationListByMerchantId(merchantId);
    }

    /**
     * 新增充电站
     */
    @Override
    public int insertChargingStation(ChargingStation station)
    {
        return chargingStationMapper.insertChargingStation(station);
    }

    /**
     * 修改充电站
     */
    @Override
    public int updateChargingStation(ChargingStation station)
    {
        return chargingStationMapper.updateChargingStation(station);
    }

    /**
     * 批量删除充电站
     */
    @Override
    public int deleteChargingStationByIds(Long[] stationIds)
    {
        int rows = 0;
        for (Long stationId : stationIds)
        {
            rows += chargingStationMapper.deleteChargingStationById(stationId);
        }
        return rows;
    }

    /**
     * 删除充电站信息
     */
    @Override
    public int deleteChargingStationById(Long stationId)
    {
        return chargingStationMapper.deleteChargingStationById(stationId);
    }
}
