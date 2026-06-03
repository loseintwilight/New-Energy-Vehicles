package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadGovNevRegistrationMapper;
import com.ruoyi.business.domain.StadGovNevRegistration;
import com.ruoyi.business.service.IStadGovNevRegistrationService;

@Service
public class StadGovNevRegistrationServiceImpl implements IStadGovNevRegistrationService {

    @Autowired
    private StadGovNevRegistrationMapper stadGovNevRegistrationMapper;

    @Override
    public StadGovNevRegistration selectStadGovNevRegistrationById(Long regId) {
        return stadGovNevRegistrationMapper.selectStadGovNevRegistrationById(regId);
    }

    @Override
    public List<StadGovNevRegistration> selectStadGovNevRegistrationList(StadGovNevRegistration registration) {
        return stadGovNevRegistrationMapper.selectStadGovNevRegistrationList(registration);
    }

    @Override
    public int insertStadGovNevRegistration(StadGovNevRegistration registration) {
        return stadGovNevRegistrationMapper.insertStadGovNevRegistration(registration);
    }

    @Override
    public int updateStadGovNevRegistration(StadGovNevRegistration registration) {
        return stadGovNevRegistrationMapper.updateStadGovNevRegistration(registration);
    }

    @Override
    public int deleteStadGovNevRegistrationByIds(Long[] regIds) {
        return stadGovNevRegistrationMapper.deleteStadGovNevRegistrationByIds(regIds);
    }
}