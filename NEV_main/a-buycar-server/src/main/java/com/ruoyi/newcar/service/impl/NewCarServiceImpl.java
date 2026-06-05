package com.ruoyi.newcar.service.impl;

import com.ruoyi.newcar.domain.NewCar;
import com.ruoyi.newcar.mapper.NewCarMapper;
import com.ruoyi.newcar.service.NewCarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NewCarServiceImpl implements NewCarService {

    @Autowired
    private NewCarMapper newCarMapper;

    @Override
    public List<NewCar> selectCarList(NewCar newCar) {
        return newCarMapper.selectCarList(newCar);
    }

    @Override
    public NewCar selectCarById(Long vehicleId) {
        return newCarMapper.selectCarById(vehicleId);
    }
}