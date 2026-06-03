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
import com.ruoyi.business.domain.StadVehicleReview;
import com.ruoyi.business.service.IStadVehicleReviewService;

@RestController
@RequestMapping("/business/vehiclereview")
public class StadVehicleReviewController extends BaseController {

    @Autowired
    private IStadVehicleReviewService stadVehicleReviewService;

    @PreAuthorize("@ss.hasPermi('business:vehiclereview:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadVehicleReview review) {
        startPage();
        List<StadVehicleReview> list = stadVehicleReviewService.selectStadVehicleReviewList(review);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('business:vehiclereview:query')")
    @GetMapping(value = "/{reviewId}")
    public AjaxResult getInfo(@PathVariable("reviewId") Long reviewId) {
        return success(stadVehicleReviewService.selectStadVehicleReviewById(reviewId));
    }

    @PreAuthorize("@ss.hasPermi('business:vehiclereview:list')")
    @GetMapping(value = "/byVehicle/{vehicleId}")
    public AjaxResult listByVehicleId(@PathVariable("vehicleId") Long vehicleId) {
        return success(stadVehicleReviewService.selectStadVehicleReviewByVehicleId(vehicleId));
    }

    @PreAuthorize("@ss.hasPermi('business:vehiclereview:add')")
    @Log(title = "车辆评价", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody StadVehicleReview review) {
        return toAjax(stadVehicleReviewService.insertStadVehicleReview(review));
    }

    @PreAuthorize("@ss.hasPermi('business:vehiclereview:edit')")
    @Log(title = "车辆评价", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody StadVehicleReview review) {
        return toAjax(stadVehicleReviewService.updateStadVehicleReview(review));
    }

    @PreAuthorize("@ss.hasPermi('business:vehiclereview:remove')")
    @Log(title = "车辆评价", businessType = BusinessType.DELETE)
    @DeleteMapping("/{reviewIds}")
    public AjaxResult remove(@PathVariable Long[] reviewIds) {
        return toAjax(stadVehicleReviewService.deleteStadVehicleReviewByIds(reviewIds));
    }
}