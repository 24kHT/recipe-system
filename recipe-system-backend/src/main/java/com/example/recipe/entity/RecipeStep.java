package com.example.recipe.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("recipe_step")
public class RecipeStep {
    @TableId
    private Long id;
    private Long recipeId;
    private Integer stepNo;
    private String content;
    private String image;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    private Integer deleted;
}
