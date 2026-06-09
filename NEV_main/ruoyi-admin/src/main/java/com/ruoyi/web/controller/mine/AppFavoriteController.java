package com.ruoyi.web.controller.mine;

import com.ruoyi.mine.domain.MineStadUserFavorite;
import com.ruoyi.mine.service.IStadUserFavoriteService;
import com.ruoyi.mine.vo.FavoriteListVO;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/app/collection")
public class AppFavoriteController extends BaseController {

    @Autowired
    private IStadUserFavoriteService stadUserFavoriteService;

    @GetMapping("/list")
    public TableDataInfo getCollectionList(MineStadUserFavorite favorite) {
        startPage();
        Long userId = SecurityUtils.getUserId();
        List<FavoriteListVO> resultList = stadUserFavoriteService.getFormattedFavoriteList(userId, favorite);
        return getDataTable(resultList);
    }

    @Log(title = "收藏", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult addCollection(@RequestBody MineStadUserFavorite favorite) {
        Long userId = SecurityUtils.getUserId();
        favorite.setUserId(userId);
        int result = stadUserFavoriteService.insertStadUserFavorite(favorite);
        return toAjax(result);
    }

    @Log(title = "收藏", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public AjaxResult cancelCollection(@PathVariable Long id) {
        int result = stadUserFavoriteService.deleteStadUserFavoriteById(id);
        return toAjax(result);
    }

    /**
     * 按目标类型+目标ID取消收藏
     */
    @Log(title = "收藏", businessType = BusinessType.DELETE)
    @DeleteMapping("/target")
    public AjaxResult cancelCollectionByTarget(@RequestParam String targetType, @RequestParam Long targetId) {
        Long userId = SecurityUtils.getUserId();
        int result = stadUserFavoriteService.deleteStadUserFavoriteByTarget(userId, targetType, targetId);
        return toAjax(result);
    }

    /**
     * 查询指定目标的收藏状态
     */
    @GetMapping("/status")
    public AjaxResult getFavoriteStatus(@RequestParam String targetType, @RequestParam Long targetId) {
        Long userId = SecurityUtils.getUserId();
        boolean isFavorited = stadUserFavoriteService.isFavorited(userId, targetType, targetId);
        return AjaxResult.success(isFavorited);
    }

    @GetMapping("/count")
    public AjaxResult getCollectionCount() {
        Long userId = SecurityUtils.getUserId();
        int count = stadUserFavoriteService.getFavoriteCount(userId);
        return AjaxResult.success(count);
    }
}
