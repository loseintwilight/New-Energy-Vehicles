package com.ruoyi.charging.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.charging.domain.ChargingOrder;
import com.ruoyi.charging.service.IChargingOrderService;

/**
 * 充电订单Controller
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/app/charge/order")
public class AppChargingOrderController extends BaseController
{
    @Autowired
    private IChargingOrderService chargingOrderService;

    /**
     * 查询充电订单列表
     */
    @Anonymous
    @GetMapping("/list")
    public TableDataInfo list(ChargingOrder order)
    {
        startPage();
        List<ChargingOrder> list = chargingOrderService.selectChargingOrderList(order);
        return getDataTable(list);
    }

    /**
     * 获取充电订单详细信息
     */
    @Anonymous
    @GetMapping(value = "/{orderId}")
    public AjaxResult getInfo(@PathVariable("orderId") Long orderId)
    {
        return success(chargingOrderService.selectChargingOrderById(orderId));
    }

    /**
     * 根据订单号查询充电订单
     */
    @Anonymous
    @GetMapping("/orderNo/{orderNo}")
    public AjaxResult getInfoByOrderNo(@PathVariable("orderNo") String orderNo)
    {
        return success(chargingOrderService.selectChargingOrderByOrderNo(orderNo));
    }

    /**
     * 新增充电订单
     */
    @PostMapping
    public AjaxResult add(@RequestBody ChargingOrder order)
    {
        return toAjax(chargingOrderService.insertChargingOrder(order));
    }

    /**
     * 修改充电订单
     */
    @PutMapping
    public AjaxResult edit(@RequestBody ChargingOrder order)
    {
        return toAjax(chargingOrderService.updateChargingOrder(order));
    }

    /**
     * 删除充电订单
     */
    @DeleteMapping("/{orderIds}")
    public AjaxResult remove(@PathVariable Long[] orderIds)
    {
        return toAjax(chargingOrderService.deleteChargingOrderByIds(orderIds));
    }
}
