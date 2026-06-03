package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadVehicleUsed;

public interface StadVehicleUsedMapper {
    StadVehicleUsed selectStadVehicleUsedById(Long usedId);
    List<StadVehicleUsed> selectStadVehicleUsedList(StadVehicleUsed used);
    int insertStadVehicleUsed(StadVehicleUsed used);
    int updateStadVehicleUsed(StadVehicleUsed used);
    int deleteStadVehicleUsedById(Long usedId);
    int deleteStadVehicleUsedByIds(Long[] usedIds);
    StadVehicleUsed selectStadVehicleUsedByVehicleId(Long vehicleId);
}