package com.example.recipe.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class RecipeRequest {
    @NotBlank(message = "菜谱名称不能为空")
    private String title;
    @NotNull(message = "分类不能为空")
    private Long categoryId;
    private String coverImage;
    private String description;
    private String difficulty;
    private Integer cookingTime;
    private String tips;
    private List<IngredientItem> ingredients = new ArrayList<>();
    private List<StepItem> steps = new ArrayList<>();

    @Data
    public static class IngredientItem {
        private String name;
        private String amount;
        private Integer sort;
    }

    @Data
    public static class StepItem {
        private Integer stepNo;
        private String content;
        private String image;
    }
}
