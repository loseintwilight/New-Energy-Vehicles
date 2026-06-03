package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadMaintenanceShop;

public interface StadMaintenanceShopMapper {
    StadMaintenanceShop selectStadMaintenanceShopById(Long shopId);
    List<StadMaintenanceShop> selectStadMaintenanceShopList(StadMaintenanceShop shop);
    int insertStadMaintenanceShop(StadMaintenanceShop shop);
    int updateStadMaintenanceShop(StadMaintenanceShop shop);
    int deleteStadMaintenanceShopById(Long shopId);
    int deleteStadMaintenanceShopByIds(Long[] shopIds);
}