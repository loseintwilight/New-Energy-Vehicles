package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadMaintenanceShopMapper;
import com.ruoyi.business.domain.StadMaintenanceShop;
import com.ruoyi.business.service.IStadMaintenanceShopService;

@Service
public class StadMaintenanceShopServiceImpl implements IStadMaintenanceShopService {

    @Autowired
    private StadMaintenanceShopMapper stadMaintenanceShopMapper;

    @Override
    public StadMaintenanceShop selectStadMaintenanceShopById(Long shopId) {
        return stadMaintenanceShopMapper.selectStadMaintenanceShopById(shopId);
    }

    @Override
    public List<StadMaintenanceShop> selectStadMaintenanceShopList(StadMaintenanceShop shop) {
        return stadMaintenanceShopMapper.selectStadMaintenanceShopList(shop);
    }

    @Override
    public int insertStadMaintenanceShop(StadMaintenanceShop shop) {
        return stadMaintenanceShopMapper.insertStadMaintenanceShop(shop);
    }

    @Override
    public int updateStadMaintenanceShop(StadMaintenanceShop shop) {
        return stadMaintenanceShopMapper.updateStadMaintenanceShop(shop);
    }

    @Override
    public int deleteStadMaintenanceShopByIds(Long[] shopIds) {
        return stadMaintenanceShopMapper.deleteStadMaintenanceShopByIds(shopIds);
    }
}