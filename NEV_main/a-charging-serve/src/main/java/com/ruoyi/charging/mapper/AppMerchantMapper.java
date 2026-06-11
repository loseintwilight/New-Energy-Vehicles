package com.ruoyi.charging.mapper;

import com.ruoyi.charging.domain.AppMerchant;
import java.util.List;

/**
 * 商户Mapper接口
 * 
 * @author ruoyi
 */
public interface AppMerchantMapper 
{
    public AppMerchant selectAppMerchantById(Long merchantId);

    public AppMerchant selectAppMerchantByUserId(Long userId);

    public List<AppMerchant> selectAppMerchantList(AppMerchant merchant);

    public int insertAppMerchant(AppMerchant merchant);

    public int updateAppMerchant(AppMerchant merchant);

    public int deleteAppMerchantById(Long merchantId);
}
