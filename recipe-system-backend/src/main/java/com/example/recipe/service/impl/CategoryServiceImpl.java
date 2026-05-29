package com.example.recipe.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.recipe.dto.CategoryRequest;
import com.example.recipe.entity.Category;
import com.example.recipe.exception.BusinessException;
import com.example.recipe.mapper.CategoryMapper;
import com.example.recipe.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService {
    private final CategoryMapper categoryMapper;

    @Override
    public List<Category> listEnabled() {
        return categoryMapper.selectList(new LambdaQueryWrapper<Category>()
                .eq(Category::getDeleted, 0)
                .eq(Category::getStatus, 1)
                .orderByAsc(Category::getSort)
                .orderByDesc(Category::getId));
    }

    @Override
    public Category create(CategoryRequest request) {
        LocalDateTime time = LocalDateTime.now();
        Category category = new Category();
        category.setName(request.getName());
        category.setIcon(request.getIcon());
        category.setSort(request.getSort() == null ? 0 : request.getSort());
        category.setStatus(request.getStatus() == null ? 1 : request.getStatus());
        category.setDeleted(0);
        category.setCreateTime(time);
        category.setUpdateTime(time);
        categoryMapper.insert(category);
        return category;
    }

    @Override
    public Category update(Long id, CategoryRequest request) {
        Category category = categoryMapper.selectById(id);
        if (category == null || category.getDeleted() == 1) {
            throw BusinessException.notFound("分类不存在");
        }
        category.setName(request.getName());
        category.setIcon(request.getIcon());
        category.setSort(request.getSort() == null ? category.getSort() : request.getSort());
        category.setStatus(request.getStatus() == null ? category.getStatus() : request.getStatus());
        category.setUpdateTime(LocalDateTime.now());
        categoryMapper.updateById(category);
        return category;
    }

    @Override
    public void delete(Long id) {
        Category category = categoryMapper.selectById(id);
        if (category == null || category.getDeleted() == 1) {
            throw BusinessException.notFound("分类不存在");
        }
        category.setDeleted(1);
        category.setUpdateTime(LocalDateTime.now());
        categoryMapper.updateById(category);
    }
}
