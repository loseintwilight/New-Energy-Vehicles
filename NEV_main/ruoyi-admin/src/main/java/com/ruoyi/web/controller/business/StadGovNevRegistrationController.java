package com.ruoyi.web.controller.business;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
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
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.business.domain.StadGovNevRegistration;
import com.ruoyi.business.service.IStadGovNevRegistrationService;

@RestController
@RequestMapping("/business/govregistration")
public class StadGovNevRegistrationController extends BaseController {

    @Autowired
    private IStadGovNevRegistrationService stadGovNevRegistrationService;

    @PreAuthorize("@ss.hasPermi('business:govregistration:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadGovNevRegistration registration) {
        startPage();
        List<StadGovNevRegistration> list = stadGovNevRegistrationService.selectStadGovNevRegistrationList(registration);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('business:govregistration:query')")
    @GetMapping(value = "/{regId}")
    public AjaxResult getInfo(@PathVariable("regId") Long regId) {
        return success(stadGovNevRegistrationService.selectStadGovNevRegistrationById(regId));
    }

    @PreAuthorize("@ss.hasPermi('business:govregistration:add')")
    @Log(title = "新能源上牌登记", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody StadGovNevRegistration registration) {
        return toAjax(stadGovNevRegistrationService.insertStadGovNevRegistration(registration));
    }

    @PreAuthorize("@ss.hasPermi('business:govregistration:edit')")
    @Log(title = "新能源上牌登记", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody StadGovNevRegistration registration) {
        return toAjax(stadGovNevRegistrationService.updateStadGovNevRegistration(registration));
    }

    @PreAuthorize("@ss.hasPermi('business:govregistration:remove')")
    @Log(title = "新能源上牌登记", businessType = BusinessType.DELETE)
    @DeleteMapping("/{regIds}")
    public AjaxResult remove(@PathVariable Long[] regIds) {
        return toAjax(stadGovNevRegistrationService.deleteStadGovNevRegistrationByIds(regIds));
    }
}