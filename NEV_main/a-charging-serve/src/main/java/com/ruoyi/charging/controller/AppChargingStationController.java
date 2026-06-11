package com.ruoyi.charging.controller;

import java.util.List;

import com.github.pagehelper.PageHelper;
import com.ruoyi.common.core.page.PageDomain;
import com.ruoyi.common.core.page.TableSupport;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.sql.SqlUtil;
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
import com.ruoyi.charging.domain.ChargingStation;
import com.ruoyi.charging.service.IChargingStationService;

/**
 * 充电站Controller
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/app/charge/station")
public class AppChargingStationController extends BaseController
{
    @Autowired
    private IChargingStationService chargingStationService;

    /**
     * 查询充电站列表
     */
    @Anonymous
    @GetMapping("/list")
    public TableDataInfo list(ChargingStation station)
    {
        PageDomain pageDomain = TableSupport.buildPageRequest();
        if (StringUtils.isNotNull(pageDomain.getPageNum())) {
            // 过滤 distance 排序：表中无此列，距离排序由前端实时计算
            if ("distance".equals(pageDomain.getOrderByColumn())) {
                pageDomain.setOrderByColumn(null);
            }
            String orderBy = SqlUtil.escapeOrderBySql(pageDomain.getOrderBy());
            Boolean reasonable = pageDomain.getReasonable();
            PageHelper.startPage(pageDomain.getPageNum(), pageDomain.getPageSize(), orderBy).setReasonable(reasonable);
        }
        List<ChargingStation> list = chargingStationService.selectChargingStationList(station);
        return getDataTable(list);
    }

    /**
     * 获取充电站详细信息
     */
    @Anonymous
    @GetMapping(value = "/{stationId}")
    public AjaxResult getInfo(@PathVariable("stationId") Long stationId)
    {
        return success(chargingStationService.selectChargingStationById(stationId));
    }

    /**
     * 根据商户ID查询充电站列表
     */
    @Anonymous
    @GetMapping("/listByMerchant/{merchantId}")
    public AjaxResult listByMerchant(@PathVariable("merchantId") Long merchantId)
    {
        return success(chargingStationService.selectChargingStationListByMerchantId(merchantId));
    }

    /**
     * 新增充电站
     */
    @PostMapping
    public AjaxResult add(@RequestBody ChargingStation station)
    {
        return toAjax(chargingStationService.insertChargingStation(station));
    }

    /**
     * 修改充电站
     */
    @PutMapping
    public AjaxResult edit(@RequestBody ChargingStation station)
    {
        return toAjax(chargingStationService.updateChargingStation(station));
    }

    /**
     * 删除充电站
     */
    @DeleteMapping("/{stationIds}")
    public AjaxResult remove(@PathVariable Long[] stationIds)
    {
        return toAjax(chargingStationService.deleteChargingStationByIds(stationIds));
    }
}
