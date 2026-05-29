package com.example.recipe.service;

import com.example.recipe.vo.RecipeVO;

import java.util.List;

public interface FavoriteService {
    void favorite(Long recipeId);

    void cancel(Long recipeId);

    List<RecipeVO> myFavorites();
}
