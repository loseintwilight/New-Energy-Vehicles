package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadMerchantMapper;
import com.ruoyi.business.domain.StadMerchant;
import com.ruoyi.business.service.IStadMerchantService;

@Service
public class StadMerchantServiceImpl implements IStadMerchantService {

    @Autowired
    private StadMerchantMapper stadMerchantMapper;

    @Override
    public StadMerchant selectStadMerchantById(Long merchantId) {
        return stadMerchantMapper.selectStadMerchantById(merchantId);
    }

    @Override
    public List<StadMerchant> selectStadMerchantList(StadMerchant merchant) {
        return stadMerchantMapper.selectStadMerchantList(merchant);
    }

    @Override
    public int insertStadMerchant(StadMerchant merchant) {
        return stadMerchantMapper.insertStadMerchant(merchant);
    }

    @Override
    public int updateStadMerchant(StadMerchant merchant) {
        return stadMerchantMapper.updateStadMerchant(merchant);
    }

    @Override
    public int deleteStadMerchantByIds(Long[] merchantIds) {
        return stadMerchantMapper.deleteStadMerchantByIds(merchantIds);
    }
}