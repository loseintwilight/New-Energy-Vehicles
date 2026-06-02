package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadVehicleUsedMapper;
import com.ruoyi.business.domain.StadVehicleUsed;
import com.ruoyi.business.service.IStadVehicleUsedService;

@Service
public class StadVehicleUsedServiceImpl implements IStadVehicleUsedService {

    @Autowired
    private StadVehicleUsedMapper stadVehicleUsedMapper;

    @Override
    public StadVehicleUsed selectStadVehicleUsedById(Long usedId) {
        return stadVehicleUsedMapper.selectStadVehicleUsedById(usedId);
    }

    @Override
    public List<StadVehicleUsed> selectStadVehicleUsedList(StadVehicleUsed used) {
        return stadVehicleUsedMapper.selectStadVehicleUsedList(used);
    }

    @Override
    public StadVehicleUsed selectStadVehicleUsedByVehicleId(Long vehicleId) {
        return stadVehicleUsedMapper.selectStadVehicleUsedByVehicleId(vehicleId);
    }

    @Override
    public int insertStadVehicleUsed(StadVehicleUsed used) {
        return stadVehicleUsedMapper.insertStadVehicleUsed(used);
    }

    @Override
    public int updateStadVehicleUsed(StadVehicleUsed used) {
        return stadVehicleUsedMapper.updateStadVehicleUsed(used);
    }

    @Override
    public int deleteStadVehicleUsedByIds(Long[] usedIds) {
        return stadVehicleUsedMapper.deleteStadVehicleUsedByIds(usedIds);
    }
}