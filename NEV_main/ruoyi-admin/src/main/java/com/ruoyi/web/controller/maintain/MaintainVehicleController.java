package com.ruoyi.web.controller.maintain;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.R;
import com.ruoyi.domain.Vehicle;
import com.ruoyi.service.VehicleService;
import com.ruoyi.vo.PageVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 维保模块车辆接口（供移动端维保预约页面使用）
 */
@RestController
@RequestMapping("/maintenance/vehicle")
public class MaintainVehicleController extends BaseController {

    @Autowired
    private VehicleService vehicleService;

    @GetMapping("/list")
    public R list(Integer pageNum, Integer pageSize, String vehicleType) {
        PageHelper.startPage(pageNum, pageSize);
        Vehicle query = new Vehicle();
        query.setVehicleType(vehicleType);
        List<Vehicle> list = vehicleService.selectVehicleList(query);
        PageInfo<Vehicle> pageInfo = new PageInfo<>(list);
        return R.ok(new PageVO<>(pageInfo.getList(), pageInfo.getTotal()));
    }
}
