package com.example.recipe.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CommentRequest {
    @NotNull(message = "菜谱ID不能为空")
    private Long recipeId;
    @NotBlank(message = "评论内容不能为空")
    private String content;
}
