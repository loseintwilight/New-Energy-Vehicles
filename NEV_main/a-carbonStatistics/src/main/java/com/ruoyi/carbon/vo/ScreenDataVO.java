package com.ruoyi.carbon.vo;

import java.util.List;

/**
 * 数据大屏 - 综合数据 VO
 * 对应前端 getScreenData() 接口的响应结构
 */
public class ScreenDataVO {

    /** 各区县碳减排数据 */
    private List<ScreenDistrictVO> carbonReductionData;

    /** 各区县新能源车保有量 */
    private List<ScreenDistrictVO> evData;

    /** 各区县充电桩数量 */
    private List<ScreenDistrictVO> pilesData;

    /** 顶部卡片汇总统计 */
    private ScreenTotalStatsVO totalStats;

    public List<ScreenDistrictVO> getCarbonReductionData() {
        return carbonReductionData;
    }

    public void setCarbonReductionData(List<ScreenDistrictVO> carbonReductionData) {
        this.carbonReductionData = carbonReductionData;
    }

    public List<ScreenDistrictVO> getEvData() {
        return evData;
    }

    public void setEvData(List<ScreenDistrictVO> evData) {
        this.evData = evData;
    }

    public List<ScreenDistrictVO> getPilesData() {
        return pilesData;
    }

    public void setPilesData(List<ScreenDistrictVO> pilesData) {
        this.pilesData = pilesData;
    }

    public ScreenTotalStatsVO getTotalStats() {
        return totalStats;
    }

    public void setTotalStats(ScreenTotalStatsVO totalStats) {
        this.totalStats = totalStats;
    }
}