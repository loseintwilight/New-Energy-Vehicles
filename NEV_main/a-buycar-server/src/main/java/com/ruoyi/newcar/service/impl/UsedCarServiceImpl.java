package com.ruoyi.newcar.service.impl;

import com.ruoyi.newcar.domain.NewCar;
import com.ruoyi.newcar.domain.UsedCar;
import com.ruoyi.newcar.mapper.NewCarMapper;
import com.ruoyi.newcar.mapper.UsedCarMapper;
import com.ruoyi.newcar.service.UsedCarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class UsedCarServiceImpl implements UsedCarService {

    @Autowired
    private NewCarMapper newCarMapper;

    @Autowired
    private UsedCarMapper usedCarMapper;

    @Override
    public List<Map<String, Object>> selectUsedCarList(Object param) {
        List<NewCar> cars = newCarMapper.selectUsedCars();

        List<Map<String, Object>> result = new ArrayList<>();
        for (NewCar car : cars) {
            UsedCar uc = usedCarMapper.selectByVehicleId(car.getVehicleId());
            result.add(combineCarAndUsed(car, uc));
        }
        return result;
    }

    @Override
    public Map<String, Object> selectUsedCarById(Long vehicleId) {
        NewCar car = newCarMapper.selectCarById(vehicleId);
        if (car == null) {
            return null;
        }
        UsedCar uc = usedCarMapper.selectByVehicleId(vehicleId);
        return combineCarAndUsed(car, uc);
    }

    private Map<String, Object> combineCarAndUsed(NewCar car, UsedCar uc) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("vehicleId", car.getVehicleId());
        map.put("vehicleType", car.getVehicleType());
        map.put("modelName", car.getModelName());
        map.put("title", car.getTitle());
        map.put("guidePrice", car.getGuidePrice());
        map.put("originalPrice", car.getOriginalPrice());
        map.put("color", car.getColor());
        map.put("stock", car.getStock());
        map.put("merchantId", car.getMerchantId());
        map.put("description", car.getDescription());
        map.put("tags", car.getTags());
        map.put("viewCount", car.getViewCount());
        map.put("status", car.getStatus());
        map.put("publishTime", car.getPublishTime());

        if (uc != null) {
            map.put("usedId", uc.getUsedId());
            map.put("licenseYear", uc.getLicenseYear());
            map.put("licenseMonth", uc.getLicenseMonth());
            map.put("licenseCity", uc.getLicenseCity());
            map.put("mileage", uc.getMileage());
            map.put("transferCount", uc.getTransferCount());
            map.put("batterySoh", uc.getBatterySoh());
            map.put("batteryCycles", uc.getBatteryCycles());
            map.put("batteryDiagnosis", uc.getBatteryDiagnosis());
            map.put("batteryReport", uc.getBatteryReport());
            map.put("valuationPrice", uc.getValuationPrice());
            map.put("valuationInfo", uc.getValuationInfo());
        }
        return map;
    }
}