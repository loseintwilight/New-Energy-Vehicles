package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadUserAddressMapper;
import com.ruoyi.business.domain.StadUserAddress;
import com.ruoyi.business.service.IStadUserAddressService;

@Service
public class StadUserAddressServiceImpl implements IStadUserAddressService {

    @Autowired
    private StadUserAddressMapper stadUserAddressMapper;

    @Override
    public StadUserAddress selectStadUserAddressById(Long addressId) {
        return stadUserAddressMapper.selectStadUserAddressById(addressId);
    }

    @Override
    public List<StadUserAddress> selectStadUserAddressList(StadUserAddress address) {
        return stadUserAddressMapper.selectStadUserAddressList(address);
    }

    @Override
    public int insertStadUserAddress(StadUserAddress address) {
        return stadUserAddressMapper.insertStadUserAddress(address);
    }

    @Override
    public int updateStadUserAddress(StadUserAddress address) {
        return stadUserAddressMapper.updateStadUserAddress(address);
    }

    @Override
    public int deleteStadUserAddressByIds(Long[] addressIds) {
        return stadUserAddressMapper.deleteStadUserAddressByIds(addressIds);
    }
}