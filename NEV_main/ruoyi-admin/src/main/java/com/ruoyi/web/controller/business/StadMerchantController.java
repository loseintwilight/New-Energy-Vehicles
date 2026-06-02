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
import com.ruoyi.business.domain.StadMerchant;
import com.ruoyi.business.service.IStadMerchantService;

@RestController
@RequestMapping("/business/merchant")
public class StadMerchantController extends BaseController {

    @Autowired
    private IStadMerchantService stadMerchantService;

    @PreAuthorize("@ss.hasPermi('business:merchant:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadMerchant merchant) {
        startPage();
        List<StadMerchant> list = stadMerchantService.selectStadMerchantList(merchant);
        return getDataTable(list);
    }

    @GetMapping(value = "/{merchantId}")
    public AjaxResult getInfo(@PathVariable Long merchantId) {
        return success(stadMerchantService.selectStadMerchantById(merchantId));
    }

    @PreAuthorize("@ss.hasPermi('business:merchant:add')")
    @Log(title = "商户管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody StadMerchant merchant) {
        merchant.setCreateBy(getUsername());
        return toAjax(stadMerchantService.insertStadMerchant(merchant));
    }

    @PreAuthorize("@ss.hasPermi('business:merchant:edit')")
    @Log(title = "商户管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody StadMerchant merchant) {
        merchant.setUpdateBy(getUsername());
        return toAjax(stadMerchantService.updateStadMerchant(merchant));
    }

    @PreAuthorize("@ss.hasPermi('business:merchant:remove')")
    @Log(title = "商户管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{merchantIds}")
    public AjaxResult remove(@PathVariable Long[] merchantIds) {
        return toAjax(stadMerchantService.deleteStadMerchantByIds(merchantIds));
    }
}