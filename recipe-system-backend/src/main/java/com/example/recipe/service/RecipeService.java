package com.example.recipe.service;

import com.example.recipe.common.PageResult;
import com.example.recipe.dto.RecipeRequest;
import com.example.recipe.vo.RecipeVO;

import java.util.List;

public interface RecipeService {
    RecipeVO create(RecipeRequest request);

    PageResult<RecipeVO> page(Integer page, Integer pageSize, String keyword, Long categoryId, Boolean includeDisabled);

    RecipeVO detail(Long id);

    RecipeVO update(Long id, RecipeRequest request);

    void delete(Long id);

    List<RecipeVO> myRecipes();

    void toggleStatus(Long id);
}
