package com.ruoyi.service.impl;
import com.ruoyi.business.domain.StadMaintenanceShop;
import com.ruoyi.mapper.MaintenanceShopMapper;
import com.ruoyi.service.MaintenanceShopService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
/**
 * @Classname MaintenanceShopServiceImpl
 * @Description
 * @Date 2026/6/8 16:24
 * @Created by 高合吴彦祖鹏哥
 */
@Service
public class MaintenanceShopServiceImpl implements MaintenanceShopService {

    @Autowired
    private MaintenanceShopMapper maintenanceShopMapper;

    @Override
    public List<StadMaintenanceShop> selectShopRanking() {
        return maintenanceShopMapper.selectShopRanking();
    }
}