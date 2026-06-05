package com.ruoyi.newcar.service;

import java.util.List;
import java.util.Map;

public interface UsedCarService {
    List<Map<String, Object>> selectUsedCarList(Object param);
    Map<String, Object> selectUsedCarById(Long vehicleId);
}