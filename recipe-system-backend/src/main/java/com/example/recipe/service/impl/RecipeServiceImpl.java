package com.example.recipe.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.recipe.common.PageResult;
import com.example.recipe.context.LoginUser;
import com.example.recipe.context.UserContext;
import com.example.recipe.dto.RecipeRequest;
import com.example.recipe.entity.*;
import com.example.recipe.exception.BusinessException;
import com.example.recipe.mapper.*;
import com.example.recipe.service.RecipeService;
import com.example.recipe.vo.CommentVO;
import com.example.recipe.vo.RecipeVO;
import com.example.recipe.vo.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RecipeServiceImpl implements RecipeService {
    private final RecipeMapper recipeMapper;
    private final RecipeIngredientMapper ingredientMapper;
    private final RecipeStepMapper stepMapper;
    private final UserMapper userMapper;
    private final CategoryMapper categoryMapper;
    private final FavoriteMapper favoriteMapper;
    private final CommentMapper commentMapper;

    @Override
    @Transactional
    public RecipeVO create(RecipeRequest request) {
        Long userId = requireLogin().getId();
        LocalDateTime time = LocalDateTime.now();
        Recipe recipe = new Recipe();
        recipe.setUserId(userId);
        fillRecipe(recipe, request);
        recipe.setViewCount(0);
        recipe.setFavoriteCount(0);
        recipe.setLikeCount(0);
        recipe.setCommentCount(0);
        recipe.setStatus(1);
        recipe.setDeleted(0);
        recipe.setCreateTime(time);
        recipe.setUpdateTime(time);
        recipeMapper.insert(recipe);
        replaceChildren(recipe.getId(), request);
        return detail(recipe.getId());
    }

    @Override
    public PageResult<RecipeVO> page(Integer page, Integer pageSize, String keyword, Long categoryId, Boolean includeDisabled) {
        int current = page == null || page < 1 ? 1 : page;
        int size = pageSize == null || pageSize < 1 ? 9 : Math.min(pageSize, 50);
        LambdaQueryWrapper<Recipe> wrapper = new LambdaQueryWrapper<Recipe>()
                .eq(Recipe::getDeleted, 0)
                .eq(Boolean.FALSE.equals(includeDisabled), Recipe::getStatus, 1)
                .eq(categoryId != null, Recipe::getCategoryId, categoryId)
                .orderByDesc(Recipe::getId);
        if (StringUtils.hasText(keyword)) {
            Set<Long> recipeIdsByIngredient = ingredientMapper.selectList(new LambdaQueryWrapper<RecipeIngredient>()
                            .eq(RecipeIngredient::getDeleted, 0)
                            .like(RecipeIngredient::getName, keyword))
                    .stream()
                    .map(RecipeIngredient::getRecipeId)
                    .collect(Collectors.toSet());
            wrapper.and(query -> query.like(Recipe::getTitle, keyword)
                    .or()
                    .like(Recipe::getDescription, keyword)
                    .or(!recipeIdsByIngredient.isEmpty())
                    .in(!recipeIdsByIngredient.isEmpty(), Recipe::getId, recipeIdsByIngredient));
        }
        Page<Recipe> result = recipeMapper.selectPage(Page.of(current, size), wrapper);
        List<RecipeVO> records = result.getRecords().stream().map(this::toSummary).toList();
        return new PageResult<>(records, result.getTotal(), current, size);
    }

    @Override
    public RecipeVO detail(Long id) {
        Recipe recipe = recipeMapper.selectById(id);
        if (recipe == null || recipe.getDeleted() == 1) {
            throw BusinessException.notFound("菜谱不存在");
        }
        recipe.setViewCount((recipe.getViewCount() == null ? 0 : recipe.getViewCount()) + 1);
        recipeMapper.updateById(recipe);
        RecipeVO vo = toSummary(recipe);
        vo.setAuthor(UserVO.from(userMapper.selectById(recipe.getUserId())));
        vo.setCategory(categoryMapper.selectById(recipe.getCategoryId()));
        vo.setIngredients(ingredientMapper.selectList(new LambdaQueryWrapper<RecipeIngredient>()
                .eq(RecipeIngredient::getRecipeId, id)
                .eq(RecipeIngredient::getDeleted, 0)
                .orderByAsc(RecipeIngredient::getSort)));
        vo.setSteps(stepMapper.selectList(new LambdaQueryWrapper<RecipeStep>()
                .eq(RecipeStep::getRecipeId, id)
                .eq(RecipeStep::getDeleted, 0)
                .orderByAsc(RecipeStep::getStepNo)));
        vo.setComments(commentMapper.selectList(new LambdaQueryWrapper<Comment>()
                        .eq(Comment::getRecipeId, id)
                        .eq(Comment::getDeleted, 0)
                        .eq(Comment::getStatus, 1)
                        .orderByDesc(Comment::getId))
                .stream()
                .map(comment -> CommentVO.from(comment, UserVO.from(userMapper.selectById(comment.getUserId()))))
                .toList());
        return vo;
    }

    @Override
    @Transactional
    public RecipeVO update(Long id, RecipeRequest request) {
        Recipe recipe = requireRecipeForWrite(id);
        fillRecipe(recipe, request);
        recipe.setUpdateTime(LocalDateTime.now());
        recipeMapper.updateById(recipe);
        replaceChildren(id, request);
        return detail(id);
    }

    @Override
    public void delete(Long id) {
        Recipe recipe = requireRecipeForWrite(id);
        recipe.setDeleted(1);
        recipe.setUpdateTime(LocalDateTime.now());
        recipeMapper.updateById(recipe);
    }

    @Override
    public List<RecipeVO> myRecipes() {
        Long userId = requireLogin().getId();
        return recipeMapper.selectList(new LambdaQueryWrapper<Recipe>()
                        .eq(Recipe::getUserId, userId)
                        .eq(Recipe::getDeleted, 0)
                        .orderByDesc(Recipe::getId))
                .stream()
                .map(this::toSummary)
                .toList();
    }

    @Override
    public void toggleStatus(Long id) {
        LoginUser loginUser = requireLogin();
        if (!loginUser.isAdmin()) {
            throw BusinessException.forbidden("没有管理员权限");
        }
        Recipe recipe = recipeMapper.selectById(id);
        if (recipe == null || recipe.getDeleted() == 1) {
            throw BusinessException.notFound("菜谱不存在");
        }
        recipe.setStatus(recipe.getStatus() != null && recipe.getStatus() == 1 ? 0 : 1);
        recipe.setUpdateTime(LocalDateTime.now());
        recipeMapper.updateById(recipe);
    }

    private void fillRecipe(Recipe recipe, RecipeRequest request) {
        recipe.setCategoryId(request.getCategoryId());
        recipe.setTitle(request.getTitle());
        recipe.setCoverImage(request.getCoverImage());
        recipe.setDescription(request.getDescription());
        recipe.setDifficulty(StringUtils.hasText(request.getDifficulty()) ? request.getDifficulty() : "简单");
        recipe.setCookingTime(request.getCookingTime());
        recipe.setTips(request.getTips());
    }

    private void replaceChildren(Long recipeId, RecipeRequest request) {
        ingredientMapper.selectList(new LambdaQueryWrapper<RecipeIngredient>().eq(RecipeIngredient::getRecipeId, recipeId))
                .forEach(item -> {
                    item.setDeleted(1);
                    item.setUpdateTime(LocalDateTime.now());
                    ingredientMapper.updateById(item);
                });
        stepMapper.selectList(new LambdaQueryWrapper<RecipeStep>().eq(RecipeStep::getRecipeId, recipeId))
                .forEach(item -> {
                    item.setDeleted(1);
                    item.setUpdateTime(LocalDateTime.now());
                    stepMapper.updateById(item);
                });
        LocalDateTime time = LocalDateTime.now();
        int sort = 1;
        for (RecipeRequest.IngredientItem item : request.getIngredients()) {
            if (!StringUtils.hasText(item.getName())) {
                continue;
            }
            RecipeIngredient ingredient = new RecipeIngredient();
            ingredient.setRecipeId(recipeId);
            ingredient.setName(item.getName());
            ingredient.setAmount(item.getAmount());
            ingredient.setSort(item.getSort() == null ? sort : item.getSort());
            ingredient.setDeleted(0);
            ingredient.setCreateTime(time);
            ingredient.setUpdateTime(time);
            ingredientMapper.insert(ingredient);
            sort++;
        }
        int stepNo = 1;
        for (RecipeRequest.StepItem item : request.getSteps()) {
            if (!StringUtils.hasText(item.getContent())) {
                continue;
            }
            RecipeStep step = new RecipeStep();
            step.setRecipeId(recipeId);
            step.setStepNo(item.getStepNo() == null ? stepNo : item.getStepNo());
            step.setContent(item.getContent());
            step.setImage(item.getImage());
            step.setDeleted(0);
            step.setCreateTime(time);
            step.setUpdateTime(time);
            stepMapper.insert(step);
            stepNo++;
        }
    }

    private Recipe requireRecipeForWrite(Long id) {
        LoginUser loginUser = requireLogin();
        Recipe recipe = recipeMapper.selectById(id);
        if (recipe == null || recipe.getDeleted() == 1) {
            throw BusinessException.notFound("菜谱不存在");
        }
        if (!loginUser.isAdmin() && !recipe.getUserId().equals(loginUser.getId())) {
            throw BusinessException.forbidden("只能管理自己发布的菜谱");
        }
        return recipe;
    }

    private LoginUser requireLogin() {
        LoginUser user = UserContext.get();
        if (user == null) {
            throw BusinessException.unauthorized("未登录或 token 无效");
        }
        return user;
    }

    private RecipeVO toSummary(Recipe recipe) {
        RecipeVO vo = RecipeVO.from(recipe);
        User author = userMapper.selectById(recipe.getUserId());
        Category category = categoryMapper.selectById(recipe.getCategoryId());
        vo.setIngredients(ingredientMapper.selectList(new LambdaQueryWrapper<RecipeIngredient>()
                .eq(RecipeIngredient::getRecipeId, recipe.getId())
                .eq(RecipeIngredient::getDeleted, 0)
                .orderByAsc(RecipeIngredient::getSort)));
        vo.setAuthorName(author == null ? "未知用户" : author.getNickname());
        vo.setCategoryName(category == null ? "未分类" : category.getName());
        Long userId = UserContext.userId();
        if (userId != null) {
            Long count = favoriteMapper.selectCount(new LambdaQueryWrapper<Favorite>()
                    .eq(Favorite::getUserId, userId)
                    .eq(Favorite::getRecipeId, recipe.getId())
                    .eq(Favorite::getDeleted, 0));
            vo.setFavorited(count > 0);
        }
        return vo;
    }
}
