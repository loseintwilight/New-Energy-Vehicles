package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadMerchant;
import org.apache.ibatis.annotations.Param;

public interface StadMerchantMapper {
    StadMerchant selectStadMerchantById(Long merchantId);
    StadMerchant selectStadMerchantByUserId(Long userId);
    List<StadMerchant> selectStadMerchantListByUserId(Long userId);
    StadMerchant selectStadMerchantByUserIdAndType(@Param("userId") Long userId, @Param("merchantType") String merchantType);
    List<StadMerchant> selectStadMerchantList(StadMerchant merchant);
    int insertStadMerchant(StadMerchant merchant);
    int updateStadMerchant(StadMerchant merchant);
    int auditStadMerchant(StadMerchant merchant);
    int deleteStadMerchantById(Long merchantId);
    int deleteStadMerchantByIds(Long[] merchantIds);
}