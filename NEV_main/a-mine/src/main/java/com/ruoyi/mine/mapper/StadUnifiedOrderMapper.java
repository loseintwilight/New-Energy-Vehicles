package com.ruoyi.mine.mapper;

import java.util.List;
import com.ruoyi.mine.domain.MineStadUnifiedOrder;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository("mineStadUnifiedOrderMapper")
public interface StadUnifiedOrderMapper {
    public MineStadUnifiedOrder selectStadUnifiedOrderById(Long orderId);
    public List<MineStadUnifiedOrder> selectStadUnifiedOrderList(MineStadUnifiedOrder order);
    public int insertStadUnifiedOrder(MineStadUnifiedOrder order);
    public int updateStadUnifiedOrder(MineStadUnifiedOrder order);
    public int deleteStadUnifiedOrderById(Long orderId);
    public int deleteStadUnifiedOrderByIds(Long[] orderIds);
}
