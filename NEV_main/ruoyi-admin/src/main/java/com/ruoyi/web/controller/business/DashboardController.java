package com.ruoyi.web.controller.business;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.domain.AjaxResult;

@RestController
@RequestMapping("/dashboard")
public class DashboardController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/statistics")
    public AjaxResult getStatistics() {
        Map<String, Object> result = new HashMap<>();

        result.put("vehicleCount", queryCount("stad_vehicle"));
        result.put("stationCount", queryCount("stad_charging_station"));
        result.put("pileCount", queryCount("stad_charging_pile"));
        result.put("merchantCount", queryCount("stad_merchant"));
        result.put("orderTotal", queryCount("stad_unified_order"));
        result.put("chargeOrderTotal", queryCount("stad_charging_order"));
        result.put("carbonTotal", querySum("stad_carbon_statistics", "total_reduction"));

        result.put("vehicleBrands", queryVehicleBrands());
        result.put("monthlyOrders", queryMonthlyOrders());
        result.put("stationPower", queryStationPower());
        result.put("radarMetrics", queryRadarMetrics());

        return AjaxResult.success(result);
    }

    private long queryCount(String table) {
        try {
            Long count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM " + table, Long.class);
            return count != null ? count : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    private double querySum(String table, String column) {
        try {
            Double sum = jdbcTemplate.queryForObject(
                "SELECT COALESCE(SUM(" + column + "), 0) FROM " + table, Double.class);
            return sum != null ? sum : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    private List<Map<String, Object>> queryVehicleBrands() {
        try {
            return jdbcTemplate.queryForList(
                "SELECT v.brand AS name, COUNT(*) AS value FROM stad_vehicle v " +
                "WHERE v.brand IS NOT NULL AND v.brand != '' GROUP BY v.brand ORDER BY value DESC LIMIT 8");
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    private List<Map<String, Object>> queryMonthlyOrders() {
        try {
            return jdbcTemplate.queryForList(
                "SELECT DATE_FORMAT(create_time, '%Y-%m') AS month, " +
                "COUNT(*) AS orderCount, COALESCE(SUM(total_amount), 0) AS amount " +
                "FROM stad_unified_order " +
                "WHERE create_time >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) " +
                "GROUP BY DATE_FORMAT(create_time, '%Y-%m') ORDER BY month ASC");
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    private List<Map<String, Object>> queryStationPower() {
        try {
            return jdbcTemplate.queryForList(
                "SELECT s.station_name AS name, COALESCE(SUM(p.power_kw), 0) AS power, " +
                "COUNT(p.pile_id) AS pileCount " +
                "FROM stad_charging_station s " +
                "LEFT JOIN stad_charging_pile p ON s.station_id = p.station_id " +
                "GROUP BY s.station_id, s.station_name ORDER BY power DESC LIMIT 10");
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    private List<Map<String, Object>> queryRadarMetrics() {
        List<Map<String, Object>> metrics = new ArrayList<>();
        try {
            Long vehicleCount = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM stad_vehicle", Long.class);
            Long stationCount = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM stad_charging_station", Long.class);
            Long orderCount = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM stad_unified_order", Long.class);
            Long chargeOrderCount = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM stad_charging_order", Long.class);
            Long merchantCount = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM stad_merchant", Long.class);
            Double carbonTotal = jdbcTemplate.queryForObject(
                "SELECT COALESCE(SUM(total_reduction), 0) FROM stad_carbon_statistics", Double.class);

            addMetric(metrics, "车辆", vehicleCount != null ? vehicleCount : 0, 200);
            addMetric(metrics, "充电站", stationCount != null ? stationCount : 0, 100);
            addMetric(metrics, "购车订单", orderCount != null ? orderCount : 0, 500);
            addMetric(metrics, "充电订单", chargeOrderCount != null ? chargeOrderCount : 0, 1000);
            addMetric(metrics, "商户", merchantCount != null ? merchantCount : 0, 50);
            addMetric(metrics, "碳减排(吨)", carbonTotal != null ? carbonTotal.longValue() : 0, 10000);
        } catch (Exception e) {
            // ignore
        }
        return metrics;
    }

    private void addMetric(List<Map<String, Object>> list, String name, long value, long max) {
        Map<String, Object> metric = new HashMap<>();
        metric.put("name", name);
        metric.put("value", value);
        metric.put("max", max);
        list.add(metric);
    }
}