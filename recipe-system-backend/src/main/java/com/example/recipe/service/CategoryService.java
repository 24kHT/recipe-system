package com.example.recipe.service;

import com.example.recipe.dto.CategoryRequest;
import com.example.recipe.entity.Category;

import java.util.List;

public interface CategoryService {
    List<Category> listEnabled();

    Category create(CategoryRequest request);

    Category update(Long id, CategoryRequest request);

    void delete(Long id);
}
