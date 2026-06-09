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
import com.ruoyi.mine.vo.FavoriteListVO;

@Service("mineStadUserFavoriteServiceImpl")
public class StadUserFavoriteServiceImpl implements IStadUserFavoriteService {

    @Autowired
    @Qualifier("mineStadUserFavoriteMapper")
    private StadUserFavoriteMapper stadUserFavoriteMapper;

    // 首页文章Mock数据（与前端 index/detail.vue 中的 scienceList/policyList 保持一致）
    private static final Map<Long, String[]> ARTICLE_MOCK = new HashMap<>();
    static {
        // 科普/技术文章（target_id 1-4）
        ARTICLE_MOCK.put(1L, new String[]{"冬季新能源车续航为什么会下降", "从电池热管理、空调使用和驾驶习惯解释续航变化。", "科普知识"});
        ARTICLE_MOCK.put(2L, new String[]{"新能源车日常保养小技巧", "掌握这些要点，延长爱车寿命。", "用车指南"});
        ARTICLE_MOCK.put(3L, new String[]{"超级快充与换电技术谁更有未来", "分析两种主流补能方式的优劣势与发展前景。", "行业观察"});
        ARTICLE_MOCK.put(4L, new String[]{"智能驾驶分级L0-L5到底有什么区别", "一张图看懂自动驾驶分级标准，买车不被忽悠。", "科普知识"});
        // 政策资讯文章（target_id 5-8，对应前端 policyList 的 id 1-4）
        ARTICLE_MOCK.put(5L, new String[]{"2025年新能源汽车购置税减免政策延续", "购置日期在2025年1月1日至2025年12月31日期间的新能源汽车免征车辆购置税。", "政策解读"});
        ARTICLE_MOCK.put(6L, new String[]{"济南市充电基础设施补贴实施细则", "对符合条件的公共充电桩建设给予财政补贴。", "地方政策"});
        ARTICLE_MOCK.put(7L, new String[]{"新能源汽车动力电池回收管理办法", "新规明确电池溯源管理及回收主体责任。", "政策法规"});
        ARTICLE_MOCK.put(8L, new String[]{"上海推出新能源汽车专用牌照新政策", "2025年起插混车型不再发放免费专用牌照额度。", "政策解读"});
    }

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
        // 统一 targetType：charging_station → station
        if ("charging_station".equals(favorite.getTargetType())) {
            favorite.setTargetType("station");
        }
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
    public List<FavoriteListVO> getFormattedFavoriteList(Long userId, MineStadUserFavorite favorite) {
        favorite.setUserId(userId);
        List<MineStadUserFavorite> list = selectStadUserFavoriteList(favorite);
        
        List<FavoriteListVO> resultList = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        
        for (MineStadUserFavorite item : list) {
            FavoriteListVO vo = new FavoriteListVO();
            vo.setId(item.getFavoriteId());
            
            String timeStr = item.getCreateTime() != null ? sdf.format(item.getCreateTime()) : "";
            vo.setCreateTime(timeStr);
            
            String targetType = item.getTargetType();
            vo.setTargetId(item.getTargetId());
            if ("vehicle".equals(targetType)) {
                vo.setType("car");
                vo.setModel(item.getTargetName());
                vo.setBrand(getBrandFromModel(item.getTargetName()));
                // 从数据库获取真实续航（range_km）和电池容量（battery_capacity）
                vo.setRange(item.getTargetRange() != null ? item.getTargetRange() : 0);
                vo.setBattery(item.getTargetBattery() != null ? item.getTargetBattery() : BigDecimal.ZERO);
                // 价格：guide_price(分) -> 万元
                if (item.getTargetPrice() != null) {
                    vo.setPrice(item.getTargetPrice().divide(new BigDecimal(10000), 2, BigDecimal.ROUND_HALF_UP));
                } else {
                    vo.setPrice(BigDecimal.ZERO);
                }
            } else if ("station".equals(targetType) || "charging_station".equals(targetType)) {
                vo.setType("charge");
                vo.setStationName(item.getTargetName());
                vo.setAddress(item.getTargetAddress());
                // 从数据库获取最低费率
                BigDecimal stationPrice = item.getTargetStationPrice();
                if (stationPrice != null) {
                    stationPrice = stationPrice.setScale(2, BigDecimal.ROUND_HALF_UP);
                }
                vo.setPrice(stationPrice != null ? stationPrice : BigDecimal.ZERO);
                // 从设施信息中提取标签
                List<String> tagList = new ArrayList<>();
                if (item.getTargetFacilities() != null && !item.getTargetFacilities().isEmpty()) {
                    String[] parts = item.getTargetFacilities().split("、|，|,");
                    for (String p : parts) {
                        String trimmed = p.trim();
                        if (!trimmed.isEmpty()) {
                            tagList.add(trimmed);
                        }
                    }
                }
                // 添加停车费信息作为标签
                if (item.getTargetParkingFee() != null && !item.getTargetParkingFee().isEmpty()) {
                    tagList.add(item.getTargetParkingFee());
                }
                if (tagList.isEmpty()) {
                    tagList.add("快充");
                }
                vo.setTags(tagList);
                // 距离：需要前端根据用户位置计算，暂时返回默认值
                vo.setDistance("2.5");
            } else if ("article".equals(targetType)) {
                vo.setType("text");
                Long articleId = item.getTargetId() != null ? item.getTargetId() : 0L;
                String[] mockArticle = ARTICLE_MOCK.get(articleId);
                if (mockArticle != null) {
                    vo.setTitle(mockArticle[0]);
                    vo.setDesc(mockArticle[1]);
                    vo.setSource(mockArticle[2]);
                } else {
                    vo.setTitle("新能源汽车相关文章");
                    vo.setDesc("点击查看完整内容...");
                    vo.setSource("新能源资讯");
                }
                vo.setTime(timeStr);
            }
            
            resultList.add(vo);
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
    
    @Override
    public int deleteStadUserFavoriteByTarget(Long userId, String targetType, Long targetId) {
        MineStadUserFavorite query = new MineStadUserFavorite();
        query.setUserId(userId);
        query.setTargetType(targetType);
        query.setTargetId(targetId);
        List<MineStadUserFavorite> list = selectStadUserFavoriteList(query);
        if (list != null && !list.isEmpty()) {
            return deleteStadUserFavoriteById(list.get(0).getFavoriteId());
        }
        return 0;
    }
    
    @Override
    public boolean isFavorited(Long userId, String targetType, Long targetId) {
        MineStadUserFavorite query = new MineStadUserFavorite();
        query.setUserId(userId);
        query.setTargetType(targetType);
        query.setTargetId(targetId);
        List<MineStadUserFavorite> list = selectStadUserFavoriteList(query);
        return list != null && !list.isEmpty();
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
