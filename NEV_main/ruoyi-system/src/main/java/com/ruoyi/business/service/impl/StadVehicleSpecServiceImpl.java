package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadVehicleSpecMapper;
import com.ruoyi.business.domain.StadVehicleSpec;
import com.ruoyi.business.service.IStadVehicleSpecService;

@Service
public class StadVehicleSpecServiceImpl implements IStadVehicleSpecService {

    @Autowired
    private StadVehicleSpecMapper stadVehicleSpecMapper;

    @Override
    public StadVehicleSpec selectStadVehicleSpecById(Long specId) {
        return stadVehicleSpecMapper.selectStadVehicleSpecById(specId);
    }

    @Override
    public List<StadVehicleSpec> selectStadVehicleSpecList(StadVehicleSpec spec) {
        return stadVehicleSpecMapper.selectStadVehicleSpecList(spec);
    }

    @Override
    public List<StadVehicleSpec> selectStadVehicleSpecByVehicleId(Long vehicleId) {
        return stadVehicleSpecMapper.selectStadVehicleSpecByVehicleId(vehicleId);
    }

    @Override
    public int insertStadVehicleSpec(StadVehicleSpec spec) {
        return stadVehicleSpecMapper.insertStadVehicleSpec(spec);
    }

    @Override
    public int updateStadVehicleSpec(StadVehicleSpec spec) {
        return stadVehicleSpecMapper.updateStadVehicleSpec(spec);
    }

    @Override
    public int deleteStadVehicleSpecByIds(Long[] specIds) {
        return stadVehicleSpecMapper.deleteStadVehicleSpecByIds(specIds);
    }
}