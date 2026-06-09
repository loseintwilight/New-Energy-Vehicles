package com.ruoyi.mine.service.impl;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import com.ruoyi.mine.mapper.StadUserFavoriteMapper;
import com.ruoyi.mine.domain.MineStadUserFavorite;
import com.ruoyi.mine.service.IStadUserFavoriteService;

@Service("mineStadUserFavoriteServiceImpl")
public class StadUserFavoriteServiceImpl implements IStadUserFavoriteService {

    @Autowired
    @Qualifier("mineStadUserFavoriteMapper")
    private StadUserFavoriteMapper stadUserFavoriteMapper;

    @Override
    public MineStadUserFavorite selectStadUserFavoriteById(Long favoriteId) {
        return stadUserFavoriteMapper.selectStadUserFavoriteById(favoriteId);
    }

    @Override
    public List<MineStadUserFavorite> selectStadUserFavoriteList(MineStadUserFavorite favorite) {
        return stadUserFavoriteMapper.selectStadUserFavoriteList(favorite);
    }

    @Override
    public int insertStadUserFavorite(MineStadUserFavorite favorite) {
        return stadUserFavoriteMapper.insertStadUserFavorite(favorite);
    }

    @Override
    public int updateStadUserFavorite(MineStadUserFavorite favorite) {
        return stadUserFavoriteMapper.updateStadUserFavorite(favorite);
    }

    @Override
    public int deleteStadUserFavoriteById(Long favoriteId) {
        return stadUserFavoriteMapper.deleteStadUserFavoriteById(favoriteId);
    }

    @Override
    public int deleteStadUserFavoriteByIds(Long[] favoriteIds) {
        return stadUserFavoriteMapper.deleteStadUserFavoriteByIds(favoriteIds);
    }

    @Override
    public List<Map<String, Object>> getFormattedFavoriteList(Long userId, MineStadUserFavorite favorite) {
        favorite.setUserId(userId);
        List<MineStadUserFavorite> list = selectStadUserFavoriteList(favorite);
        
        List<Map<String, Object>> resultList = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        
        for (MineStadUserFavorite item : list) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", item.getFavoriteId());
            
            String targetType = item.getTargetType();
            if ("vehicle".equals(targetType)) {
                map.put("type", "car");
                map.put("model", item.getTargetName());
                map.put("brand", getBrandFromModel(item.getTargetName()));
                map.put("range", 600);
                map.put("battery", 80);
                map.put("price", item.getTargetPrice() != null ? item.getTargetPrice().divide(new BigDecimal(10000), 2, BigDecimal.ROUND_HALF_UP).doubleValue() : 0);
            } else if ("station".equals(targetType)) {
                map.put("type", "charge");
                map.put("stationName", item.getTargetName());
                map.put("distance", "2.5");
                map.put("address", item.getTargetAddress());
                map.put("price", 1.2);
                map.put("tags", new String[]{"快充", "免费停车"});
            } else if ("article".equals(targetType)) {
                map.put("type", "text");
                map.put("title", item.getTargetName());
                map.put("desc", "这是一篇关于新能源汽车的文章内容预览...");
                map.put("source", "新能源资讯");
                Date createTime = item.getCreateTime();
                String timeStr = createTime != null ? sdf.format(createTime) : "";
                map.put("time", timeStr);
                map.put("createTime", timeStr);
            }
            
            resultList.add(map);
        }
        
        return resultList;
    }

    @Override
    public int getFavoriteCount(Long userId) {
        MineStadUserFavorite query = new MineStadUserFavorite();
        query.setUserId(userId);
        List<MineStadUserFavorite> list = selectStadUserFavoriteList(query);
        return list != null ? list.size() : 0;
    }
    
    private String getBrandFromModel(String model) {
        if (model == null) return "";
        if (model.contains("比亚迪")) return "比亚迪";
        if (model.contains("特斯拉")) return "特斯拉";
        if (model.contains("小鹏")) return "小鹏";
        if (model.contains("蔚来")) return "蔚来";
        if (model.contains("理想")) return "理想";
        return "其他";
    }
}
