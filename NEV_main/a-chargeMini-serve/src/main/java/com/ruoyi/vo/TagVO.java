package com.ruoyi.vo;

import lombok.Data;

/**
 * 标签VO（用于充电站列表的展示标签）
 */
@Data
public class TagVO {
    private String text;
    private String type;

    public TagVO() {}

    public TagVO(String text, String type) {
        this.text = text;
        this.type = type;
    }
}
