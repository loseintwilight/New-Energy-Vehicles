package com.ruoyi.charging.mapper;

import com.ruoyi.charging.domain.ChargingCustomer;
import java.util.List;

/**
 * 充电客户Mapper接口
 *
 * @author ruoyi
 */
public interface ChargingCustomerMapper
{
    /**
     * 查询充电客户
     */
    public ChargingCustomer selectChargingCustomerById(Long customerId);

    /**
     * 查询充电客户列表
     */
    public List<ChargingCustomer> selectChargingCustomerList(ChargingCustomer customer);

    /**
     * 新增充电客户
     */
    public int insertChargingCustomer(ChargingCustomer customer);

    /**
     * 修改充电客户
     */
    public int updateChargingCustomer(ChargingCustomer customer);

    /**
     * 删除充电客户
     */
    public int deleteChargingCustomerById(Long customerId);
}
