package com.ruoyi.charging.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.charging.mapper.ChargingCustomerMapper;
import com.ruoyi.charging.domain.ChargingCustomer;
import com.ruoyi.charging.service.IChargingCustomerService;

/**
 * 充电客户Service业务层处理
 *
 * @author ruoyi
 */
@Service
public class ChargingCustomerServiceImpl implements IChargingCustomerService
{
    @Autowired
    private ChargingCustomerMapper chargingCustomerMapper;

    /**
     * 查询充电客户
     */
    @Override
    public ChargingCustomer selectChargingCustomerById(Long customerId)
    {
        return chargingCustomerMapper.selectChargingCustomerById(customerId);
    }

    /**
     * 查询充电客户列表
     */
    @Override
    public List<ChargingCustomer> selectChargingCustomerList(ChargingCustomer customer)
    {
        return chargingCustomerMapper.selectChargingCustomerList(customer);
    }

    /**
     * 新增充电客户
     */
    @Override
    public int insertChargingCustomer(ChargingCustomer customer)
    {
        return chargingCustomerMapper.insertChargingCustomer(customer);
    }

    /**
     * 修改充电客户
     */
    @Override
    public int updateChargingCustomer(ChargingCustomer customer)
    {
        return chargingCustomerMapper.updateChargingCustomer(customer);
    }

    /**
     * 删除充电客户
     */
    @Override
    public int deleteChargingCustomerById(Long customerId)
    {
        return chargingCustomerMapper.deleteChargingCustomerById(customerId);
    }
}
