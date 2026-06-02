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
import com.ruoyi.business.domain.StadUserAddress;
import com.ruoyi.business.service.IStadUserAddressService;

@RestController
@RequestMapping("/business/address")
public class StadUserAddressController extends BaseController {

    @Autowired
    private IStadUserAddressService stadUserAddressService;

    @PreAuthorize("@ss.hasPermi('business:address:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadUserAddress address) {
        startPage();
        List<StadUserAddress> list = stadUserAddressService.selectStadUserAddressList(address);
        return getDataTable(list);
    }

    @GetMapping(value = "/{addressId}")
    public AjaxResult getInfo(@PathVariable Long addressId) {
        return success(stadUserAddressService.selectStadUserAddressById(addressId));
    }

    @PreAuthorize("@ss.hasPermi('business:address:add')")
    @Log(title = "收货地址管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody StadUserAddress address) {
        address.setCreateBy(getUsername());
        return toAjax(stadUserAddressService.insertStadUserAddress(address));
    }

    @PreAuthorize("@ss.hasPermi('business:address:edit')")
    @Log(title = "收货地址管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody StadUserAddress address) {
        address.setUpdateBy(getUsername());
        return toAjax(stadUserAddressService.updateStadUserAddress(address));
    }

    @PreAuthorize("@ss.hasPermi('business:address:remove')")
    @Log(title = "收货地址管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{addressIds}")
    public AjaxResult remove(@PathVariable Long[] addressIds) {
        return toAjax(stadUserAddressService.deleteStadUserAddressByIds(addressIds));
    }
}