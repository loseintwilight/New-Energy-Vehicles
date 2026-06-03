package com.ruoyi.web.controller.business;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.domain.AjaxResult;

@RestController
@RequestMapping("/dashboard")
public class DashboardController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/statistics")
    public AjaxResult getStatistics(@RequestParam(required = false) String month,
                                     @RequestParam(required = false) String carbonMonth) {
        Map<String, Object> result = new HashMap<>();

        result.put("totalStats", queryTotalStats());
        result.put("vehicleTypeDistribution", queryVehicleTypeDistribution());
        result.put("vehicleBrands", queryVehicleBrands());
        result.put("orderTypeDistribution", queryOrderTypeDistribution());
        result.put("monthlyOrderTrend", queryMonthlyOrderTrend(month));
        result.put("stationPowerRanking", queryStationPowerRanking());
        result.put("pileStatusDistribution", queryPileStatusDistribution());
        result.put("chargeOrderStatusDistribution", queryChargeOrderStatusDistribution());
        result.put("carbonTrend", queryCarbonTrend(carbonMonth));
        result.put("merchantTypeDistribution", queryMerchantTypeDistribution());
        result.put("latestOrders", queryLatestOrders());
        result.put("latestChargeOrders", queryLatestChargeOrders());
        result.put("todayStats", queryTodayStats());
        result.put("radarMetrics", queryRadarMetrics());

        return AjaxResult.success(result);
    }

    private Map<String, Object> queryTotalStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("vehicleCount", queryLong("SELECT COUNT(*) FROM stad_vehicle"));
        stats.put("vehicleOnSaleCount", queryLong("SELECT COUNT(*) FROM stad_vehicle WHERE status = '1'"));
        stats.put("stationCount", queryLong("SELECT COUNT(*) FROM stad_charging_station"));
        stats.put("stationOnlineCount", queryLong("SELECT COUNT(*) FROM stad_charging_station WHERE station_status = '1'"));
        stats.put("pileCount", queryLong("SELECT COUNT(*) FROM stad_charging_pile"));
        stats.put("pileIdleCount", queryLong("SELECT COUNT(*) FROM stad_charging_pile WHERE pile_status = '0'"));
        stats.put("pileChargingCount", queryLong("SELECT COUNT(*) FROM stad_charging_pile WHERE pile_status = '1'"));
        stats.put("merchantCount", queryLong("SELECT COUNT(*) FROM stad_merchant"));
        stats.put("merchantActiveCount", queryLong("SELECT COUNT(*) FROM stad_merchant WHERE status = '1'"));
        stats.put("orderCount", queryLong("SELECT COUNT(*) FROM stad_unified_order"));
        stats.put("chargeOrderCount", queryLong("SELECT COUNT(*) FROM stad_charging_order"));
        stats.put("maintenanceOrderCount", queryLong("SELECT COUNT(*) FROM stad_maintenance_order"));
        stats.put("feedbackCount", queryLong("SELECT COUNT(*) FROM stad_user_feedback"));
        stats.put("favoriteCount", queryLong("SELECT COUNT(*) FROM stad_user_favorite"));
        stats.put("reviewCount", queryLong("SELECT COUNT(*) FROM stad_vehicle_review"));
        stats.put("maintenanceShopCount", queryLong("SELECT COUNT(*) FROM stad_maintenance_shop"));

        Double carbonKg = queryDouble("SELECT COALESCE(SUM(carbon_reduction), 0) FROM stad_carbon_statistics");
        stats.put("carbonTotal", carbonKg != null ? Math.round(carbonKg / 10.0) / 100.0 : 0);

        Double totalRevenue = queryDouble("SELECT COALESCE(SUM(total_amount), 0) FROM stad_charging_order WHERE order_status = '1'");
        stats.put("totalRevenue", totalRevenue != null ? totalRevenue : 0);

        Double orderRevenue = queryDouble("SELECT COALESCE(SUM(total_amount), 0) FROM stad_unified_order WHERE status = '1'");
        stats.put("orderRevenue", orderRevenue != null ? orderRevenue : 0);

        Long userCount = queryLong("SELECT COUNT(*) FROM sys_user WHERE del_flag = '0'");
        stats.put("userCount", userCount != null ? userCount : 0);

        return stats;
    }

    private List<Map<String, Object>> queryVehicleTypeDistribution() {
        return safeQuery(
            "SELECT vehicle_type AS name, COUNT(*) AS value FROM stad_vehicle GROUP BY vehicle_type ORDER BY value DESC"
        );
    }

    private List<Map<String, Object>> queryVehicleBrands() {
        return safeQuery(
            "SELECT v.model_name AS name, COUNT(*) AS value FROM stad_vehicle v " +
            "WHERE v.model_name IS NOT NULL AND v.model_name != '' GROUP BY v.model_name ORDER BY value DESC LIMIT 10"
        );
    }

    private List<Map<String, Object>> queryOrderTypeDistribution() {
        return safeQuery(
            "SELECT order_type AS name, COUNT(*) AS value FROM stad_unified_order GROUP BY order_type ORDER BY value DESC"
        );
    }

    private List<Map<String, Object>> queryMonthlyOrderTrend(String month) {
        String yearMonth = (month != null && month.matches("\\d{4}-\\d{2}")) ? month
            : LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
        String firstDay = yearMonth + "-01";

        List<Map<String, Object>> orderData = safeQuery(
            "SELECT DATE(create_time) AS orderDate, " +
            "COUNT(*) AS orderCount, COALESCE(SUM(total_amount), 0) AS amount " +
            "FROM stad_unified_order " +
            "WHERE create_time >= ? AND create_time < DATE_ADD(?, INTERVAL 1 MONTH) " +
            "GROUP BY DATE(create_time)",
            firstDay, firstDay
        );

        Map<String, Map<String, Object>> orderMap = new LinkedHashMap<>();
        for (Map<String, Object> row : orderData) {
            String key = row.get("orderDate") != null ? row.get("orderDate").toString() : "";
            if (!key.isEmpty()) orderMap.put(key, row);
        }

        List<Map<String, Object>> result = new ArrayList<>();
        try {
            LocalDate start = LocalDate.parse(firstDay);
            LocalDate end = start.plusMonths(1);
            DateTimeFormatter displayFmt = DateTimeFormatter.ofPattern("MM-dd");
            DateTimeFormatter keyFmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");

            for (LocalDate d = start; d.isBefore(end); d = d.plusDays(1)) {
                Map<String, Object> item = new HashMap<>();
                item.put("month", d.format(displayFmt));
                String key = d.format(keyFmt);
                Map<String, Object> od = orderMap.get(key);
                item.put("orderCount", od != null ? od.get("orderCount") : 0L);
                item.put("amount", od != null ? od.get("amount") : 0.0);
                result.add(item);
            }
        } catch (Exception e) {
            for (Map<String, Object> row : orderData) {
                Map<String, Object> item = new HashMap<>();
                String dateStr = row.get("orderDate") != null ? row.get("orderDate").toString() : "";
                item.put("month", dateStr.length() >= 5 ? dateStr.substring(5) : dateStr);
                item.put("orderCount", row.get("orderCount"));
                item.put("amount", row.get("amount"));
                result.add(item);
            }
        }
        return result;
    }

    private List<Map<String, Object>> queryStationPowerRanking() {
        return safeQuery(
            "SELECT s.station_name AS name, COALESCE(SUM(p.power_kw), 0) AS power, " +
            "COUNT(p.pile_id) AS pileCount " +
            "FROM stad_charging_station s " +
            "LEFT JOIN stad_charging_pile p ON s.station_id = p.station_id " +
            "GROUP BY s.station_id, s.station_name ORDER BY power DESC LIMIT 10"
        );
    }

    private List<Map<String, Object>> queryPileStatusDistribution() {
        return safeQuery(
            "SELECT CASE pile_status WHEN '0' THEN '空闲' WHEN '1' THEN '充电中' " +
            "WHEN '2' THEN '离线' WHEN '3' THEN '故障' ELSE '未知' END AS name, " +
            "COUNT(*) AS value FROM stad_charging_pile GROUP BY pile_status ORDER BY value DESC"
        );
    }

    private List<Map<String, Object>> queryChargeOrderStatusDistribution() {
        return safeQuery(
            "SELECT CASE order_status WHEN '0' THEN '充电中' WHEN '1' THEN '已完成' " +
            "WHEN '2' THEN '已取消' ELSE '未知' END AS name, " +
            "COUNT(*) AS value FROM stad_charging_order GROUP BY order_status ORDER BY value DESC"
        );
    }

    private List<Map<String, Object>> queryCarbonTrend(String month) {
        String yearMonth = (month != null && month.matches("\\d{4}-\\d{2}")) ? month
            : LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
        String firstDay = yearMonth + "-01";

        List<Map<String, Object>> rawData = safeQuery(
            "SELECT stat_date AS orderDate, " +
            "COALESCE(SUM(carbon_reduction), 0) AS carbon, " +
            "COALESCE(SUM(total_energy), 0) AS energy, " +
            "COALESCE(SUM(total_charge_orders), 0) AS chargeOrders " +
            "FROM stad_carbon_statistics " +
            "WHERE stat_date >= ? AND stat_date < DATE_ADD(?, INTERVAL 1 MONTH) " +
            "GROUP BY stat_date",
            firstDay, firstDay
        );

        Map<String, Map<String, Object>> dataMap = new LinkedHashMap<>();
        for (Map<String, Object> row : rawData) {
            String key = row.get("orderDate") != null ? row.get("orderDate").toString() : "";
            if (!key.isEmpty()) dataMap.put(key, row);
        }

        List<Map<String, Object>> result = new ArrayList<>();
        try {
            LocalDate start = LocalDate.parse(firstDay);
            LocalDate end = start.plusMonths(1);
            DateTimeFormatter displayFmt = DateTimeFormatter.ofPattern("MM-dd");
            DateTimeFormatter keyFmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");

            for (LocalDate d = start; d.isBefore(end); d = d.plusDays(1)) {
                Map<String, Object> item = new HashMap<>();
                item.put("month", d.format(displayFmt));
                String key = d.format(keyFmt);
                Map<String, Object> row = dataMap.get(key);
                item.put("carbon", row != null ? row.get("carbon") : 0.0);
                item.put("energy", row != null ? row.get("energy") : 0.0);
                item.put("chargeOrders", row != null ? row.get("chargeOrders") : 0L);
                result.add(item);
            }
        } catch (Exception e) {
            for (Map<String, Object> row : rawData) {
                Map<String, Object> item = new HashMap<>();
                String dateStr = row.get("orderDate") != null ? row.get("orderDate").toString() : "";
                item.put("month", dateStr.length() >= 5 ? dateStr.substring(5) : dateStr);
                item.put("carbon", row.get("carbon"));
                item.put("energy", row.get("energy"));
                item.put("chargeOrders", row.get("chargeOrders"));
                result.add(item);
            }
        }
        return result;
    }

    private List<Map<String, Object>> queryMerchantTypeDistribution() {
        return safeQuery(
            "SELECT CASE merchant_type WHEN 'dealer' THEN '经销商' WHEN 'charger' THEN '充电运营商' " +
            "WHEN 'maintenance' THEN '维保商' ELSE '其他' END AS name, " +
            "COUNT(*) AS value FROM stad_merchant GROUP BY merchant_type ORDER BY value DESC"
        );
    }

    private List<Map<String, Object>> queryLatestOrders() {
        return safeQuery(
            "SELECT o.order_no AS orderNo, u.nick_name AS userName, v.title AS vehicleName, " +
            "o.order_type AS orderType, o.total_amount AS amount, o.status, " +
            "DATE_FORMAT(o.create_time, '%Y-%m-%d %H:%i') AS createTime " +
            "FROM stad_unified_order o " +
            "LEFT JOIN sys_user u ON o.user_id = u.user_id " +
            "LEFT JOIN stad_vehicle v ON o.vehicle_id = v.vehicle_id " +
            "ORDER BY o.create_time DESC LIMIT 10"
        );
    }

    private List<Map<String, Object>> queryLatestChargeOrders() {
        return safeQuery(
            "SELECT o.order_no AS orderNo, u.nick_name AS userName, " +
            "s.station_name AS stationName, o.total_energy AS energy, " +
            "o.total_amount AS amount, o.order_status AS orderStatus, o.pay_status AS payStatus, " +
            "DATE_FORMAT(o.create_time, '%Y-%m-%d %H:%i') AS createTime " +
            "FROM stad_charging_order o " +
            "LEFT JOIN sys_user u ON o.user_id = u.user_id " +
            "LEFT JOIN stad_charging_station s ON o.station_id = s.station_id " +
            "ORDER BY o.create_time DESC LIMIT 10"
        );
    }

    private Map<String, Object> queryTodayStats() {
        Map<String, Object> today = new HashMap<>();
        String todayCond = "DATE(create_time) = CURDATE()";

        today.put("newOrders", queryLong("SELECT COUNT(*) FROM stad_unified_order WHERE " + todayCond));
        today.put("newChargeOrders", queryLong("SELECT COUNT(*) FROM stad_charging_order WHERE " + todayCond));
        today.put("newVehicles", queryLong("SELECT COUNT(*) FROM stad_vehicle WHERE " + todayCond));
        today.put("newFeedback", queryLong("SELECT COUNT(*) FROM stad_user_feedback WHERE " + todayCond));
        today.put("newMaintenanceOrders", queryLong("SELECT COUNT(*) FROM stad_maintenance_order WHERE " + todayCond));
        today.put("newReviews", queryLong("SELECT COUNT(*) FROM stad_vehicle_review WHERE " + todayCond));
        today.put("newMerchants", queryLong("SELECT COUNT(*) FROM stad_merchant WHERE " + todayCond));

        Double todayRevenue = queryDouble(
            "SELECT COALESCE(SUM(total_amount), 0) FROM stad_charging_order WHERE order_status = '1' AND " + todayCond
        );
        today.put("todayRevenue", todayRevenue != null ? todayRevenue : 0);

        Double todayOrderRevenue = queryDouble(
            "SELECT COALESCE(SUM(total_amount), 0) FROM stad_unified_order WHERE status = '1' AND " + todayCond
        );
        today.put("todayOrderRevenue", todayOrderRevenue != null ? todayOrderRevenue : 0);

        Double todayEnergy = queryDouble(
            "SELECT COALESCE(SUM(total_energy), 0) FROM stad_charging_order WHERE " + todayCond
        );
        today.put("todayEnergy", todayEnergy != null ? todayEnergy : 0);

        Long todayUsers = queryLong("SELECT COUNT(*) FROM sys_user WHERE del_flag = '0' AND " + todayCond);
        today.put("todayUsers", todayUsers != null ? todayUsers : 0);

        return today;
    }

    private List<Map<String, Object>> queryRadarMetrics() {
        List<Map<String, Object>> metrics = new ArrayList<>();
        try {
            long maxVehicle = Math.max(queryLong("SELECT COUNT(*) FROM stad_vehicle"), 1);
            long maxStation = Math.max(queryLong("SELECT COUNT(*) FROM stad_charging_station"), 1);
            long maxOrder = Math.max(queryLong("SELECT COUNT(*) FROM stad_unified_order"), 1);
            long maxChargeOrder = Math.max(queryLong("SELECT COUNT(*) FROM stad_charging_order"), 1);
            long maxMerchant = Math.max(queryLong("SELECT COUNT(*) FROM stad_merchant"), 1);
            long maxPile = Math.max(queryLong("SELECT COUNT(*) FROM stad_charging_pile"), 1);

            addMetric(metrics, "车辆", maxVehicle, maxVehicle * 2);
            addMetric(metrics, "充电站", maxStation, maxStation * 2);
            addMetric(metrics, "充电桩", maxPile, maxPile * 2);
            addMetric(metrics, "购车订单", maxOrder, maxOrder * 2);
            addMetric(metrics, "充电订单", maxChargeOrder, maxChargeOrder * 2);
            addMetric(metrics, "商户", maxMerchant, maxMerchant * 2);
        } catch (Exception e) {
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

    private long queryLong(String sql) {
        try {
            Number result = jdbcTemplate.queryForObject(sql, Number.class);
            return result != null ? result.longValue() : 0L;
        } catch (Exception e) {
            return 0L;
        }
    }

    private double queryDouble(String sql) {
        try {
            Number result = jdbcTemplate.queryForObject(sql, Number.class);
            return result != null ? result.doubleValue() : 0.0;
        } catch (Exception e) {
            return 0.0;
        }
    }

    private List<Map<String, Object>> safeQuery(String sql) {
        try {
            return jdbcTemplate.queryForList(sql);
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    private List<Map<String, Object>> safeQuery(String sql, Object... args) {
        try {
            return jdbcTemplate.queryForList(sql, args);
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
}