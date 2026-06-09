package com.ruoyi.mine.service;

import com.ruoyi.mine.domain.MineStadWallet;

import java.math.BigDecimal;

public interface IStadWalletService {
    
    MineStadWallet selectStadWalletByUserId(Long userId);
    
    int insertStadWallet(MineStadWallet wallet);
    
    int updateStadWallet(MineStadWallet wallet);
    
    MineStadWallet getOrCreateWallet(Long userId);
    
    int recharge(Long userId, BigDecimal amount);
    
    int withdraw(Long userId, BigDecimal amount);
}