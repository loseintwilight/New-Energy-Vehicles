package com.ruoyi.web.controller.car;

import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.newcar.domain.NewCar;
import com.ruoyi.newcar.domain.FinancePlan;
import com.ruoyi.newcar.domain.VehicleReview;
import com.ruoyi.newcar.domain.VehicleSpec;
import com.ruoyi.newcar.service.NewCarService;
import com.ruoyi.newcar.service.UsedCarService;
import com.ruoyi.newcar.service.FinancePlanService;
import com.ruoyi.newcar.service.VehicleReviewService;
import com.ruoyi.newcar.service.VehicleSpecService;
import com.ruoyi.newcar.service.ConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Anonymous
@RestController
@RequestMapping("/car")
public class CarController extends BaseController {
    @Autowired
    private NewCarService newCarService;

    @Autowired
    private UsedCarService usedCarService;

    @Autowired
    private FinancePlanService financePlanService;

    @Autowired
    private VehicleReviewService vehicleReviewService;

    @Autowired
    private VehicleSpecService vehicleSpecService;

    @Autowired
    private ConfigService configService;

    @GetMapping("/list")
    public TableDataInfo list(NewCar newCar) {
        startPage();
        List<NewCar> list = newCarService.selectCarList(newCar);
        return getDataTable(list);
    }

    @GetMapping("/detail")
    public AjaxResult detail(Long id) {
        NewCar car = newCarService.selectCarById(id);
        return AjaxResult.success(car);
    }

    @GetMapping("/used/list")
    public TableDataInfo usedList() {
        startPage();
        List<Map<String, Object>> list = usedCarService.selectUsedCarList(null);
        return getDataTable(list);
    }

    @GetMapping("/used/detail")
    public AjaxResult usedDetail(Long id) {
        Map<String, Object> result = usedCarService.selectUsedCarById(id);
        return AjaxResult.success(result);
    }

    @GetMapping("/used/inspection")
    public AjaxResult inspection(Long id) {
        Map<String, Object> result = usedCarService.selectUsedCarById(id);
        return AjaxResult.success(result);
    }

    @PostMapping("/order/create")
    public AjaxResult createOrder(@RequestBody Map<String, Object> params) {
        return AjaxResult.success("订购成功");
    }

    @PostMapping("/tradein/evaluate")
    public AjaxResult evaluate(@RequestBody Map<String, Object> params) {
        Map<String, Object> result = new HashMap<>();
        result.put("valuation", 3.50);
        return AjaxResult.success(result);
    }

    @PostMapping("/tradein/order/create")
    public AjaxResult createTradeInOrder(@RequestBody Map<String, Object> params) {
        return AjaxResult.success("申请成功");
    }

    @GetMapping("/finance/plans")
    public AjaxResult financePlans(Long vehicleId) {
        List<FinancePlan> list = financePlanService.selectByVehicleId(vehicleId);
        return AjaxResult.success(list);
    }

    @GetMapping("/vehicle/specs")
    public AjaxResult vehicleSpecs(Long vehicleId) {
        VehicleSpec spec = vehicleSpecService.selectByVehicleId(vehicleId);
        return AjaxResult.success(spec);
    }

    @GetMapping("/vehicle/reviews")
    public AjaxResult vehicleReviews(Long vehicleId) {
        List<VehicleReview> list = vehicleReviewService.selectByVehicleId(vehicleId);
        return AjaxResult.success(list);
    }

    @GetMapping("/config/cities")
    public AjaxResult getCities() {
        List<String> cities = configService.selectCities();
        return AjaxResult.success(cities);
    }

    @GetMapping("/config/stores")
    public AjaxResult getStores() {
        List<String> stores = configService.selectStores();
        return AjaxResult.success(stores);
    }

    @GetMapping("/config/colors")
    public AjaxResult getColors() {
        List<String> colors = configService.selectDistinctColors();
        return AjaxResult.success(colors);
    }

    @GetMapping("/config/models")
    public AjaxResult getModels() {
        List<String> models = configService.selectDistinctModels();
        return AjaxResult.success(models);
    }
}