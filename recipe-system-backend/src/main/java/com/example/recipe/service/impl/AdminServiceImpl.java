package com.example.recipe.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.recipe.entity.Category;
import com.example.recipe.entity.Comment;
import com.example.recipe.entity.Recipe;
import com.example.recipe.entity.User;
import com.example.recipe.exception.BusinessException;
import com.example.recipe.mapper.CategoryMapper;
import com.example.recipe.mapper.CommentMapper;
import com.example.recipe.mapper.RecipeMapper;
import com.example.recipe.mapper.UserMapper;
import com.example.recipe.service.AdminService;
import com.example.recipe.service.RecipeService;
import com.example.recipe.vo.RecipeVO;
import com.example.recipe.vo.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {
    private final UserMapper userMapper;
    private final RecipeMapper recipeMapper;
    private final CategoryMapper categoryMapper;
    private final CommentMapper commentMapper;
    private final RecipeService recipeService;

    @Override
    public Map<String, Long> stat() {
        Map<String, Long> stat = new LinkedHashMap<>();
        stat.put("userCount", userMapper.selectCount(new LambdaQueryWrapper<User>().eq(User::getDeleted, 0)));
        stat.put("recipeCount", recipeMapper.selectCount(new LambdaQueryWrapper<Recipe>().eq(Recipe::getDeleted, 0)));
        stat.put("categoryCount", categoryMapper.selectCount(new LambdaQueryWrapper<Category>().eq(Category::getDeleted, 0)));
        stat.put("commentCount", commentMapper.selectCount(new LambdaQueryWrapper<Comment>().eq(Comment::getDeleted, 0)));
        return stat;
    }

    @Override
    public List<UserVO> users() {
        return userMapper.selectList(new LambdaQueryWrapper<User>()
                        .eq(User::getDeleted, 0)
                        .orderByDesc(User::getId))
                .stream()
                .map(UserVO::from)
                .toList();
    }

    @Override
    public void setUserStatus(Long id, Integer status) {
        User user = userMapper.selectById(id);
        if (user == null || user.getDeleted() == 1) {
            throw BusinessException.notFound("用户不存在");
        }
        user.setStatus(status);
        user.setUpdateTime(LocalDateTime.now());
        userMapper.updateById(user);
    }

    @Override
    public List<RecipeVO> recipes() {
        return recipeService.page(1, 1000, null, null, true).getRecords();
    }
}
