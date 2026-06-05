package com.ruoyi.newcar.service;
import com.ruoyi.newcar.domain.NewCar;

import java.util.List;

public interface NewCarService {
    List<NewCar> selectCarList(NewCar newCar);
    NewCar selectCarById(Long vehicleId);
}