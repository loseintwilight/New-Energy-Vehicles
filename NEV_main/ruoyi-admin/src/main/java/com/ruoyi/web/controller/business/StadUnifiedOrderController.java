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
import com.ruoyi.business.domain.StadUnifiedOrder;
import com.ruoyi.business.service.IStadUnifiedOrderService;

@RestController
@RequestMapping("/business/unified/order")
public class StadUnifiedOrderController extends BaseController {

    @Autowired
    private IStadUnifiedOrderService stadUnifiedOrderService;

    @PreAuthorize("@ss.hasPermi('business:uorder:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadUnifiedOrder order) {
        startPage();
        List<StadUnifiedOrder> list = stadUnifiedOrderService.selectStadUnifiedOrderList(order);
        return getDataTable(list);
    }

    @GetMapping(value = "/{orderId}")
    public AjaxResult getInfo(@PathVariable Long orderId) {
        return success(stadUnifiedOrderService.selectStadUnifiedOrderById(orderId));
    }

    @PreAuthorize("@ss.hasPermi('business:uorder:add')")
    @Log(title = "购车订单管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody StadUnifiedOrder order) {
        order.setCreateBy(getUsername());
        return toAjax(stadUnifiedOrderService.insertStadUnifiedOrder(order));
    }

    @PreAuthorize("@ss.hasPermi('business:uorder:edit')")
    @Log(title = "购车订单管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody StadUnifiedOrder order) {
        order.setUpdateBy(getUsername());
        return toAjax(stadUnifiedOrderService.updateStadUnifiedOrder(order));
    }

    @PreAuthorize("@ss.hasPermi('business:uorder:remove')")
    @Log(title = "购车订单管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{orderIds}")
    public AjaxResult remove(@PathVariable Long[] orderIds) {
        return toAjax(stadUnifiedOrderService.deleteStadUnifiedOrderByIds(orderIds));
    }
}