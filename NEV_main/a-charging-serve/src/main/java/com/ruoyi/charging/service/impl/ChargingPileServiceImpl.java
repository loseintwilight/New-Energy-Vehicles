package com.ruoyi.charging.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.charging.mapper.ChargingPileMapper;
import com.ruoyi.charging.domain.ChargingPile;
import com.ruoyi.charging.service.IChargingPileService;

/**
 * 充电桩Service业务层处理
 *
 * @author ruoyi
 */
@Service
public class ChargingPileServiceImpl implements IChargingPileService
{
    @Autowired
    private ChargingPileMapper chargingPileMapper;

    /**
     * 查询充电桩
     */
    @Override
    public ChargingPile selectChargingPileById(Long pileId)
    {
        return chargingPileMapper.selectChargingPileById(pileId);
    }

    /**
     * 查询充电桩列表
     */
    @Override
    public List<ChargingPile> selectChargingPileList(ChargingPile pile)
    {
        return chargingPileMapper.selectChargingPileList(pile);
    }

    /**
     * 根据站点ID查询充电桩列表
     */
    @Override
    public List<ChargingPile> selectChargingPileListByStationId(Long stationId)
    {
        return chargingPileMapper.selectChargingPileListByStationId(stationId);
    }

    /**
     * 新增充电桩
     */
    @Override
    public int insertChargingPile(ChargingPile pile)
    {
        return chargingPileMapper.insertChargingPile(pile);
    }

    /**
     * 修改充电桩
     */
    @Override
    public int updateChargingPile(ChargingPile pile)
    {
        return chargingPileMapper.updateChargingPile(pile);
    }

    /**
     * 批量删除充电桩
     */
    @Override
    public int deleteChargingPileByIds(Long[] pileIds)
    {
        int rows = 0;
        for (Long pileId : pileIds)
        {
            rows += chargingPileMapper.deleteChargingPileById(pileId);
        }
        return rows;
    }

    /**
     * 删除充电桩信息
     */
    @Override
    public int deleteChargingPileById(Long pileId)
    {
        return chargingPileMapper.deleteChargingPileById(pileId);
    }
}
