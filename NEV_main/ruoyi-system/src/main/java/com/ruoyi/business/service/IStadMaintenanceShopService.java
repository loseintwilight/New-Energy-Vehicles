package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadMaintenanceShop;

public interface IStadMaintenanceShopService {
    StadMaintenanceShop selectStadMaintenanceShopById(Long shopId);
    List<StadMaintenanceShop> selectStadMaintenanceShopList(StadMaintenanceShop shop);
    int insertStadMaintenanceShop(StadMaintenanceShop shop);
    int updateStadMaintenanceShop(StadMaintenanceShop shop);
    int deleteStadMaintenanceShopByIds(Long[] shopIds);
}