package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadGovNevRegistration;

public interface StadGovNevRegistrationMapper {
    StadGovNevRegistration selectStadGovNevRegistrationById(Long regId);
    List<StadGovNevRegistration> selectStadGovNevRegistrationList(StadGovNevRegistration registration);
    int insertStadGovNevRegistration(StadGovNevRegistration registration);
    int updateStadGovNevRegistration(StadGovNevRegistration registration);
    int deleteStadGovNevRegistrationById(Long regId);
    int deleteStadGovNevRegistrationByIds(Long[] regIds);
}