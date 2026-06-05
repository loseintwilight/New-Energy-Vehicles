package com.ruoyi.newcar.mapper;

import java.util.List;

public interface ConfigMapper {
    List<String> selectCities();
    List<String> selectStores();
    List<String> selectDistinctColors();
    List<String> selectDistinctModels();
}