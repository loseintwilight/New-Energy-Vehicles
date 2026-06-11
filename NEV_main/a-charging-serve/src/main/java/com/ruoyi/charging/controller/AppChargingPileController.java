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
import com.ruoyi.charging.domain.ChargingPile;
import com.ruoyi.charging.service.IChargingPileService;

/**
 * 充电桩Controller
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/app/charge/pile")
public class AppChargingPileController extends BaseController
{
    @Autowired
    private IChargingPileService chargingPileService;

    /**
     * 查询充电桩列表
     */
    @Anonymous
    @GetMapping("/list")
    public TableDataInfo list(ChargingPile pile)
    {
        startPage();
        List<ChargingPile> list = chargingPileService.selectChargingPileList(pile);
        return getDataTable(list);
    }

    /**
     * 获取充电桩详细信息
     */
    @Anonymous
    @GetMapping(value = "/{pileId}")
    public AjaxResult getInfo(@PathVariable("pileId") Long pileId)
    {
        return success(chargingPileService.selectChargingPileById(pileId));
    }

    /**
     * 根据站点ID查询充电桩列表
     */
    @Anonymous
    @GetMapping("/listByStation/{stationId}")
    public AjaxResult listByStation(@PathVariable("stationId") Long stationId)
    {
        return success(chargingPileService.selectChargingPileListByStationId(stationId));
    }

    /**
     * 新增充电桩
     */
    @PostMapping
    public AjaxResult add(@RequestBody ChargingPile pile)
    {
        return toAjax(chargingPileService.insertChargingPile(pile));
    }

    /**
     * 修改充电桩
     */
    @PutMapping
    public AjaxResult edit(@RequestBody ChargingPile pile)
    {
        return toAjax(chargingPileService.updateChargingPile(pile));
    }

    /**
     * 删除充电桩
     */
    @DeleteMapping("/{pileIds}")
    public AjaxResult remove(@PathVariable Long[] pileIds)
    {
        return toAjax(chargingPileService.deleteChargingPileByIds(pileIds));
    }
}
