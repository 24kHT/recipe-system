package com.example.recipe.config;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.recipe.entity.Category;
import com.example.recipe.entity.User;
import com.example.recipe.mapper.CategoryMapper;
import com.example.recipe.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {
    private final UserMapper userMapper;
    private final CategoryMapper categoryMapper;
    private final JdbcTemplate jdbcTemplate;
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    @Override
    public void run(String... args) {
        ensureRecipeLikeCountColumn();

        if (userMapper.selectCount(new LambdaQueryWrapper<User>().eq(User::getUsername, "admin")) == 0) {
            LocalDateTime now = LocalDateTime.now();
            User admin = new User();
            admin.setUsername("admin");
            admin.setPassword(encoder.encode("admin123"));
            admin.setNickname("系统管理员");
            admin.setRole("ADMIN");
            admin.setStatus(1);
            admin.setDeleted(0);
            admin.setCreateTime(now);
            admin.setUpdateTime(now);
            userMapper.insert(admin);
        }
        if (categoryMapper.selectCount(new LambdaQueryWrapper<Category>().eq(Category::getDeleted, 0)) == 0) {
            List<String> names = List.of("家常菜", "早餐", "午餐", "晚餐", "甜品", "汤类", "川菜", "粤菜", "减脂餐");
            for (int i = 0; i < names.size(); i++) {
                LocalDateTime now = LocalDateTime.now();
                Category category = new Category();
                category.setName(names.get(i));
                category.setIcon("category-" + (i + 1));
                category.setSort(i + 1);
                category.setStatus(1);
                category.setDeleted(0);
                category.setCreateTime(now);
                category.setUpdateTime(now);
                categoryMapper.insert(category);
            }
        }
    }

    private void ensureRecipeLikeCountColumn() {
        Integer count = jdbcTemplate.queryForObject("""
                SELECT COUNT(*)
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_SCHEMA = DATABASE()
                  AND TABLE_NAME = 'recipe'
                  AND COLUMN_NAME = 'like_count'
                """, Integer.class);
        if (count != null && count == 0) {
            jdbcTemplate.execute("ALTER TABLE `recipe` ADD COLUMN `like_count` INT NOT NULL DEFAULT 0 COMMENT '点赞数' AFTER `favorite_count`");
        }
    }
}
