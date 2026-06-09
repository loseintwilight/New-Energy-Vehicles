package com.ruoyi.web.controller.mine;

import com.ruoyi.business.domain.StadMaintenanceOrder;
import com.ruoyi.business.service.IStadMaintenanceOrderService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/app/reservation")
public class AppReservationController extends BaseController {

    @Autowired
    private IStadMaintenanceOrderService stadMaintenanceOrderService;

    /**
     * 获取预约列表
     */
    @GetMapping("/list")
    public TableDataInfo getReservationList(StadMaintenanceOrder order) {
        startPage();
        Long userId = SecurityUtils.getUserId();
        List<Map<String, Object>> resultList = stadMaintenanceOrderService.getFormattedReservationList(userId, order);
        return getDataTable(resultList);
    }

    /**
     * 获取预约详情
     */
    @GetMapping("/{id}")
    public AjaxResult getReservationDetail(@PathVariable Long id) {
        Map<String, Object> result = stadMaintenanceOrderService.getFormattedReservationDetail(id);
        if (result == null) {
            return AjaxResult.error("预约订单不存在");
        }
        return AjaxResult.success(result);
    }

    /**
     * 取消预约
     */
    @PutMapping("/cancel/{id}")
    public AjaxResult cancelReservation(@PathVariable Long id) {
        boolean success = stadMaintenanceOrderService.cancelReservation(id);
        if (!success) {
            return AjaxResult.error("取消失败，订单不存在或当前状态无法取消");
        }
        return AjaxResult.success("预约已取消");
    }

    /**
     * 创建预约
     */
    @PostMapping
    public AjaxResult createReservation(@RequestBody Map<String, Object> data) {
        Long userId = SecurityUtils.getUserId();
        boolean success = stadMaintenanceOrderService.createReservation(userId, data);
        if (!success) {
            return AjaxResult.error("预约失败");
        }
        return AjaxResult.success("预约成功");
    }
}
