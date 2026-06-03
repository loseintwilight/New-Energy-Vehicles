package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadVehicleSpec;

public interface IStadVehicleSpecService {
    StadVehicleSpec selectStadVehicleSpecById(Long specId);
    List<StadVehicleSpec> selectStadVehicleSpecList(StadVehicleSpec spec);
    List<StadVehicleSpec> selectStadVehicleSpecByVehicleId(Long vehicleId);
    int insertStadVehicleSpec(StadVehicleSpec spec);
    int updateStadVehicleSpec(StadVehicleSpec spec);
    int deleteStadVehicleSpecByIds(Long[] specIds);
}