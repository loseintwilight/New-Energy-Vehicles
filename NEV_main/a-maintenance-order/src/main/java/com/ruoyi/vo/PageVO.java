package com.ruoyi.vo;

import lombok.Data;

import java.util.List;

/**
 * 通用分页视图对象
 * 统一返回 { list: [...], total: N } 格式供前端消费
 */
@Data
public class PageVO<T> {
    private List<T> list;
    private long total;

    public PageVO() {}

    public PageVO(List<T> list, long total) {
        this.list = list;
        this.total = total;
    }
}
