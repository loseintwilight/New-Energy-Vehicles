package com.ruoyi.web.controller.databoard;

import com.ruoyi.carbon.service.IScreenService;
import com.ruoyi.carbon.vo.ScreenDataVO;
import com.ruoyi.common.core.domain.AjaxResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 数据大屏 Controller
 * 提供大屏展示所需的汇总统计数据
 */
@RestController
@RequestMapping("/dashboard")
public class ScreenController {

    @Autowired
    private IScreenService screenService;

    /**
     * 获取数据大屏综合数据
     * 返回各区县碳减排、新能源车、充电桩数量及顶部汇总卡片
     */
    @GetMapping("/screen")
    public AjaxResult getScreenData() {
        ScreenDataVO data = screenService.getScreenData();
        return AjaxResult.success(data);
    }
}