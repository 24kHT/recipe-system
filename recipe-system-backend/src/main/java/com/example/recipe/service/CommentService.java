package com.example.recipe.service;

import com.example.recipe.dto.CommentRequest;
import com.example.recipe.vo.CommentVO;

import java.util.List;

public interface CommentService {
    CommentVO create(CommentRequest request);

    List<CommentVO> listByRecipe(Long recipeId);

    void delete(Long id);
}
