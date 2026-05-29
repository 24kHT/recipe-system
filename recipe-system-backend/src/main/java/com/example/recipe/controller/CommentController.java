package com.example.recipe.controller;

import com.example.recipe.common.Result;
import com.example.recipe.dto.CommentRequest;
import com.example.recipe.service.CommentService;
import com.example.recipe.vo.CommentVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/comment")
public class CommentController {
    private final CommentService commentService;

    @PostMapping
    public Result<CommentVO> create(@Valid @RequestBody CommentRequest request) {
        return Result.ok("评论成功", commentService.create(request));
    }

    @GetMapping("/recipe/{recipeId}")
    public Result<List<CommentVO>> listByRecipe(@PathVariable Long recipeId) {
        return Result.ok(commentService.listByRecipe(recipeId));
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        commentService.delete(id);
        return Result.ok("评论已删除", null);
    }
}
