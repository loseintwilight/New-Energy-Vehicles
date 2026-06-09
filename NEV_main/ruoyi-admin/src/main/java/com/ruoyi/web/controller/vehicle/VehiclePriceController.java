package com.ruoyi.web.controller.vehicle;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ruoyi.business.domain.StadVehicle;
import com.ruoyi.business.service.IStadVehicleService;
import com.ruoyi.common.core.domain.R;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;


/**
 * @Description: 价格管理
 * @Author: 刘文丽
 * @CreateTime: 2026-06-06 01:20
 */
@RestController
@RequestMapping("/business/price")
public class VehiclePriceController {

    @Autowired
    private IStadVehicleService stadVehicleService;

//    分页查询车辆价格列表
    @GetMapping("/list")
    public R getPriceList(String keyword, Integer pageNum, Integer pageSize) {
        pageNum = (pageNum == null) ? 1 : pageNum;
        pageSize = (pageSize == null) ? 10 : pageSize;
        PageHelper.startPage(pageNum, pageSize);
        StadVehicle query = new StadVehicle();
        query.setModelName(keyword);
        List<StadVehicle> list = stadVehicleService.selectStadVehicleList(query);
        PageInfo<StadVehicle> pageInfo = new PageInfo<>(list);
        return R.success(pageInfo);
    }

//    获取车辆价格详情
    @GetMapping("/{vehicleId}")
    public R getPrice(@PathVariable Long vehicleId) {
        StadVehicle vehicle = stadVehicleService.selectStadVehicleById(vehicleId);
        return R.success(vehicle);
    }

//    更新车辆价格
    @PutMapping
    public R updatePrice(@RequestBody StadVehicle vehicle) {
        int rows = stadVehicleService.updateStadVehicle(vehicle);
        return rows > 0 ? R.success("修改成功") : R.fail("修改失败");
    }
}
