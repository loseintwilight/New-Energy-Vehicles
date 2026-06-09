package com.ruoyi.mine.mapper;

import com.ruoyi.mine.domain.MineStadWallet;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface StadWalletMapper {
    
    MineStadWallet selectStadWalletByUserId(Long userId);
    
    int insertStadWallet(MineStadWallet wallet);
    
    int updateStadWallet(MineStadWallet wallet);
}