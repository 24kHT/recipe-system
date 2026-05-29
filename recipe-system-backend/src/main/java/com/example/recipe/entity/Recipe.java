package com.example.recipe.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("recipe")
public class Recipe {
    @TableId
    private Long id;
    private Long userId;
    private Long categoryId;
    private String title;
    private String coverImage;
    private String description;
    private String difficulty;
    private Integer cookingTime;
    private String tips;
    private Integer viewCount;
    private Integer favoriteCount;
    private Integer commentCount;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    private Integer deleted;
}
