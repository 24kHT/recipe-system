package com.example.recipe.controller;

import com.example.recipe.common.Result;
import com.example.recipe.service.FavoriteService;
import com.example.recipe.vo.RecipeVO;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/favorite")
public class FavoriteController {
    private final FavoriteService favoriteService;

    @PostMapping("/{recipeId}")
    public Result<Void> favorite(@PathVariable Long recipeId) {
        favoriteService.favorite(recipeId);
        return Result.ok("收藏成功", null);
    }

    @DeleteMapping("/{recipeId}")
    public Result<Void> cancel(@PathVariable Long recipeId) {
        favoriteService.cancel(recipeId);
        return Result.ok("已取消收藏", null);
    }

    @GetMapping("/my")
    public Result<List<RecipeVO>> myFavorites() {
        return Result.ok(favoriteService.myFavorites());
    }
}
