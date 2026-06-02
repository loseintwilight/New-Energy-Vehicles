package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadVehicleSpec;

public interface StadVehicleSpecMapper {
    StadVehicleSpec selectStadVehicleSpecById(Long specId);
    List<StadVehicleSpec> selectStadVehicleSpecList(StadVehicleSpec spec);
    int insertStadVehicleSpec(StadVehicleSpec spec);
    int updateStadVehicleSpec(StadVehicleSpec spec);
    int deleteStadVehicleSpecById(Long specId);
    int deleteStadVehicleSpecByIds(Long[] specIds);
    List<StadVehicleSpec> selectStadVehicleSpecByVehicleId(Long vehicleId);
}