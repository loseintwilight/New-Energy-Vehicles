package com.ruoyi.web.controller.maintain;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ruoyi.business.domain.StadMaintenanceOrder;
import com.ruoyi.business.service.IStadMaintenanceOrderService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.R;
import com.ruoyi.service.MaintenanceOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/maintenance/order")
public class MaintainOrderController extends BaseController {

    @Autowired
    private IStadMaintenanceOrderService orderService;

    @Autowired
    private MaintenanceOrderService maintenanceOrderService;

    @GetMapping("/list")
    public R list(Integer pageNum, Integer pageSize, String orderStatus) {
        PageHelper.startPage(pageNum, pageSize);
        StadMaintenanceOrder query = new StadMaintenanceOrder();
        query.setOrderStatus(orderStatus);
        List<StadMaintenanceOrder> list = orderService.selectStadMaintenanceOrderList(query);
        PageInfo<StadMaintenanceOrder> pageInfo = new PageInfo<>(list);
        return R.ok(pageInfo);
    }

    @GetMapping("/detail")
    public R detail(@RequestParam("order_id") Long orderId) {
        StadMaintenanceOrder order = orderService.selectStadMaintenanceOrderById(orderId);
        return R.ok(order);
    }

    @GetMapping("/stats")
    public R stats() {
        return R.ok(maintenanceOrderService.selectOrderStats());
    }

    @GetMapping("/reviews")
    public R reviews(Integer pageNum, Integer pageSize, String orderStatus) {
        PageHelper.startPage(pageNum, pageSize);
        StadMaintenanceOrder query = new StadMaintenanceOrder();
        query.setOrderStatus(orderStatus);
        List<StadMaintenanceOrder> list = maintenanceOrderService.selectStadMaintenanceOrderReviewList(query);
        PageInfo<StadMaintenanceOrder> pageInfo = new PageInfo<>(list);
        return R.ok(pageInfo);
    }

    @PostMapping("/create")
    public R create(@RequestBody Map<String, Object> params) {
        StadMaintenanceOrder order = new StadMaintenanceOrder();

        // 生成订单编号
        String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String random = String.valueOf(UUID.randomUUID().toString().hashCode()).replace("-", "").substring(0, 6);
        String orderNo = "WH" + today + random;
        order.setOrderNo(orderNo);

        // 必填字段
        order.setUserId(Long.valueOf(params.get("user_id").toString()));
        order.setShopId(Long.valueOf(params.get("shop_id").toString()));
        order.setVehicleId(Long.valueOf(params.get("vehicle_id").toString()));
        order.setServiceItem((String) params.get("service_item"));
        order.setServicePrice(new BigDecimal(params.get("service_price").toString()));
        order.setTotalAmount(new BigDecimal(params.get("total_amount").toString()));

        // 预约时间
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            order.setExpectDate(sdf.parse((String) params.get("expect_date")));
        } catch (Exception e) {
            order.setExpectDate(new Date());
        }
        order.setExpectTimeSlot((String) params.get("expect_time_slot"));

        // 默认值
        order.setPaidAmount(BigDecimal.ZERO);
        order.setOrderStatus("0");
        order.setPayStatus("0");

        int rows = orderService.insertStadMaintenanceOrder(order);
        return rows > 0 ? R.ok(order.getOrderId(), "预约成功") : R.fail("预约失败");
    }

    @PostMapping("/cancel")
    public R cancel(@RequestBody Map<String, Object> params) {
        Long orderId = Long.valueOf(params.get("order_id").toString());
        String cancelReason = (String) params.getOrDefault("cancel_reason", "用户主动取消");

        StadMaintenanceOrder order = new StadMaintenanceOrder();
        order.setOrderId(orderId);
        order.setOrderStatus("4");
        order.setCancelReason(cancelReason);

        int rows = orderService.updateStadMaintenanceOrder(order);
        return rows > 0 ? R.ok("取消成功") : R.fail("取消失败");
    }

    @PostMapping("/update")
    public R update(@RequestBody Map<String, Object> params) {
        StadMaintenanceOrder order = new StadMaintenanceOrder();
        order.setOrderId(Long.valueOf(params.get("order_id").toString()));

        if (params.containsKey("service_item")) {
            order.setServiceItem((String) params.get("service_item"));
        }
        if (params.containsKey("service_price")) {
            order.setServicePrice(new BigDecimal(params.get("service_price").toString()));
        }
        if (params.containsKey("total_amount")) {
            order.setTotalAmount(new BigDecimal(params.get("total_amount").toString()));
        }
        if (params.containsKey("expect_date")) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                order.setExpectDate(sdf.parse((String) params.get("expect_date")));
            } catch (Exception e) {
                // ignore
            }
        }
        if (params.containsKey("order_status")) {
            order.setOrderStatus((String) params.get("order_status"));
        }
        if (params.containsKey("expect_time_slot")) {
            order.setExpectTimeSlot((String) params.get("expect_time_slot"));
        }
        if (params.containsKey("pay_status")) {
            order.setPayStatus((String) params.get("pay_status"));
        }
        if (params.containsKey("paid_amount")) {
            order.setPaidAmount(new BigDecimal(params.get("paid_amount").toString()));
        }
        if (params.containsKey("payment_method")) {
            order.setPaymentMethod((String) params.get("payment_method"));
        }

        int rows = orderService.updateStadMaintenanceOrder(order);
        return rows > 0 ? R.ok("修改成功") : R.fail("修改失败");
    }
}