package com.ruoyi.web.controller.car;

import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.SecurityUtils;
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
import com.ruoyi.business.domain.StadUnifiedOrder;
import com.ruoyi.business.service.IStadUnifiedOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
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

    @Autowired
    private IStadUnifiedOrderService stadUnifiedOrderService;

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
        StadUnifiedOrder order = new StadUnifiedOrder();

        // 生成订单号 PUR + 年月日时分秒 + 4位随机数
        String orderNo = "PUR" + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())
                + String.format("%04d", (int)(Math.random() * 10000));
        order.setOrderNo(orderNo);
        order.setOrderType("purchase");

        // 用户ID
        try {
            order.setUserId(SecurityUtils.getUserId());
        } catch (Exception ignored) {}

        if (params.get("vehicleId") != null) {
            order.setVehicleId(Long.valueOf(params.get("vehicleId").toString()));
        }
        if (params.get("vehiclePrice") != null) {
            order.setVehiclePrice(new BigDecimal(params.get("vehiclePrice").toString()));
        }
        if (params.get("totalAmount") != null) {
            order.setTotalAmount(new BigDecimal(params.get("totalAmount").toString()));
        }
        if (params.get("contactName") != null) {
            order.setContactName(params.get("contactName").toString());
        }
        if (params.get("contactPhone") != null) {
            order.setContactPhone(params.get("contactPhone").toString());
        }
        if (params.get("paymentMethod") != null) {
            order.setPaymentMethod(params.get("paymentMethod").toString());
        }
        if (params.get("insuranceInfo") != null) {
            order.setInsuranceInfo(params.get("insuranceInfo").toString());
        }
        order.setStatus("0");

        int result = stadUnifiedOrderService.insertStadUnifiedOrder(order);
        if (result > 0) {
            Map<String, Object> data = new HashMap<>();
            data.put("orderId", order.getOrderId());
            data.put("orderNo", order.getOrderNo());
            return AjaxResult.success("订购成功", data);
        }
        return AjaxResult.error("订购失败，请重试");
    }

    @PostMapping("/tradein/evaluate")
    public AjaxResult evaluate(@RequestBody Map<String, Object> params) {
        Map<String, Object> result = new HashMap<>();
        result.put("valuation", 3.50);
        return AjaxResult.success(result);
    }

    @PostMapping("/tradein/order/create")
    public AjaxResult createTradeInOrder(@RequestBody Map<String, Object> params) {
        StadUnifiedOrder order = new StadUnifiedOrder();

        String orderNo = "TIN" + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())
                + String.format("%04d", (int)(Math.random() * 10000));
        order.setOrderNo(orderNo);
        order.setOrderType("trade_in");

        try {
            order.setUserId(SecurityUtils.getUserId());
        } catch (Exception ignored) {}

        if (params.get("contactName") != null) {
            order.setContactName(params.get("contactName").toString());
        }
        if (params.get("contactPhone") != null) {
            order.setContactPhone(params.get("contactPhone").toString());
        }
        if (params.get("oldValuation") != null) {
            order.setOldValuation(new BigDecimal(params.get("oldValuation").toString()));
        }
        // 保存旧车详细信息到 insurance_info（PC端购车订单菜单可见）
        StringBuilder oldCarInfo = new StringBuilder();
        if (params.get("oldVehicleBrand") != null) oldCarInfo.append("品牌:").append(params.get("oldVehicleBrand")).append(";");
        if (params.get("oldVehicleModel") != null) oldCarInfo.append("车型:").append(params.get("oldVehicleModel")).append(";");
        if (params.get("oldVehicleYear") != null) oldCarInfo.append("年份:").append(params.get("oldVehicleYear")).append(";");
        if (params.get("mileage") != null) oldCarInfo.append("里程:").append(params.get("mileage")).append(";");
        if (params.get("condition") != null) oldCarInfo.append("车况:").append(params.get("condition")).append(";");
        if (params.get("storeName") != null) oldCarInfo.append("门店:").append(params.get("storeName"));
        if (oldCarInfo.length() > 0) {
            order.setInsuranceInfo(oldCarInfo.toString());
        }
        // 关联新车信息
        if (params.get("newVehicleId") != null) {
            try {
                order.setVehicleId(Long.valueOf(params.get("newVehicleId").toString()));
            } catch (Exception ignored) {
                order.setVehicleId(1L);
            }
        } else {
            order.setVehicleId(1L);
        }
        if (params.get("newVehiclePrice") != null) {
            try {
                order.setVehiclePrice(new BigDecimal(params.get("newVehiclePrice").toString()));
            } catch (Exception ignored) {}
        }
        // 如果前端没传新车价格，从新车表查询（guidePrice已是元）
        if (order.getVehiclePrice() == null && order.getVehicleId() != null) {
            try {
                NewCar nc = newCarService.selectCarById(order.getVehicleId());
                if (nc != null && nc.getGuidePrice() != null) {
                    order.setVehiclePrice(BigDecimal.valueOf(nc.getGuidePrice()));
                }
            } catch (Exception ignored) {}
        }
        if (params.get("newVehicleModel") != null) {
            // 新车车型名暂存到 expectTimeSlot 字段中
            order.setExpectTimeSlot(params.get("newVehicleModel").toString());
        }
        // 如果前端没传车型名，从新车表查询
        if ((order.getExpectTimeSlot() == null || order.getExpectTimeSlot().isEmpty()) && order.getVehicleId() != null) {
            try {
                NewCar nc = newCarService.selectCarById(order.getVehicleId());
                if (nc != null && nc.getModelName() != null) {
                    order.setExpectTimeSlot(nc.getModelName());
                }
            } catch (Exception ignored) {}
        }
        // 订单总金额（元）= 新车价格(元) - 旧车估值(元)
        if (order.getVehiclePrice() != null && order.getOldValuation() != null) {
            BigDecimal total = order.getVehiclePrice().subtract(order.getOldValuation());
            order.setTotalAmount(total.compareTo(BigDecimal.ZERO) > 0 ? total : BigDecimal.ZERO);
        }
        order.setStatus("0");

        int result = stadUnifiedOrderService.insertStadUnifiedOrder(order);
        if (result > 0) {
            Map<String, Object> data = new HashMap<>();
            data.put("orderId", order.getOrderId());
            data.put("orderNo", order.getOrderNo());
            return AjaxResult.success("申请成功", data);
        }
        return AjaxResult.error("申请失败，请重试");
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