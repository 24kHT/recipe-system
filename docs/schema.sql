CREATE DATABASE IF NOT EXISTS recipe_system
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE recipe_system;

CREATE TABLE IF NOT EXISTS `user` (
  `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `password` VARCHAR(255) NOT NULL COMMENT '加密密码',
  `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
  `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像地址',
  `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
  `bio` VARCHAR(500) DEFAULT NULL COMMENT '个人简介',
  `role` VARCHAR(20) NOT NULL DEFAULT 'USER' COMMENT '角色：USER/ADMIN',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1正常，0禁用',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  UNIQUE KEY `uk_user_username` (`username`),
  KEY `idx_user_role` (`role`),
  KEY `idx_user_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

CREATE TABLE IF NOT EXISTS `category` (
  `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  `name` VARCHAR(50) NOT NULL COMMENT '分类名称',
  `icon` VARCHAR(255) DEFAULT NULL COMMENT '分类图标',
  `sort` INT NOT NULL DEFAULT 0 COMMENT '排序值',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用，0停用',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  UNIQUE KEY `uk_category_name` (`name`),
  KEY `idx_category_status` (`status`),
  KEY `idx_category_sort` (`sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜谱分类表';

CREATE TABLE IF NOT EXISTS `recipe` (
  `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  `user_id` BIGINT NOT NULL COMMENT '作者用户ID',
  `category_id` BIGINT NOT NULL COMMENT '分类ID',
  `title` VARCHAR(100) NOT NULL COMMENT '菜谱名称',
  `cover_image` VARCHAR(255) DEFAULT NULL COMMENT '封面图地址',
  `description` VARCHAR(500) DEFAULT NULL COMMENT '菜谱简介',
  `difficulty` VARCHAR(20) DEFAULT NULL COMMENT '难度：简单/中等/困难',
  `cooking_time` INT DEFAULT NULL COMMENT '烹饪时间，单位分钟',
  `tips` TEXT DEFAULT NULL COMMENT '小贴士',
  `view_count` INT NOT NULL DEFAULT 0 COMMENT '浏览量',
  `favorite_count` INT NOT NULL DEFAULT 0 COMMENT '收藏数',
  `like_count` INT NOT NULL DEFAULT 0 COMMENT '点赞数',
  `comment_count` INT NOT NULL DEFAULT 0 COMMENT '评论数',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1正常，0下架',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  KEY `idx_recipe_user_id` (`user_id`),
  KEY `idx_recipe_category_id` (`category_id`),
  KEY `idx_recipe_title` (`title`),
  KEY `idx_recipe_status` (`status`),
  KEY `idx_recipe_create_time` (`create_time`),
  CONSTRAINT `fk_recipe_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_recipe_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜谱表';

CREATE TABLE IF NOT EXISTS `recipe_ingredient` (
  `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  `recipe_id` BIGINT NOT NULL COMMENT '菜谱ID',
  `name` VARCHAR(100) NOT NULL COMMENT '食材名称',
  `amount` VARCHAR(100) DEFAULT NULL COMMENT '用量',
  `sort` INT NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  KEY `idx_ingredient_recipe_id` (`recipe_id`),
  KEY `idx_ingredient_name` (`name`),
  CONSTRAINT `fk_ingredient_recipe` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜谱食材表';

CREATE TABLE IF NOT EXISTS `recipe_step` (
  `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  `recipe_id` BIGINT NOT NULL COMMENT '菜谱ID',
  `step_no` INT NOT NULL COMMENT '步骤序号',
  `content` TEXT NOT NULL COMMENT '步骤说明',
  `image` VARCHAR(255) DEFAULT NULL COMMENT '步骤图片地址',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  KEY `idx_step_recipe_id` (`recipe_id`),
  KEY `idx_step_no` (`step_no`),
  CONSTRAINT `fk_step_recipe` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜谱步骤表';

CREATE TABLE IF NOT EXISTS `favorite` (
  `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `recipe_id` BIGINT NOT NULL COMMENT '菜谱ID',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  `deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  UNIQUE KEY `uk_favorite_user_recipe` (`user_id`, `recipe_id`),
  KEY `idx_favorite_user_id` (`user_id`),
  KEY `idx_favorite_recipe_id` (`recipe_id`),
  CONSTRAINT `fk_favorite_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_favorite_recipe` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收藏表';

CREATE TABLE IF NOT EXISTS `comment` (
  `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  `user_id` BIGINT NOT NULL COMMENT '评论用户ID',
  `recipe_id` BIGINT NOT NULL COMMENT '菜谱ID',
  `content` TEXT NOT NULL COMMENT '评论内容',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1正常，0隐藏',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  KEY `idx_comment_user_id` (`user_id`),
  KEY `idx_comment_recipe_id` (`recipe_id`),
  KEY `idx_comment_status` (`status`),
  KEY `idx_comment_create_time` (`create_time`),
  CONSTRAINT `fk_comment_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_comment_recipe` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';

INSERT INTO `category` (`name`, `icon`, `sort`, `status`) VALUES
('家常菜', 'home-food', 1, 1),
('早餐', 'breakfast', 2, 1),
('午餐', 'lunch', 3, 1),
('晚餐', 'dinner', 4, 1),
('甜品', 'dessert', 5, 1),
('汤类', 'soup', 6, 1),
('川菜', 'sichuan', 7, 1),
('粤菜', 'cantonese', 8, 1),
('减脂餐', 'fitness', 9, 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);
