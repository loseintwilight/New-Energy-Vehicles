package com.ruoyi.newcar.service.impl;


import com.ruoyi.newcar.mapper.ConfigMapper;
import com.ruoyi.newcar.service.ConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
/**
 * @Classname a
 * @Description
 * @Date 2026/6/4 10:01
 * @Created by 丁宗勇
 */

@Service
public class ConfigServiceImpl implements ConfigService {

    @Autowired
    private ConfigMapper configMapper;

    @Override
    public List<String> selectCities() {
        return configMapper.selectCities();
    }

    @Override
    public List<String> selectStores() {
        return configMapper.selectStores();
    }

    @Override
    public List<String> selectDistinctColors() {
        return configMapper.selectDistinctColors();
    }

    @Override
    public List<String> selectDistinctModels() {
        return configMapper.selectDistinctModels();
    }
}