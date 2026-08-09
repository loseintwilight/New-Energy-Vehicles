package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadMerchant;

public interface IStadMerchantService {
    StadMerchant selectStadMerchantById(Long merchantId);
    StadMerchant selectStadMerchantByUserId(Long userId);
    List<StadMerchant> selectStadMerchantListByUserId(Long userId);
    StadMerchant selectStadMerchantByUserIdAndType(Long userId, String merchantType);
    List<StadMerchant> selectStadMerchantList(StadMerchant merchant);
    int insertStadMerchant(StadMerchant merchant);
    int updateStadMerchant(StadMerchant merchant);
    int auditStadMerchant(StadMerchant merchant);
    int deleteStadMerchantByIds(Long[] merchantIds);
}