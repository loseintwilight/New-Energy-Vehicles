package com.ruoyi.mine.service;

import java.util.List;
import com.ruoyi.mine.domain.MineStadUserFavorite;
import com.ruoyi.mine.vo.FavoriteListVO;

public interface IStadUserFavoriteService {
    public MineStadUserFavorite selectStadUserFavoriteById(Long favoriteId);
    public List<MineStadUserFavorite> selectStadUserFavoriteList(MineStadUserFavorite favorite);
    public int insertStadUserFavorite(MineStadUserFavorite favorite);
    public int updateStadUserFavorite(MineStadUserFavorite favorite);
    public int deleteStadUserFavoriteById(Long favoriteId);
    public int deleteStadUserFavoriteByIds(Long[] favoriteIds);
    
    /**
     * 获取用户收藏列表（格式化为前端需要的VO）
     */
    List<FavoriteListVO> getFormattedFavoriteList(Long userId, MineStadUserFavorite favorite);
    
    /**
     * 获取用户收藏数量
     */
    int getFavoriteCount(Long userId);
    
    /**
     * 按目标类型+目标ID删除收藏
     */
    int deleteStadUserFavoriteByTarget(Long userId, String targetType, Long targetId);
    
    /**
     * 判断指定目标是否已被收藏
     */
    boolean isFavorited(Long userId, String targetType, Long targetId);
}
