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
import com.ruoyi.business.domain.StadMaintenanceOrder;
import com.ruoyi.business.service.IStadMaintenanceOrderService;

@RestController
@RequestMapping("/business/maintenance/order")
public class StadMaintenanceOrderController extends BaseController {

    @Autowired
    private IStadMaintenanceOrderService stadMaintenanceOrderService;

    @PreAuthorize("@ss.hasPermi('business:morder:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadMaintenanceOrder order) {
        startPage();
        List<StadMaintenanceOrder> list = stadMaintenanceOrderService.selectStadMaintenanceOrderList(order);
        return getDataTable(list);
    }

    @GetMapping(value = "/{orderId}")
    public AjaxResult getInfo(@PathVariable Long orderId) {
        return success(stadMaintenanceOrderService.selectStadMaintenanceOrderById(orderId));
    }

    @PreAuthorize("@ss.hasPermi('business:morder:add')")
    @Log(title = "维保订单管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody StadMaintenanceOrder order) {
        order.setCreateBy(getUsername());
        return toAjax(stadMaintenanceOrderService.insertStadMaintenanceOrder(order));
    }

    @PreAuthorize("@ss.hasPermi('business:morder:edit')")
    @Log(title = "维保订单管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody StadMaintenanceOrder order) {
        order.setUpdateBy(getUsername());
        return toAjax(stadMaintenanceOrderService.updateStadMaintenanceOrder(order));
    }

    @PreAuthorize("@ss.hasPermi('business:morder:remove')")
    @Log(title = "维保订单管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{orderIds}")
    public AjaxResult remove(@PathVariable Long[] orderIds) {
        return toAjax(stadMaintenanceOrderService.deleteStadMaintenanceOrderByIds(orderIds));
    }
}