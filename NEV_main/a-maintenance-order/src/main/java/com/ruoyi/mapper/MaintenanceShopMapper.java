package com.ruoyi.mapper;

import com.ruoyi.business.domain.StadMaintenanceShop;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface MaintenanceShopMapper {

    List<StadMaintenanceShop> selectShopRanking();
}
