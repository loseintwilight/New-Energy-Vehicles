package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadUserAddress;

public interface IStadUserAddressService {
    StadUserAddress selectStadUserAddressById(Long addressId);
    List<StadUserAddress> selectStadUserAddressList(StadUserAddress address);
    int insertStadUserAddress(StadUserAddress address);
    int updateStadUserAddress(StadUserAddress address);
    int deleteStadUserAddressByIds(Long[] addressIds);
}