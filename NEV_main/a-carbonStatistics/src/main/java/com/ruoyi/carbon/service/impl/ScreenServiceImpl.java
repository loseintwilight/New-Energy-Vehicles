package com.ruoyi.carbon.service.impl;

import com.ruoyi.carbon.mapper.ScreenMapper;
import com.ruoyi.carbon.service.IScreenService;
import com.ruoyi.carbon.vo.ScreenDataVO;
import com.ruoyi.carbon.vo.ScreenDistrictVO;
import com.ruoyi.carbon.vo.ScreenTotalStatsVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 数据大屏 - Service 实现
 */
@Service
public class ScreenServiceImpl implements IScreenService {

    @Autowired
    private ScreenMapper screenMapper;

    @Override
    public ScreenDataVO getScreenData() {
        ScreenDataVO vo = new ScreenDataVO();

        // 各区县碳减排
        List<Map<String, Object>> carbonRaw = screenMapper.selectScreenCarbonData();
        vo.setCarbonReductionData(convertToDistrictList(carbonRaw));

        // 各区县新能源车
        List<Map<String, Object>> evRaw = screenMapper.selectScreenEVData();
        vo.setEvData(convertToDistrictList(evRaw));

        // 各区县充电桩
        List<Map<String, Object>> pileRaw = screenMapper.selectScreenPileData();
        vo.setPilesData(convertToDistrictList(pileRaw));

        // 顶部卡片汇总
        ScreenTotalStatsVO totals = new ScreenTotalStatsVO();
        Long totalPiles = screenMapper.countPiles();
        totals.setTotalPiles(totalPiles != null ? totalPiles : 0L);
        Long totalEV = screenMapper.sumEV();
        totals.setTotalEV(totalEV != null ? totalEV : 0L);
        Double totalReduction = screenMapper.sumCarbonReduction();
        totals.setTotalReduction(totalReduction != null ? Math.round(totalReduction) : 0.0);
        vo.setTotalStats(totals);

        return vo;
    }

    /**
     * 将 Map 列表转换为 ScreenDistrictVO 列表
     */
    private List<ScreenDistrictVO> convertToDistrictList(List<Map<String, Object>> rawList) {
        List<ScreenDistrictVO> list = new ArrayList<>();
        if (rawList != null) {
            for (Map<String, Object> map : rawList) {
                ScreenDistrictVO vo = new ScreenDistrictVO();
                vo.setName(map.get("name") != null ? map.get("name").toString() : null);
                vo.setValue(map.get("value"));
                list.add(vo);
            }
        }
        return list;
    }
}