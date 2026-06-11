package com.ruoyi.charging.service.impl;

import com.ruoyi.charging.domain.AppMerchant;
import com.ruoyi.charging.mapper.AppMerchantMapper;
import com.ruoyi.charging.service.IAppMerchantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 商户Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class AppMerchantServiceImpl implements IAppMerchantService 
{
    @Autowired
    private AppMerchantMapper appMerchantMapper;

    @Override
    public AppMerchant selectAppMerchantById(Long merchantId)
    {
        return appMerchantMapper.selectAppMerchantById(merchantId);
    }

    @Override
    public AppMerchant selectAppMerchantByUserId(Long userId)
    {
        return appMerchantMapper.selectAppMerchantByUserId(userId);
    }

    @Override
    public List<AppMerchant> selectAppMerchantList(AppMerchant merchant)
    {
        return appMerchantMapper.selectAppMerchantList(merchant);
    }

    @Override
    public int insertAppMerchant(AppMerchant merchant)
    {
        return appMerchantMapper.insertAppMerchant(merchant);
    }

    @Override
    public int updateAppMerchant(AppMerchant merchant)
    {
        return appMerchantMapper.updateAppMerchant(merchant);
    }

    @Override
    public int deleteAppMerchantById(Long merchantId)
    {
        return appMerchantMapper.deleteAppMerchantById(merchantId);
    }
}
