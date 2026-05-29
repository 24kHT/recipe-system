package com.example.recipe.vo;

import com.example.recipe.entity.Comment;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CommentVO {
    private Long id;
    private Long recipeId;
    private String content;
    private Integer status;
    private LocalDateTime createTime;
    private UserVO user;

    public static CommentVO from(Comment comment, UserVO user) {
        CommentVO vo = new CommentVO();
        vo.setId(comment.getId());
        vo.setRecipeId(comment.getRecipeId());
        vo.setContent(comment.getContent());
        vo.setStatus(comment.getStatus());
        vo.setCreateTime(comment.getCreateTime());
        vo.setUser(user);
        return vo;
    }
}
