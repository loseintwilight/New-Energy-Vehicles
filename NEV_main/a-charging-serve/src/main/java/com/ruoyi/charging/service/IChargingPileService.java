package com.ruoyi.charging.service;

import java.util.List;
import com.ruoyi.charging.domain.ChargingPile;

/**
 * 充电桩Service接口
 *
 * @author ruoyi
 */
public interface IChargingPileService
{
    /**
     * 查询充电桩
     */
    public ChargingPile selectChargingPileById(Long pileId);

    /**
     * 查询充电桩列表
     */
    public List<ChargingPile> selectChargingPileList(ChargingPile pile);

    /**
     * 根据站点ID查询充电桩列表
     */
    public List<ChargingPile> selectChargingPileListByStationId(Long stationId);

    /**
     * 新增充电桩
     */
    public int insertChargingPile(ChargingPile pile);

    /**
     * 修改充电桩
     */
    public int updateChargingPile(ChargingPile pile);

    /**
     * 批量删除充电桩
     */
    public int deleteChargingPileByIds(Long[] pileIds);

    /**
     * 删除充电桩信息
     */
    public int deleteChargingPileById(Long pileId);
}
