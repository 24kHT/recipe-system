package com.example.recipe.controller;

import com.example.recipe.common.PageResult;
import com.example.recipe.common.Result;
import com.example.recipe.dto.RecipeRequest;
import com.example.recipe.service.RecipeService;
import com.example.recipe.vo.RecipeVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/recipe")
public class RecipeController {
    private final RecipeService recipeService;

    @PostMapping
    public Result<RecipeVO> create(@Valid @RequestBody RecipeRequest request) {
        return Result.ok("菜谱发布成功", recipeService.create(request));
    }

    @GetMapping("/list")
    public Result<PageResult<RecipeVO>> list(@RequestParam(defaultValue = "1") Integer page,
                                             @RequestParam(defaultValue = "9") Integer pageSize,
                                             @RequestParam(required = false) String keyword,
                                             @RequestParam(required = false) Long categoryId) {
        return Result.ok(recipeService.page(page, pageSize, keyword, categoryId, false));
    }

    @GetMapping("/{id}")
    public Result<RecipeVO> detail(@PathVariable Long id) {
        return Result.ok(recipeService.detail(id));
    }

    @PutMapping("/{id}")
    public Result<RecipeVO> update(@PathVariable Long id, @Valid @RequestBody RecipeRequest request) {
        return Result.ok("菜谱已更新", recipeService.update(id, request));
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        recipeService.delete(id);
        return Result.ok("菜谱已删除", null);
    }

    @GetMapping("/my")
    public Result<List<RecipeVO>> myRecipes() {
        return Result.ok(recipeService.myRecipes());
    }
}
