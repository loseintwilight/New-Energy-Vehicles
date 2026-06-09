package com.ruoyi.web.controller.car;

import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.domain.AjaxResult;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.CopyOnWriteArrayList;


@Anonymous
@RestController
@RequestMapping("/admin/car/order")
public class CarOrderReceiveController {


//    内存订单存储
    private static final List<Map<String, Object>> ORDER_STORE = new CopyOnWriteArrayList<>();

//      接收订单数据

    @PostMapping("/receive")
    public AjaxResult receive(@RequestBody Map<String, Object> orderData) {
        orderData.put("_receivedAt", LocalDateTime.now().toString());
        orderData.put("_orderId", UUID.randomUUID().toString().replace("-", "").substring(0, 16));
        ORDER_STORE.add(orderData);
        return AjaxResult.success("接收成功");
    }

//     查询所有订单（供管理端）
    @GetMapping("/list")
    public AjaxResult list() {
        // 按接收时间倒序返回
        List<Map<String, Object>> result = new ArrayList<>(ORDER_STORE);
        result.sort((a, b) -> {
            String ta = (String) a.getOrDefault("_receivedAt", "");
            String tb = (String) b.getOrDefault("_receivedAt", "");
            return tb.compareTo(ta);
        });
        return AjaxResult.success(result);
    }


//     统计概览（管理端）

    @GetMapping("/stats")
    public AjaxResult stats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", ORDER_STORE.size());
        long todayCount = ORDER_STORE.stream()
                .filter(o -> {
                    String receivedAt = (String) o.get("_receivedAt");
                    return receivedAt != null && receivedAt.startsWith(LocalDateTime.now().toString().substring(0, 10));
                })
                .count();
        stats.put("todayCount", todayCount);
        return AjaxResult.success(stats);
    }
}