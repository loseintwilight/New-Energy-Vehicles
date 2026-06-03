package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadUserFavoriteMapper;
import com.ruoyi.business.domain.StadUserFavorite;
import com.ruoyi.business.service.IStadUserFavoriteService;

@Service
public class StadUserFavoriteServiceImpl implements IStadUserFavoriteService {

    @Autowired
    private StadUserFavoriteMapper stadUserFavoriteMapper;

    @Override
    public StadUserFavorite selectStadUserFavoriteById(Long favoriteId) {
        return stadUserFavoriteMapper.selectStadUserFavoriteById(favoriteId);
    }

    @Override
    public List<StadUserFavorite> selectStadUserFavoriteList(StadUserFavorite favorite) {
        return stadUserFavoriteMapper.selectStadUserFavoriteList(favorite);
    }

    @Override
    public int insertStadUserFavorite(StadUserFavorite favorite) {
        return stadUserFavoriteMapper.insertStadUserFavorite(favorite);
    }

    @Override
    public int updateStadUserFavorite(StadUserFavorite favorite) {
        return stadUserFavoriteMapper.updateStadUserFavorite(favorite);
    }

    @Override
    public int deleteStadUserFavoriteByIds(Long[] favoriteIds) {
        return stadUserFavoriteMapper.deleteStadUserFavoriteByIds(favoriteIds);
    }
}