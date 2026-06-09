package com.ruoyi.web.controller.mine;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.mine.domain.MineStadChargingOrder;
import com.ruoyi.mine.service.IStadChargingOrderService;
import com.ruoyi.mine.vo.ChargingOrderListVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 小程序端 - 充电记录
 */
@RestController
@RequestMapping("/app/charging")
public class AppChargingController extends BaseController {

    @Autowired
    private IStadChargingOrderService stadChargingOrderService;

    /**
     * 获取充电记录列表
     */
    @GetMapping("/order/list")
    public TableDataInfo getChargingOrderList(MineStadChargingOrder order) {
        startPage();
        Long userId = SecurityUtils.getUserId();
        order.setUserId(userId);
        List<ChargingOrderListVO> list = stadChargingOrderService.selectFormattedChargingOrderList(order);
        return getDataTable(list);
    }

    /**
     * 获取充电记录详情
     */
    @GetMapping("/order/detail/{id}")
    public AjaxResult getChargingOrderDetail(@PathVariable("id") Long id) {
        Long userId = SecurityUtils.getUserId();
        ChargingOrderListVO vo = stadChargingOrderService.selectFormattedChargingOrderDetail(id);
        if (vo == null) {
            return AjaxResult.error("订单不存在");
        }
        return AjaxResult.success(vo);
    }

    /**
     * （兼容）旧接口路径：/order/status/{id}
     */
    @GetMapping("/order/status/{id}")
    public AjaxResult getChargingOrderDetailOld(@PathVariable("id") Long id) {
        return getChargingOrderDetail(id);
    }

    /**
     * 获取充电统计数据（总次数、总电量、总金额）
     */
    @GetMapping("/statistics")
    public AjaxResult getChargingStatistics() {
        Long userId = SecurityUtils.getUserId();
        Map<String, Object> stats = stadChargingOrderService.getChargingStatistics(userId);
        return AjaxResult.success(stats);
    }
}