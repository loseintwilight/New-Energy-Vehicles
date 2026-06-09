package com.ruoyi.web.controller.maintain;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ruoyi.business.domain.StadMaintenanceShop;
import com.ruoyi.business.service.IStadMaintenanceShopService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.R;
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
        StadMaintenanceShop shop = new StadMaintenanceShop();
        shop.setShopName((String) params.get("shop_name"));
        shop.setProvince((String) params.get("province"));
        shop.setCity((String) params.get("city"));
        shop.setDistrict((String) params.get("district"));
        shop.setAddress((String) params.get("address"));
        if (params.containsKey("longitude")) {
            shop.setLongitude(new BigDecimal(params.get("longitude").toString()));
        }
        if (params.containsKey("latitude")) {
            shop.setLatitude(new BigDecimal(params.get("latitude").toString()));
        }
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
        if (params.containsKey("longitude")) {
            shop.setLongitude(new BigDecimal(params.get("longitude").toString()));
        }
        if (params.containsKey("latitude")) {
            shop.setLatitude(new BigDecimal(params.get("latitude").toString()));
        }
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
