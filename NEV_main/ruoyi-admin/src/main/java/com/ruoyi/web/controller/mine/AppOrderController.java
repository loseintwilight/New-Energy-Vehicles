package com.ruoyi.web.controller.mine;

import com.ruoyi.mine.domain.MineStadUnifiedOrder;
import com.ruoyi.mine.service.IStadUnifiedOrderService;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 小程序订单管理
 */
@RestController
@RequestMapping("/app/order")
public class AppOrderController extends BaseController {

    @Autowired
    private IStadUnifiedOrderService stadUnifiedOrderService;

    /**
     * 获取订单列表
     */
    @GetMapping("/list")
    public TableDataInfo getOrderList(MineStadUnifiedOrder order) {
        startPage();
        Long userId = SecurityUtils.getUserId();
        order.setUserId(userId);
        return getDataTable(stadUnifiedOrderService.selectStadUnifiedOrderList(order));
    }

    /**
     * 获取订单详情
     */
    @GetMapping("/{id}")
    public AjaxResult getOrderDetail(@PathVariable Long id) {
        return AjaxResult.success(stadUnifiedOrderService.selectStadUnifiedOrderById(id));
    }

    /**
     * 取消订单
     */
    @Log(title = "订单", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/cancel")
    public AjaxResult cancelOrder(@PathVariable Long id) {
        MineStadUnifiedOrder order = new MineStadUnifiedOrder();
        order.setOrderId(id);
        order.setStatus("2");
        return toAjax(stadUnifiedOrderService.updateStadUnifiedOrder(order));
    }

    /**
     * 完成订单
     */
    @Log(title = "订单", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/complete")
    public AjaxResult completeOrder(@PathVariable Long id) {
        MineStadUnifiedOrder order = new MineStadUnifiedOrder();
        order.setOrderId(id);
        order.setStatus("1");
        return toAjax(stadUnifiedOrderService.updateStadUnifiedOrder(order));
    }

    /**
     * 删除订单
     */
    @Log(title = "订单", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public AjaxResult deleteOrder(@PathVariable Long id) {
        return toAjax(stadUnifiedOrderService.deleteStadUnifiedOrderById(id));
    }

    /**
     * 获取订单状态统计
     */
    @GetMapping("/status")
    public AjaxResult getOrderStatusCount() {
        Long userId = SecurityUtils.getUserId();
        Map<String, Object> countMap = stadUnifiedOrderService.getOrderStatusCount(userId);
        return AjaxResult.success(countMap);
    }
}
