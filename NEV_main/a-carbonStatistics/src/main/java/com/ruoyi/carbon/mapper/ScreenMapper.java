package com.ruoyi.carbon.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 数据大屏 - 数据查询 Mapper
 */
@Mapper
public interface ScreenMapper {

    /** 各区县碳减排数据（取最新统计日期） */
    List<Map<String, Object>> selectScreenCarbonData();

    /** 各区县新能源车保有量（取最新统计日期） */
    List<Map<String, Object>> selectScreenEVData();

    /** 各区县充电桩数量（从业务表统计） */
    List<Map<String, Object>> selectScreenPileData();

    /** 充电桩总数 */
    Long countPiles();

    /** 新能源车保有量汇总 */
    Long sumEV();

    /** 碳减排汇总 */
    Double sumCarbonReduction();
}