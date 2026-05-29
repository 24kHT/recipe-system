package com.example.recipe.controller;

import com.example.recipe.common.Result;
import com.example.recipe.dto.CategoryRequest;
import com.example.recipe.entity.Category;
import com.example.recipe.service.AdminService;
import com.example.recipe.service.CategoryService;
import com.example.recipe.service.CommentService;
import com.example.recipe.service.RecipeService;
import com.example.recipe.vo.RecipeVO;
import com.example.recipe.vo.UserVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/admin")
public class AdminController {
    private final AdminService adminService;
    private final RecipeService recipeService;
    private final CategoryService categoryService;
    private final CommentService commentService;

    @GetMapping("/stat")
    public Result<Map<String, Long>> stat() {
        return Result.ok(adminService.stat());
    }

    @GetMapping("/user/list")
    public Result<List<UserVO>> users() {
        return Result.ok(adminService.users());
    }

    @PutMapping("/user/{id}/disable")
    public Result<Void> disableUser(@PathVariable Long id) {
        adminService.setUserStatus(id, 0);
        return Result.ok("用户已禁用", null);
    }

    @PutMapping("/user/{id}/enable")
    public Result<Void> enableUser(@PathVariable Long id) {
        adminService.setUserStatus(id, 1);
        return Result.ok("用户已启用", null);
    }

    @GetMapping("/recipe/list")
    public Result<List<RecipeVO>> recipes() {
        return Result.ok(adminService.recipes());
    }

    @PutMapping("/recipe/{id}/disable")
    public Result<Void> toggleRecipe(@PathVariable Long id) {
        recipeService.toggleStatus(id);
        return Result.ok("菜谱状态已更新", null);
    }

    @PostMapping("/category")
    public Result<Category> createCategory(@Valid @RequestBody CategoryRequest request) {
        return Result.ok("分类已创建", categoryService.create(request));
    }

    @PutMapping("/category/{id}")
    public Result<Category> updateCategory(@PathVariable Long id, @Valid @RequestBody CategoryRequest request) {
        return Result.ok("分类已更新", categoryService.update(id, request));
    }

    @DeleteMapping("/category/{id}")
    public Result<Void> deleteCategory(@PathVariable Long id) {
        categoryService.delete(id);
        return Result.ok("分类已删除", null);
    }

    @DeleteMapping("/comment/{id}")
    public Result<Void> deleteComment(@PathVariable Long id) {
        commentService.delete(id);
        return Result.ok("评论已删除", null);
    }
}
