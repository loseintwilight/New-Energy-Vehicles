package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadUserAddress;

public interface StadUserAddressMapper {
    StadUserAddress selectStadUserAddressById(Long addressId);
    List<StadUserAddress> selectStadUserAddressList(StadUserAddress address);
    int insertStadUserAddress(StadUserAddress address);
    int updateStadUserAddress(StadUserAddress address);
    int deleteStadUserAddressById(Long addressId);
    int deleteStadUserAddressByIds(Long[] addressIds);
}