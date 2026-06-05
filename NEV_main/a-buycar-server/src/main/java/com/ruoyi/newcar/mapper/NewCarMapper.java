package com.ruoyi.newcar.mapper;

import com.ruoyi.newcar.domain.NewCar;

import java.util.List;

public interface NewCarMapper {
    List<NewCar> selectCarList(NewCar newCar);

    NewCar selectCarById(Long vehicleId);

    List<NewCar> selectUsedCars();
}