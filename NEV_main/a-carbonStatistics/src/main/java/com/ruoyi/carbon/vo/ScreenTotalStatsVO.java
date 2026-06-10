package com.ruoyi.carbon.vo;

/**
 * 数据大屏 - 顶部卡片汇总统计 VO
 */
public class ScreenTotalStatsVO {

    /** 充电桩总数 */
    private Long totalPiles;

    /** 新能源车保有量 */
    private Long totalEV;

    /** 碳减排总吨数 */
    private Double totalReduction;

    public ScreenTotalStatsVO() {
    }

    public ScreenTotalStatsVO(Long totalPiles, Long totalEV, Double totalReduction) {
        this.totalPiles = totalPiles;
        this.totalEV = totalEV;
        this.totalReduction = totalReduction;
    }

    public Long getTotalPiles() {
        return totalPiles;
    }

    public void setTotalPiles(Long totalPiles) {
        this.totalPiles = totalPiles;
    }

    public Long getTotalEV() {
        return totalEV;
    }

    public void setTotalEV(Long totalEV) {
        this.totalEV = totalEV;
    }

    public Double getTotalReduction() {
        return totalReduction;
    }

    public void setTotalReduction(Double totalReduction) {
        this.totalReduction = totalReduction;
    }
}