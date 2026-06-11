package com.ruoyi.charging.service;

import com.ruoyi.charging.domain.AppMerchant;
import java.util.List;

/**
 * 商户Service接口
 * 
 * @author ruoyi
 */
public interface IAppMerchantService 
{
    public AppMerchant selectAppMerchantById(Long merchantId);

    public AppMerchant selectAppMerchantByUserId(Long userId);

    public List<AppMerchant> selectAppMerchantList(AppMerchant merchant);

    public int insertAppMerchant(AppMerchant merchant);

    public int updateAppMerchant(AppMerchant merchant);

    public int deleteAppMerchantById(Long merchantId);
}
