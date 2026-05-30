package com.example.recipe.vo;

import com.example.recipe.entity.Category;
import com.example.recipe.entity.Recipe;
import com.example.recipe.entity.RecipeIngredient;
import com.example.recipe.entity.RecipeStep;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
public class RecipeVO {
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
    private Integer likeCount;
    private Integer commentCount;
    private Integer status;
    private LocalDateTime createTime;
    private String categoryName;
    private String authorName;
    private Boolean favorited = false;
    private UserVO author;
    private Category category;
    private List<RecipeIngredient> ingredients = new ArrayList<>();
    private List<RecipeStep> steps = new ArrayList<>();
    private List<CommentVO> comments = new ArrayList<>();

    public static RecipeVO from(Recipe recipe) {
        RecipeVO vo = new RecipeVO();
        vo.setId(recipe.getId());
        vo.setUserId(recipe.getUserId());
        vo.setCategoryId(recipe.getCategoryId());
        vo.setTitle(recipe.getTitle());
        vo.setCoverImage(recipe.getCoverImage());
        vo.setDescription(recipe.getDescription());
        vo.setDifficulty(recipe.getDifficulty());
        vo.setCookingTime(recipe.getCookingTime());
        vo.setTips(recipe.getTips());
        vo.setViewCount(recipe.getViewCount());
        vo.setFavoriteCount(recipe.getFavoriteCount());
        vo.setLikeCount(recipe.getLikeCount());
        vo.setCommentCount(recipe.getCommentCount());
        vo.setStatus(recipe.getStatus());
        vo.setCreateTime(recipe.getCreateTime());
        return vo;
    }
}
