package com.ruoyi.carbon.vo;

/**
 * 数据大屏 - 区县级统计数据 VO
 * 对应前端 {name, value} 格式
 */
public class ScreenDistrictVO {

    /** 区县名称 */
    private String name;

    /** 数值 */
    private Object value;

    public ScreenDistrictVO() {
    }

    public ScreenDistrictVO(String name, Object value) {
        this.name = name;
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Object getValue() {
        return value;
    }

    public void setValue(Object value) {
        this.value = value;
    }
}