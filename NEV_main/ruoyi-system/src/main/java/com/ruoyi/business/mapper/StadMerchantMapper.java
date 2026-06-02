package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadMerchant;

public interface StadMerchantMapper {
    StadMerchant selectStadMerchantById(Long merchantId);
    List<StadMerchant> selectStadMerchantList(StadMerchant merchant);
    int insertStadMerchant(StadMerchant merchant);
    int updateStadMerchant(StadMerchant merchant);
    int deleteStadMerchantById(Long merchantId);
    int deleteStadMerchantByIds(Long[] merchantIds);
}