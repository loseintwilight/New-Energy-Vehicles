package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadChargingPileMapper;
import com.ruoyi.business.domain.StadChargingPile;
import com.ruoyi.business.service.IStadChargingPileService;

@Service
public class StadChargingPileServiceImpl implements IStadChargingPileService {

    @Autowired
    private StadChargingPileMapper stadChargingPileMapper;

    @Override
    public StadChargingPile selectStadChargingPileById(Long pileId) {
        return stadChargingPileMapper.selectStadChargingPileById(pileId);
    }

    @Override
    public List<StadChargingPile> selectStadChargingPileList(StadChargingPile pile) {
        return stadChargingPileMapper.selectStadChargingPileList(pile);
    }

    @Override
    public List<StadChargingPile> selectStadChargingPileByStationId(Long stationId) {
        return stadChargingPileMapper.selectStadChargingPileByStationId(stationId);
    }

    @Override
    public int insertStadChargingPile(StadChargingPile pile) {
        return stadChargingPileMapper.insertStadChargingPile(pile);
    }

    @Override
    public int updateStadChargingPile(StadChargingPile pile) {
        return stadChargingPileMapper.updateStadChargingPile(pile);
    }

    @Override
    public int deleteStadChargingPileByIds(Long[] pileIds) {
        return stadChargingPileMapper.deleteStadChargingPileByIds(pileIds);
    }
}