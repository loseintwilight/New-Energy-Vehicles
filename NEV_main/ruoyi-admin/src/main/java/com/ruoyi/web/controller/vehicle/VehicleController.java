package com.ruoyi.web.controller.vehicle;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.R;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.domain.Vehicle;
import com.ruoyi.service.VehicleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @Description: 车辆管理
 * @Author: 刘文丽
 * @CreateTime: 2026-06-05 21:19
 */
@RestController
@RequestMapping("/merchant/vehicle")
public class VehicleController extends BaseController {

    @Autowired
    private VehicleService vehicleService;

//    查询车辆列表
    @GetMapping("/list")
    public TableDataInfo list(Vehicle vehicle) {
        startPage();
        List<Vehicle> list = vehicleService.selectVehicleList(vehicle);
        return getDataTable(list);
    }

//    获取车辆详细信息
    @GetMapping("/{vehicleId}")
    public R getInfo(@PathVariable Long vehicleId) {
        return R.success(vehicleService.selectVehicleDetailById(vehicleId));
    }

//    获取车辆详情
    @GetMapping("/detail/{vehicleId}")
    public R detail(@PathVariable Long vehicleId) {
        return R.success(vehicleService.selectVehicleDetailById(vehicleId));
    }

//    新增车辆
    @PostMapping
    public R add(@Validated @RequestBody Vehicle vehicle) {
        vehicle.setCreateBy(getUsername());
        int rows = vehicleService.insertVehicle(vehicle);
        if (rows <= 0) {
            return R.fail("车辆添加失败");
        }
        // 如果有规格数据，同时写入规格表
        if (vehicle.getVehicleSpec() != null) {
            Vehicle.VehicleSpec spec = vehicle.getVehicleSpec();
            spec.setVehicleId(vehicle.getVehicleId());
            vehicleService.insertVehicleSpec(spec);
        }
        return R.success("车辆添加成功");
    }

//    修改车辆
    @PutMapping
    public R edit(@Validated @RequestBody Vehicle vehicle) {
        vehicle.setUpdateBy(getUsername());
        int rows = vehicleService.updateVehicle(vehicle);
        if (rows <= 0) {
            return R.fail("车辆更新失败，请检查车辆ID是否正确");
        }
        return R.success("车辆更新成功");
    }

//    删除车辆
    @DeleteMapping("/{vehicleIds}")
    public R remove(@PathVariable Long[] vehicleIds) {
        int rows = vehicleService.deleteVehicleByIds(vehicleIds);
        return rows > 0 ? R.success("删除成功") : R.fail("删除失败");
    }

//    仪表盘统计
    @GetMapping("/dashboard")
    public R dashboard() {
        return R.success(vehicleService.getDashboardStats());
    }

//    查询销售数据
    @GetMapping("/{vehicleId}/sales")
    public R getVehicleSales(@PathVariable Long vehicleId) {
        return R.success(vehicleService.getVehicleSales(vehicleId));
    }

//    电池诊断查询
    @GetMapping("/{vehicleId}/battery")
    public R batteryDiagnosis(@PathVariable Long vehicleId) {
        return R.success(vehicleService.selectVehicleBatteryDiagnosis(vehicleId));
    }

}

