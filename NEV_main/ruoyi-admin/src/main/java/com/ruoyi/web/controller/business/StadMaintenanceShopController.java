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
import com.ruoyi.business.domain.StadMaintenanceShop;
import com.ruoyi.business.service.IStadMaintenanceShopService;

@RestController
@RequestMapping("/business/maintenance/shop")
public class StadMaintenanceShopController extends BaseController {

    @Autowired
    private IStadMaintenanceShopService stadMaintenanceShopService;

    @PreAuthorize("@ss.hasPermi('business:shop:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadMaintenanceShop shop) {
        startPage();
        List<StadMaintenanceShop> list = stadMaintenanceShopService.selectStadMaintenanceShopList(shop);
        return getDataTable(list);
    }

    @GetMapping(value = "/{shopId}")
    public AjaxResult getInfo(@PathVariable Long shopId) {
        return success(stadMaintenanceShopService.selectStadMaintenanceShopById(shopId));
    }

    @PreAuthorize("@ss.hasPermi('business:shop:add')")
    @Log(title = "维保门店管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody StadMaintenanceShop shop) {
        shop.setCreateBy(getUsername());
        return toAjax(stadMaintenanceShopService.insertStadMaintenanceShop(shop));
    }

    @PreAuthorize("@ss.hasPermi('business:shop:edit')")
    @Log(title = "维保门店管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody StadMaintenanceShop shop) {
        shop.setUpdateBy(getUsername());
        return toAjax(stadMaintenanceShopService.updateStadMaintenanceShop(shop));
    }

    @PreAuthorize("@ss.hasPermi('business:shop:remove')")
    @Log(title = "维保门店管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{shopIds}")
    public AjaxResult remove(@PathVariable Long[] shopIds) {
        return toAjax(stadMaintenanceShopService.deleteStadMaintenanceShopByIds(shopIds));
    }
}