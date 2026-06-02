package com.ruoyi.web.controller.business;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.business.domain.StadUserFavorite;
import com.ruoyi.business.service.IStadUserFavoriteService;

@RestController
@RequestMapping("/business/favorite")
public class StadUserFavoriteController extends BaseController {

    @Autowired
    private IStadUserFavoriteService stadUserFavoriteService;

    @PreAuthorize("@ss.hasPermi('business:favorite:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadUserFavorite favorite) {
        startPage();
        List<StadUserFavorite> list = stadUserFavoriteService.selectStadUserFavoriteList(favorite);
        return getDataTable(list);
    }

    @GetMapping(value = "/{favoriteId}")
    public AjaxResult getInfo(@PathVariable Long favoriteId) {
        return success(stadUserFavoriteService.selectStadUserFavoriteById(favoriteId));
    }

    @PreAuthorize("@ss.hasPermi('business:favorite:add')")
    @Log(title = "用户收藏管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody StadUserFavorite favorite) {
        favorite.setCreateBy(getUsername());
        return toAjax(stadUserFavoriteService.insertStadUserFavorite(favorite));
    }

    @PreAuthorize("@ss.hasPermi('business:favorite:edit')")
    @Log(title = "用户收藏管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody StadUserFavorite favorite) {
        favorite.setUpdateBy(getUsername());
        return toAjax(stadUserFavoriteService.updateStadUserFavorite(favorite));
    }

    @PreAuthorize("@ss.hasPermi('business:favorite:remove')")
    @Log(title = "用户收藏管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{favoriteIds}")
    public AjaxResult remove(@PathVariable Long[] favoriteIds) {
        return toAjax(stadUserFavoriteService.deleteStadUserFavoriteByIds(favoriteIds));
    }
}