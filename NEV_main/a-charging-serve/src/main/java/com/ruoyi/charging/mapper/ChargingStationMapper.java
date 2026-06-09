package com.ruoyi.charging.mapper;

import com.ruoyi.charging.vo.MerchantStationVO;
import org.apache.ibatis.annotations.Param;
import java.util.List;

/**
 * 商户端-充电站Mapper
 */
public interface ChargingStationMapper {

    /** 查询商户的充电站列表（含今日营收、订单、充电量统计） */
    List<MerchantStationVO> selectMerchantStationList(@Param("merchantId") Long merchantId);
}
