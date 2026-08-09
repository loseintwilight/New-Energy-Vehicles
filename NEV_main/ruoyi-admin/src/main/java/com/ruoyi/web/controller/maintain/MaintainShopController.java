package com.ruoyi.web.controller.maintain;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ruoyi.business.domain.StadMaintenanceShop;
import com.ruoyi.business.domain.StadMerchant;
import com.ruoyi.business.service.IStadMaintenanceShopService;
import com.ruoyi.business.service.IStadMerchantService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.R;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * @Classname MaintainShopController
 * @Description
 * @Date 2026/6/7 17:00
 * @Created by 高合吴彦祖鹏哥
 */
@RestController
@RequestMapping("/maintenance/shop")
public class MaintainShopController extends BaseController {
    @Autowired
    private IStadMaintenanceShopService shopService;

    @Autowired
    private IStadMerchantService merchantService;

    @GetMapping("/list")
    public R list(Integer pageNum, Integer pageSize, String keyword, String status) {
        PageHelper.startPage(pageNum, pageSize);
        StadMaintenanceShop query = new StadMaintenanceShop();
        query.setShopName(keyword);
        if (status != null && !status.isEmpty()) {
            query.setStatus(Integer.valueOf(status));
        }
        List<StadMaintenanceShop> list = shopService.selectStadMaintenanceShopList(query);
        PageInfo<StadMaintenanceShop> pageInfo = new PageInfo<>(list);
        return R.ok(pageInfo);
    }

    @GetMapping("/detail")
    public R detail(@RequestParam("shop_id") Long shopId) {
        return R.ok(shopService.selectStadMaintenanceShopById(shopId));
    }

    @PostMapping("/create")
    public R create(@RequestBody Map<String, Object> params) {
        // 获取当前登录用户的商户ID（merchant_id 是 NOT NULL 字段）
        Long merchantId = null;
        try {
            Long userId = SecurityUtils.getUserId();
            if (userId != null) {
                StadMerchant merchant = merchantService.selectStadMerchantByUserId(userId);
                if (merchant != null) {
                    merchantId = merchant.getMerchantId();
                }
            }
        } catch (Exception ignored) {}
        if (merchantId == null) {
            return R.fail("未找到商户信息，请确认已入驻维保商");
        }

        StadMaintenanceShop shop = new StadMaintenanceShop();
        shop.setMerchantId(merchantId);
        shop.setShopName((String) params.get("shop_name"));
        shop.setProvince((String) params.get("province"));
        shop.setCity((String) params.get("city"));
        shop.setDistrict((String) params.get("district"));
        shop.setAddress((String) params.get("address"));
        try {
            String lngStr = (String) params.get("longitude");
            if (lngStr != null && !lngStr.isEmpty()) {
                shop.setLongitude(new BigDecimal(lngStr));
            }
        } catch (Exception ignored) {}
        try {
            String latStr = (String) params.get("latitude");
            if (latStr != null && !latStr.isEmpty()) {
                shop.setLatitude(new BigDecimal(latStr));
            }
        } catch (Exception ignored) {}
        shop.setContactName((String) params.get("contact_name"));
        shop.setContactPhone((String) params.get("contact_phone"));
        shop.setServicesInfo((String) params.get("services_info"));
        shop.setDescription((String) params.get("description"));
        shop.setRating(BigDecimal.ZERO);
        shop.setStatus(0);
        return R.ok(shopService.insertStadMaintenanceShop(shop));
    }

    @PutMapping("/update")
    public R update(@RequestBody Map<String, Object> params) {
        StadMaintenanceShop shop = new StadMaintenanceShop();
        shop.setShopId(Long.valueOf(params.get("shop_id").toString()));
        shop.setShopName((String) params.get("shop_name"));
        shop.setProvince((String) params.get("province"));
        shop.setCity((String) params.get("city"));
        shop.setDistrict((String) params.get("district"));
        shop.setAddress((String) params.get("address"));
        try {
            String lngStr = (String) params.get("longitude");
            if (lngStr != null && !lngStr.isEmpty()) {
                shop.setLongitude(new BigDecimal(lngStr));
            }
        } catch (Exception ignored) {}
        try {
            String latStr = (String) params.get("latitude");
            if (latStr != null && !latStr.isEmpty()) {
                shop.setLatitude(new BigDecimal(latStr));
            }
        } catch (Exception ignored) {}
        shop.setContactName((String) params.get("contact_name"));
        shop.setContactPhone((String) params.get("contact_phone"));
        shop.setServicesInfo((String) params.get("services_info"));
        shop.setDescription((String) params.get("description"));
        return R.ok(shopService.updateStadMaintenanceShop(shop));
    }

    @DeleteMapping("/delete")
    public R delete(@RequestParam("shop_id") Long shopId) {
        return R.ok(shopService.deleteStadMaintenanceShopByIds(new Long[]{shopId}));
    }
}
