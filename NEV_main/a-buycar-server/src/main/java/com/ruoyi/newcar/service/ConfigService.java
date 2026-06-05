package com.ruoyi.newcar.service;

import java.util.List;

public interface ConfigService {
    List<String> selectCities();
    List<String> selectStores();
    List<String> selectDistinctColors();
    List<String> selectDistinctModels();
}