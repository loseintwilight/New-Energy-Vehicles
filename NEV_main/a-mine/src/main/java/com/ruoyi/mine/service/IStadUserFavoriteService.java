package com.ruoyi.mine.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.mine.domain.MineStadUserFavorite;

public interface IStadUserFavoriteService {
    public MineStadUserFavorite selectStadUserFavoriteById(Long favoriteId);
    public List<MineStadUserFavorite> selectStadUserFavoriteList(MineStadUserFavorite favorite);
    public int insertStadUserFavorite(MineStadUserFavorite favorite);
    public int updateStadUserFavorite(MineStadUserFavorite favorite);
    public int deleteStadUserFavoriteById(Long favoriteId);
    public int deleteStadUserFavoriteByIds(Long[] favoriteIds);
    
    /**
     * 获取用户收藏列表（格式化为前端需要的字段）
     */
    List<Map<String, Object>> getFormattedFavoriteList(Long userId, MineStadUserFavorite favorite);
    
    /**
     * 获取用户收藏数量
     */
    int getFavoriteCount(Long userId);
}
