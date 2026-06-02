package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadGovNevRegistration;

public interface IStadGovNevRegistrationService {
    StadGovNevRegistration selectStadGovNevRegistrationById(Long regId);
    List<StadGovNevRegistration> selectStadGovNevRegistrationList(StadGovNevRegistration registration);
    int insertStadGovNevRegistration(StadGovNevRegistration registration);
    int updateStadGovNevRegistration(StadGovNevRegistration registration);
    int deleteStadGovNevRegistrationByIds(Long[] regIds);
}