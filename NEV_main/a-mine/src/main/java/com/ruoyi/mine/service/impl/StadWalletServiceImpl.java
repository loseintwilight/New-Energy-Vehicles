package com.ruoyi.mine.service.impl;

import com.ruoyi.mine.domain.MineStadWallet;
import com.ruoyi.mine.mapper.StadWalletMapper;
import com.ruoyi.mine.service.IStadWalletService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Date;

@Service
public class StadWalletServiceImpl implements IStadWalletService {

    @Autowired
    private StadWalletMapper walletMapper;

    @Override
    public MineStadWallet selectStadWalletByUserId(Long userId) {
        return walletMapper.selectStadWalletByUserId(userId);
    }

    @Override
    public int insertStadWallet(MineStadWallet wallet) {
        return walletMapper.insertStadWallet(wallet);
    }

    @Override
    public int updateStadWallet(MineStadWallet wallet) {
        return walletMapper.updateStadWallet(wallet);
    }

    @Override
    public MineStadWallet getOrCreateWallet(Long userId) {
        MineStadWallet wallet = walletMapper.selectStadWalletByUserId(userId);
        if (wallet == null) {
            wallet = new MineStadWallet();
            wallet.setUserId(userId);
            wallet.setBalance(BigDecimal.ZERO);
            wallet.setTotalRecharge(BigDecimal.ZERO);
            wallet.setTotalWithdraw(BigDecimal.ZERO);
            wallet.setFreezeAmount(BigDecimal.ZERO);
            wallet.setCreateTime(new Date());
            wallet.setUpdateTime(new Date());
            walletMapper.insertStadWallet(wallet);
        }
        return wallet;
    }

    @Override
    @Transactional
    public int recharge(Long userId, BigDecimal amount) {
        MineStadWallet wallet = getOrCreateWallet(userId);
        wallet.setBalance(wallet.getBalance().add(amount));
        wallet.setTotalRecharge(wallet.getTotalRecharge().add(amount));
        wallet.setUpdateTime(new Date());
        return walletMapper.updateStadWallet(wallet);
    }

    @Override
    @Transactional
    public int withdraw(Long userId, BigDecimal amount) {
        MineStadWallet wallet = getOrCreateWallet(userId);
        if (wallet.getBalance().compareTo(amount) < 0) {
            throw new RuntimeException("余额不足");
        }
        wallet.setBalance(wallet.getBalance().subtract(amount));
        wallet.setTotalWithdraw(wallet.getTotalWithdraw().add(amount));
        wallet.setUpdateTime(new Date());
        return walletMapper.updateStadWallet(wallet);
    }
}