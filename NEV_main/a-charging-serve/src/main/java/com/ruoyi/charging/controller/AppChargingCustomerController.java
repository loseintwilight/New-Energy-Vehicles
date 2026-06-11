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
import com.ruoyi.charging.domain.ChargingCustomer;
import com.ruoyi.charging.service.IChargingCustomerService;

/**
 * 充电客户Controller
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/app/charge/customer")
public class AppChargingCustomerController extends BaseController
{
    @Autowired
    private IChargingCustomerService chargingCustomerService;

    /**
     * 查询充电客户列表
     */
    @Anonymous
    @GetMapping("/list")
    public TableDataInfo list(ChargingCustomer customer)
    {
        startPage();
        List<ChargingCustomer> list = chargingCustomerService.selectChargingCustomerList(customer);
        return getDataTable(list);
    }

    /**
     * 获取充电客户详细信息
     */
    @Anonymous
    @GetMapping(value = "/{customerId}")
    public AjaxResult getInfo(@PathVariable("customerId") Long customerId)
    {
        return success(chargingCustomerService.selectChargingCustomerById(customerId));
    }

    /**
     * 新增充电客户
     */
    @PostMapping
    public AjaxResult add(@RequestBody ChargingCustomer customer)
    {
        return toAjax(chargingCustomerService.insertChargingCustomer(customer));
    }

    /**
     * 修改充电客户
     */
    @PutMapping
    public AjaxResult edit(@RequestBody ChargingCustomer customer)
    {
        return toAjax(chargingCustomerService.updateChargingCustomer(customer));
    }

    /**
     * 删除充电客户
     */
    @DeleteMapping("/{customerIds}")
    public AjaxResult remove(@PathVariable Long[] customerIds)
    {
        int rows = 0;
        for (Long customerId : customerIds)
        {
            rows += chargingCustomerService.deleteChargingCustomerById(customerId);
        }
        return toAjax(rows);
    }
}
