package com.ruoyi.web.controller.business;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.business.domain.StadChargingOrder;
import com.ruoyi.business.service.IStadChargingOrderService;

@RestController
@RequestMapping("/business/order")
public class StadChargingOrderController extends BaseController {

    @Autowired
    private IStadChargingOrderService stadChargingOrderService;

    @PreAuthorize("@ss.hasPermi('business:order:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadChargingOrder order) {
        startPage();
        List<StadChargingOrder> list = stadChargingOrderService.selectStadChargingOrderList(order);
        return getDataTable(list);
    }

    @GetMapping(value = "/{orderId}")
    public AjaxResult getInfo(@PathVariable Long orderId) {
        return success(stadChargingOrderService.selectStadChargingOrderById(orderId));
    }

    @PreAuthorize("@ss.hasPermi('business:order:add')")
    @Log(title = "充电订单管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody StadChargingOrder order) {
        order.setCreateBy(getUsername());
        return toAjax(stadChargingOrderService.insertStadChargingOrder(order));
    }

    @PreAuthorize("@ss.hasPermi('business:order:edit')")
    @Log(title = "充电订单管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody StadChargingOrder order) {
        order.setUpdateBy(getUsername());
        return toAjax(stadChargingOrderService.updateStadChargingOrder(order));
    }

    @PreAuthorize("@ss.hasPermi('business:order:remove')")
    @Log(title = "充电订单管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{orderIds}")
    public AjaxResult remove(@PathVariable Long[] orderIds) {
        return toAjax(stadChargingOrderService.deleteStadChargingOrderByIds(orderIds));
    }
}