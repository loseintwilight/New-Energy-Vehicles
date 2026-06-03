package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadVehicleUsed;

public interface IStadVehicleUsedService {
    StadVehicleUsed selectStadVehicleUsedById(Long usedId);
    List<StadVehicleUsed> selectStadVehicleUsedList(StadVehicleUsed used);
    StadVehicleUsed selectStadVehicleUsedByVehicleId(Long vehicleId);
    int insertStadVehicleUsed(StadVehicleUsed used);
    int updateStadVehicleUsed(StadVehicleUsed used);
    int deleteStadVehicleUsedByIds(Long[] usedIds);
}