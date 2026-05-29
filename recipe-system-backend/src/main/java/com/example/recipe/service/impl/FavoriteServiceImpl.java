package com.example.recipe.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.recipe.context.UserContext;
import com.example.recipe.entity.Favorite;
import com.example.recipe.entity.Recipe;
import com.example.recipe.exception.BusinessException;
import com.example.recipe.mapper.FavoriteMapper;
import com.example.recipe.mapper.RecipeMapper;
import com.example.recipe.service.FavoriteService;
import com.example.recipe.service.RecipeService;
import com.example.recipe.vo.RecipeVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class FavoriteServiceImpl implements FavoriteService {
    private final FavoriteMapper favoriteMapper;
    private final RecipeMapper recipeMapper;
    private final RecipeService recipeService;

    @Override
    public void favorite(Long recipeId) {
        Long userId = requireUserId();
        Recipe recipe = recipeMapper.selectById(recipeId);
        if (recipe == null || recipe.getDeleted() == 1) {
            throw BusinessException.notFound("菜谱不存在");
        }
        Favorite favorite = favoriteMapper.selectOne(new LambdaQueryWrapper<Favorite>()
                .eq(Favorite::getUserId, userId)
                .eq(Favorite::getRecipeId, recipeId)
                .last("LIMIT 1"));
        if (favorite != null && favorite.getDeleted() == 0) {
            throw BusinessException.badRequest("已经收藏过该菜谱");
        }
        if (favorite == null) {
            favorite = new Favorite();
            favorite.setUserId(userId);
            favorite.setRecipeId(recipeId);
            favorite.setCreateTime(LocalDateTime.now());
            favorite.setDeleted(0);
            favoriteMapper.insert(favorite);
        } else {
            favorite.setDeleted(0);
            favorite.setCreateTime(LocalDateTime.now());
            favoriteMapper.updateById(favorite);
        }
        refreshCount(recipeId);
    }

    @Override
    public void cancel(Long recipeId) {
        Long userId = requireUserId();
        Favorite favorite = favoriteMapper.selectOne(new LambdaQueryWrapper<Favorite>()
                .eq(Favorite::getUserId, userId)
                .eq(Favorite::getRecipeId, recipeId)
                .eq(Favorite::getDeleted, 0)
                .last("LIMIT 1"));
        if (favorite != null) {
            favorite.setDeleted(1);
            favoriteMapper.updateById(favorite);
        }
        refreshCount(recipeId);
    }

    @Override
    public List<RecipeVO> myFavorites() {
        Long userId = requireUserId();
        return favoriteMapper.selectList(new LambdaQueryWrapper<Favorite>()
                        .eq(Favorite::getUserId, userId)
                        .eq(Favorite::getDeleted, 0)
                        .orderByDesc(Favorite::getId))
                .stream()
                .map(Favorite::getRecipeId)
                .map(recipeService::detail)
                .toList();
    }

    private Long requireUserId() {
        Long userId = UserContext.userId();
        if (userId == null) {
            throw BusinessException.unauthorized("未登录或 token 无效");
        }
        return userId;
    }

    private void refreshCount(Long recipeId) {
        Recipe recipe = recipeMapper.selectById(recipeId);
        if (recipe != null) {
            long count = favoriteMapper.selectCount(new LambdaQueryWrapper<Favorite>()
                    .eq(Favorite::getRecipeId, recipeId)
                    .eq(Favorite::getDeleted, 0));
            recipe.setFavoriteCount((int) count);
            recipe.setUpdateTime(LocalDateTime.now());
            recipeMapper.updateById(recipe);
        }
    }
}
