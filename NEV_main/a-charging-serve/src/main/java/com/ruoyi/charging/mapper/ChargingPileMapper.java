package com.ruoyi.charging.mapper;

import com.ruoyi.charging.domain.ChargingPile;
import java.util.List;

/**
 * 充电桩Mapper接口
 * 
 * @author ruoyi
 */
public interface ChargingPileMapper 
{
    public ChargingPile selectChargingPileById(Long pileId);

    public List<ChargingPile> selectChargingPileList(ChargingPile pile);

    public List<ChargingPile> selectChargingPileListByStationId(Long stationId);

    public int insertChargingPile(ChargingPile pile);

    public int updateChargingPile(ChargingPile pile);

    public int deleteChargingPileById(Long pileId);
}
