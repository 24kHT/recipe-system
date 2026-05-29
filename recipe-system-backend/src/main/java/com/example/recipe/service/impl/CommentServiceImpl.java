package com.example.recipe.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.recipe.context.LoginUser;
import com.example.recipe.context.UserContext;
import com.example.recipe.dto.CommentRequest;
import com.example.recipe.entity.Comment;
import com.example.recipe.entity.Recipe;
import com.example.recipe.exception.BusinessException;
import com.example.recipe.mapper.CommentMapper;
import com.example.recipe.mapper.RecipeMapper;
import com.example.recipe.mapper.UserMapper;
import com.example.recipe.service.CommentService;
import com.example.recipe.vo.CommentVO;
import com.example.recipe.vo.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CommentServiceImpl implements CommentService {
    private final CommentMapper commentMapper;
    private final RecipeMapper recipeMapper;
    private final UserMapper userMapper;

    @Override
    public CommentVO create(CommentRequest request) {
        LoginUser loginUser = requireLogin();
        Recipe recipe = recipeMapper.selectById(request.getRecipeId());
        if (recipe == null || recipe.getDeleted() == 1) {
            throw BusinessException.notFound("菜谱不存在");
        }
        LocalDateTime time = LocalDateTime.now();
        Comment comment = new Comment();
        comment.setUserId(loginUser.getId());
        comment.setRecipeId(request.getRecipeId());
        comment.setContent(request.getContent());
        comment.setStatus(1);
        comment.setDeleted(0);
        comment.setCreateTime(time);
        comment.setUpdateTime(time);
        commentMapper.insert(comment);
        refreshCount(recipe.getId());
        return CommentVO.from(comment, UserVO.from(userMapper.selectById(loginUser.getId())));
    }

    @Override
    public List<CommentVO> listByRecipe(Long recipeId) {
        return commentMapper.selectList(new LambdaQueryWrapper<Comment>()
                        .eq(Comment::getRecipeId, recipeId)
                        .eq(Comment::getStatus, 1)
                        .eq(Comment::getDeleted, 0)
                        .orderByDesc(Comment::getId))
                .stream()
                .map(comment -> CommentVO.from(comment, UserVO.from(userMapper.selectById(comment.getUserId()))))
                .toList();
    }

    @Override
    public void delete(Long id) {
        LoginUser loginUser = requireLogin();
        Comment comment = commentMapper.selectById(id);
        if (comment == null || comment.getDeleted() == 1) {
            throw BusinessException.notFound("评论不存在");
        }
        if (!loginUser.isAdmin() && !comment.getUserId().equals(loginUser.getId())) {
            throw BusinessException.forbidden("只能删除自己的评论");
        }
        comment.setDeleted(1);
        comment.setUpdateTime(LocalDateTime.now());
        commentMapper.updateById(comment);
        refreshCount(comment.getRecipeId());
    }

    private LoginUser requireLogin() {
        LoginUser user = UserContext.get();
        if (user == null) {
            throw BusinessException.unauthorized("未登录或 token 无效");
        }
        return user;
    }

    private void refreshCount(Long recipeId) {
        Recipe recipe = recipeMapper.selectById(recipeId);
        if (recipe != null) {
            long count = commentMapper.selectCount(new LambdaQueryWrapper<Comment>()
                    .eq(Comment::getRecipeId, recipeId)
                    .eq(Comment::getDeleted, 0)
                    .eq(Comment::getStatus, 1));
            recipe.setCommentCount((int) count);
            recipe.setUpdateTime(LocalDateTime.now());
            recipeMapper.updateById(recipe);
        }
    }
}
