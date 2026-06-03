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
import com.ruoyi.business.domain.StadChargingPile;
import com.ruoyi.business.service.IStadChargingPileService;

@RestController
@RequestMapping("/business/chargingpile")
public class StadChargingPileController extends BaseController {

    @Autowired
    private IStadChargingPileService stadChargingPileService;

    @PreAuthorize("@ss.hasPermi('business:chargingpile:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadChargingPile pile) {
        startPage();
        List<StadChargingPile> list = stadChargingPileService.selectStadChargingPileList(pile);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('business:chargingpile:query')")
    @GetMapping(value = "/{pileId}")
    public AjaxResult getInfo(@PathVariable("pileId") Long pileId) {
        return success(stadChargingPileService.selectStadChargingPileById(pileId));
    }

    @PreAuthorize("@ss.hasPermi('business:chargingpile:list')")
    @GetMapping(value = "/byStation/{stationId}")
    public AjaxResult listByStationId(@PathVariable("stationId") Long stationId) {
        return success(stadChargingPileService.selectStadChargingPileByStationId(stationId));
    }

    @PreAuthorize("@ss.hasPermi('business:chargingpile:add')")
    @Log(title = "充电桩", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody StadChargingPile pile) {
        return toAjax(stadChargingPileService.insertStadChargingPile(pile));
    }

    @PreAuthorize("@ss.hasPermi('business:chargingpile:edit')")
    @Log(title = "充电桩", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody StadChargingPile pile) {
        return toAjax(stadChargingPileService.updateStadChargingPile(pile));
    }

    @PreAuthorize("@ss.hasPermi('business:chargingpile:remove')")
    @Log(title = "充电桩", businessType = BusinessType.DELETE)
    @DeleteMapping("/{pileIds}")
    public AjaxResult remove(@PathVariable Long[] pileIds) {
        return toAjax(stadChargingPileService.deleteStadChargingPileByIds(pileIds));
    }
}