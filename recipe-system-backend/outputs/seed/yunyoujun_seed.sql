-- Seed data generated from YunYouJun/cook recipe.csv (MIT License).

-- Run this SQL against the recipe_system database.

SET NAMES utf8mb4;

SET @like_col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'recipe' AND COLUMN_NAME = 'like_count'
);
SET @like_col_sql := IF(@like_col_exists = 0,
  'ALTER TABLE `recipe` ADD COLUMN `like_count` INT NOT NULL DEFAULT 0 COMMENT ''点赞数'' AFTER `favorite_count`',
  'SELECT 1'
);
PREPARE like_col_stmt FROM @like_col_sql;
EXECUTE like_col_stmt;
DEALLOCATE PREPARE like_col_stmt;

INSERT INTO `user` (`username`, `password`, `nickname`, `avatar`, `email`, `phone`, `bio`, `role`, `status`, `create_time`, `update_time`, `deleted`) SELECT 'seed_author_1', 'seed-author-no-login', '食光小厨', '', 'seed_author_1@example.com', '', 'YunYouJun/cook 演示数据作者', 'USER', 1, '2026-05-30 16:43:42', '2026-05-30 16:43:42', 0 WHERE NOT EXISTS (SELECT 1 FROM `user` WHERE `username` = 'seed_author_1');
INSERT INTO `user` (`username`, `password`, `nickname`, `avatar`, `email`, `phone`, `bio`, `role`, `status`, `create_time`, `update_time`, `deleted`) SELECT 'seed_author_2', 'seed-author-no-login', '家常料理人', '', 'seed_author_2@example.com', '', 'YunYouJun/cook 演示数据作者', 'USER', 1, '2026-05-30 16:43:42', '2026-05-30 16:43:42', 0 WHERE NOT EXISTS (SELECT 1 FROM `user` WHERE `username` = 'seed_author_2');
INSERT INTO `user` (`username`, `password`, `nickname`, `avatar`, `email`, `phone`, `bio`, `role`, `status`, `create_time`, `update_time`, `deleted`) SELECT 'seed_author_3', 'seed-author-no-login', '晚风厨房', '', 'seed_author_3@example.com', '', 'YunYouJun/cook 演示数据作者', 'USER', 1, '2026-05-30 16:43:42', '2026-05-30 16:43:42', 0 WHERE NOT EXISTS (SELECT 1 FROM `user` WHERE `username` = 'seed_author_3');
INSERT INTO `user` (`username`, `password`, `nickname`, `avatar`, `email`, `phone`, `bio`, `role`, `status`, `create_time`, `update_time`, `deleted`) SELECT 'seed_author_4', 'seed-author-no-login', '元气早餐铺', '', 'seed_author_4@example.com', '', 'YunYouJun/cook 演示数据作者', 'USER', 1, '2026-05-30 16:43:42', '2026-05-30 16:43:42', 0 WHERE NOT EXISTS (SELECT 1 FROM `user` WHERE `username` = 'seed_author_4');
INSERT INTO `user` (`username`, `password`, `nickname`, `avatar`, `email`, `phone`, `bio`, `role`, `status`, `create_time`, `update_time`, `deleted`) SELECT 'seed_author_5', 'seed-author-no-login', '轻食研究员', '', 'seed_author_5@example.com', '', 'YunYouJun/cook 演示数据作者', 'USER', 1, '2026-05-30 16:43:42', '2026-05-30 16:43:42', 0 WHERE NOT EXISTS (SELECT 1 FROM `user` WHERE `username` = 'seed_author_5');

INSERT INTO `category` (`name`, `icon`, `sort`, `status`, `create_time`, `update_time`, `deleted`) SELECT '家常菜', 'seed-1', 1, 1, '2026-05-30 16:43:42', '2026-05-30 16:43:42', 0 WHERE NOT EXISTS (SELECT 1 FROM `category` WHERE `name` = '家常菜' AND `deleted` = 0);
INSERT INTO `category` (`name`, `icon`, `sort`, `status`, `create_time`, `update_time`, `deleted`) SELECT '早餐', 'seed-2', 2, 1, '2026-05-30 16:43:42', '2026-05-30 16:43:42', 0 WHERE NOT EXISTS (SELECT 1 FROM `category` WHERE `name` = '早餐' AND `deleted` = 0);
INSERT INTO `category` (`name`, `icon`, `sort`, `status`, `create_time`, `update_time`, `deleted`) SELECT '午餐', 'seed-3', 3, 1, '2026-05-30 16:43:42', '2026-05-30 16:43:42', 0 WHERE NOT EXISTS (SELECT 1 FROM `category` WHERE `name` = '午餐' AND `deleted` = 0);
INSERT INTO `category` (`name`, `icon`, `sort`, `status`, `create_time`, `update_time`, `deleted`) SELECT '晚餐', 'seed-4', 4, 1, '2026-05-30 16:43:42', '2026-05-30 16:43:42', 0 WHERE NOT EXISTS (SELECT 1 FROM `category` WHERE `name` = '晚餐' AND `deleted` = 0);
INSERT INTO `category` (`name`, `icon`, `sort`, `status`, `create_time`, `update_time`, `deleted`) SELECT '甜品', 'seed-5', 5, 1, '2026-05-30 16:43:42', '2026-05-30 16:43:42', 0 WHERE NOT EXISTS (SELECT 1 FROM `category` WHERE `name` = '甜品' AND `deleted` = 0);
INSERT INTO `category` (`name`, `icon`, `sort`, `status`, `create_time`, `update_time`, `deleted`) SELECT '汤类', 'seed-6', 6, 1, '2026-05-30 16:43:42', '2026-05-30 16:43:42', 0 WHERE NOT EXISTS (SELECT 1 FROM `category` WHERE `name` = '汤类' AND `deleted` = 0);
INSERT INTO `category` (`name`, `icon`, `sort`, `status`, `create_time`, `update_time`, `deleted`) SELECT '减脂餐', 'seed-7', 7, 1, '2026-05-30 16:43:42', '2026-05-30 16:43:42', 0 WHERE NOT EXISTS (SELECT 1 FROM `category` WHERE `name` = '减脂餐' AND `deleted` = 0);
INSERT INTO `category` (`name`, `icon`, `sort`, `status`, `create_time`, `update_time`, `deleted`) SELECT '川菜', 'seed-8', 8, 1, '2026-05-30 16:43:42', '2026-05-30 16:43:42', 0 WHERE NOT EXISTS (SELECT 1 FROM `category` WHERE `name` = '川菜' AND `deleted` = 0);

CREATE TEMPORARY TABLE IF NOT EXISTS `_seed_recipe_ids` (`id` BIGINT PRIMARY KEY);
INSERT INTO `_seed_recipe_ids` (`id`)
SELECT `id` FROM `recipe` WHERE `tips` LIKE '%source:YunYouJun/cook seed:v1%';
DELETE FROM `recipe_ingredient` WHERE `recipe_id` IN (SELECT `id` FROM `_seed_recipe_ids`);
DELETE FROM `recipe_step` WHERE `recipe_id` IN (SELECT `id` FROM `_seed_recipe_ids`);
DELETE FROM `favorite` WHERE `recipe_id` IN (SELECT `id` FROM `_seed_recipe_ids`);
DELETE FROM `comment` WHERE `recipe_id` IN (SELECT `id` FROM `_seed_recipe_ids`);
DELETE FROM `recipe` WHERE `id` IN (SELECT `id` FROM `_seed_recipe_ids`);
DROP TEMPORARY TABLE `_seed_recipe_ids`;

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅蒜蓉茄子', '/seed-images/yunyoujun-001.svg', '空气炸锅蒜蓉茄子是一道适合家常菜场景的演示菜谱，食材以茄子为主。 口味标签：深夜美食。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1aQ4y1D77r', 14218, 2518, 5638, 0, 1, '2026-05-29 16:43:41', '2026-05-29 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '家常菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '茄子', '1份', 1, '2026-05-29 16:43:41', '2026-05-29 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好茄子，清洗后按需要切块、切片或分装备用。', '', '2026-05-29 16:43:41', '2026-05-29 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-29 16:43:41', '2026-05-29 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅炸至食材成熟入味。', '', '2026-05-29 16:43:41', '2026-05-29 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-29 16:43:41', '2026-05-29 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅版M记同款薯条', '/seed-images/yunyoujun-002.svg', '空气炸锅版M记同款薯条是一道适合家常菜场景的演示菜谱，食材以土豆为主。 口味标签：同款。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1tq4y1j72x', 17797, 1305, 3280, 0, 1, '2026-05-28 16:43:41', '2026-05-28 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '家常菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '土豆', '1个', 1, '2026-05-28 16:43:41', '2026-05-28 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好土豆，清洗后按需要切块、切片或分装备用。', '', '2026-05-28 16:43:41', '2026-05-28 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-28 16:43:41', '2026-05-28 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅至食材成熟入味。', '', '2026-05-28 16:43:41', '2026-05-28 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-28 16:43:41', '2026-05-28 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅版M记同款薯饼', '/seed-images/yunyoujun-003.svg', '空气炸锅版M记同款薯饼是一道适合家常菜场景的演示菜谱，食材以土豆为主。 口味标签：同款。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1Cb4y167zK', 30869, 2466, 2964, 0, 1, '2026-05-27 16:43:41', '2026-05-27 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '家常菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '土豆', '1个', 1, '2026-05-27 16:43:41', '2026-05-27 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好土豆，清洗后按需要切块、切片或分装备用。', '', '2026-05-27 16:43:41', '2026-05-27 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-27 16:43:41', '2026-05-27 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅至食材成熟入味。', '', '2026-05-27 16:43:41', '2026-05-27 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-27 16:43:41', '2026-05-27 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅炸包菜', '/seed-images/yunyoujun-004.svg', '空气炸锅炸包菜是一道适合家常菜场景的演示菜谱，食材以包菜为主。 口味标签：童年风味。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1eR4y1j715', 26979, 372, 1039, 0, 1, '2026-05-26 16:43:41', '2026-05-26 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '家常菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '包菜', '1份', 1, '2026-05-26 16:43:41', '2026-05-26 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好包菜，清洗后按需要切块、切片或分装备用。', '', '2026-05-26 16:43:41', '2026-05-26 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-26 16:43:41', '2026-05-26 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅炸至食材成熟入味。', '', '2026-05-26 16:43:41', '2026-05-26 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-26 16:43:41', '2026-05-26 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅版可乐鸡翅', '/seed-images/yunyoujun-005.svg', '空气炸锅版可乐鸡翅是一道适合家常菜场景的演示菜谱，食材以鸡肉为主。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1eT4y1S7Jn', 9411, 620, 747, 0, 1, '2026-05-25 16:43:41', '2026-05-25 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '家常菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-05-25 16:43:41', '2026-05-25 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉，清洗后按需要切块、切片或分装备用。', '', '2026-05-25 16:43:41', '2026-05-25 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-25 16:43:41', '2026-05-25 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅至食材成熟入味。', '', '2026-05-25 16:43:41', '2026-05-25 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-25 16:43:41', '2026-05-25 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅炸包菜串', '/seed-images/yunyoujun-006.svg', '空气炸锅炸包菜串是一道适合家常菜场景的演示菜谱，食材以包菜为主。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1DL4y137CD', 3622, 983, 3419, 0, 1, '2026-05-24 16:43:41', '2026-05-24 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '家常菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '包菜', '1份', 1, '2026-05-24 16:43:41', '2026-05-24 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好包菜，清洗后按需要切块、切片或分装备用。', '', '2026-05-24 16:43:41', '2026-05-24 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-24 16:43:41', '2026-05-24 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅炸至食材成熟入味。', '', '2026-05-24 16:43:41', '2026-05-24 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-24 16:43:41', '2026-05-24 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅炸香肠串', '/seed-images/yunyoujun-007.svg', '空气炸锅炸香肠串是一道适合家常菜场景的演示菜谱，食材以香肠为主。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1DL4y137CD', 3240, 1165, 1926, 0, 1, '2026-05-23 16:43:41', '2026-05-23 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '家常菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '香肠', '1份', 1, '2026-05-23 16:43:41', '2026-05-23 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好香肠，清洗后按需要切块、切片或分装备用。', '', '2026-05-23 16:43:41', '2026-05-23 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-23 16:43:41', '2026-05-23 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅炸至食材成熟入味。', '', '2026-05-23 16:43:41', '2026-05-23 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-23 16:43:41', '2026-05-23 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅奥尔良炸鸡腿', '/seed-images/yunyoujun-008.svg', '空气炸锅奥尔良炸鸡腿是一道适合家常菜场景的演示菜谱，食材以鸡肉为主。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1JU4y1G7hq', 18987, 469, 2519, 0, 1, '2026-05-22 16:43:41', '2026-05-22 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '家常菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-05-22 16:43:41', '2026-05-22 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉，清洗后按需要切块、切片或分装备用。', '', '2026-05-22 16:43:41', '2026-05-22 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-22 16:43:41', '2026-05-22 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅炸至食材成熟入味。', '', '2026-05-22 16:43:41', '2026-05-22 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-22 16:43:41', '2026-05-22 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅炒面', '/seed-images/yunyoujun-009.svg', '空气炸锅炒面是一道适合家常菜场景的演示菜谱，食材以方便面为主。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV11P4y1u7R1', 26644, 502, 2375, 0, 1, '2026-05-21 16:43:41', '2026-05-21 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '家常菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '方便面', '1份', 1, '2026-05-21 16:43:41', '2026-05-21 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好方便面，清洗后按需要切块、切片或分装备用。', '', '2026-05-21 16:43:41', '2026-05-21 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-21 16:43:41', '2026-05-21 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅炸至食材成熟入味。', '', '2026-05-21 16:43:41', '2026-05-21 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-21 16:43:41', '2026-05-21 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅炒牛河', '/seed-images/yunyoujun-010.svg', '空气炸锅炒牛河是一道适合家常菜场景的演示菜谱，食材以面食、牛肉为主。', '简单', 28, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1k44y1P7VY', 8957, 238, 4324, 0, 1, '2026-05-20 16:43:41', '2026-05-20 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '家常菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '面食', '1份', 1, '2026-05-20 16:43:41', '2026-05-20 16:43:41', 0),
  (@recipe_id, '牛肉', '250g', 2, '2026-05-20 16:43:41', '2026-05-20 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好面食、牛肉，清洗后按需要切块、切片或分装备用。', '', '2026-05-20 16:43:41', '2026-05-20 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-20 16:43:41', '2026-05-20 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅炸至食材成熟入味。', '', '2026-05-20 16:43:41', '2026-05-20 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-20 16:43:41', '2026-05-20 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅蛋黄酥', '/seed-images/yunyoujun-011.svg', '空气炸锅蛋黄酥是一道适合家常菜场景的演示菜谱，食材以虾、土豆为主。', '简单', 28, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1yS4y1u7M6', 22087, 2489, 5568, 0, 1, '2026-05-19 16:43:41', '2026-05-19 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '家常菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '虾', '1份', 1, '2026-05-19 16:43:41', '2026-05-19 16:43:41', 0),
  (@recipe_id, '土豆', '1个', 2, '2026-05-19 16:43:41', '2026-05-19 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好虾、土豆，清洗后按需要切块、切片或分装备用。', '', '2026-05-19 16:43:41', '2026-05-19 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-19 16:43:41', '2026-05-19 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅炸至食材成熟入味。', '', '2026-05-19 16:43:41', '2026-05-19 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-19 16:43:41', '2026-05-19 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅地三鲜', '/seed-images/yunyoujun-012.svg', '空气炸锅地三鲜是一道适合家常菜场景的演示菜谱，食材以土豆、茄子为主。', '简单', 28, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1pf4y1T7bx', 23604, 2779, 4611, 0, 1, '2026-05-18 16:43:41', '2026-05-18 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '家常菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '土豆', '1个', 1, '2026-05-18 16:43:41', '2026-05-18 16:43:41', 0),
  (@recipe_id, '茄子', '1份', 2, '2026-05-18 16:43:41', '2026-05-18 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好土豆、茄子，清洗后按需要切块、切片或分装备用。', '', '2026-05-18 16:43:41', '2026-05-18 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-18 16:43:41', '2026-05-18 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅炸至食材成熟入味。', '', '2026-05-18 16:43:41', '2026-05-18 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-18 16:43:41', '2026-05-18 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅虾球', '/seed-images/yunyoujun-013.svg', '空气炸锅虾球是一道适合家常菜场景的演示菜谱，食材以土豆、虾为主。', '简单', 28, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1L3411573m', 25012, 1474, 2137, 0, 1, '2026-05-17 16:43:41', '2026-05-17 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '家常菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '土豆', '1个', 1, '2026-05-17 16:43:41', '2026-05-17 16:43:41', 0),
  (@recipe_id, '虾', '1份', 2, '2026-05-17 16:43:41', '2026-05-17 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好土豆、虾，清洗后按需要切块、切片或分装备用。', '', '2026-05-17 16:43:41', '2026-05-17 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-17 16:43:41', '2026-05-17 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅炸至食材成熟入味。', '', '2026-05-17 16:43:41', '2026-05-17 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-17 16:43:41', '2026-05-17 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空心小薯片', '/seed-images/yunyoujun-014.svg', '空心小薯片是一道适合早餐场景的演示菜谱，食材以土豆、鸡蛋为主。 口味标签：零食。', '简单', 20, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1N5411D79P', 18847, 827, 240, 0, 1, '2026-05-16 16:43:41', '2026-05-16 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '早餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '土豆', '1个', 1, '2026-05-16 16:43:41', '2026-05-16 16:43:41', 0),
  (@recipe_id, '鸡蛋', '2个', 2, '2026-05-16 16:43:41', '2026-05-16 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好土豆、鸡蛋，清洗后按需要切块、切片或分装备用。', '', '2026-05-16 16:43:41', '2026-05-16 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-16 16:43:41', '2026-05-16 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱烘至食材成熟入味。', '', '2026-05-16 16:43:41', '2026-05-16 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-16 16:43:41', '2026-05-16 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '烤箱版M记同款麦乐鸡', '/seed-images/yunyoujun-015.svg', '烤箱版M记同款麦乐鸡是一道适合早餐场景的演示菜谱，食材以土豆、鸡肉、鸡蛋为主。 口味标签：同款。', '简单', 22, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV19v411J7MG', 40016, 2446, 4363, 0, 1, '2026-05-15 16:43:41', '2026-05-15 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '早餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '土豆', '1个', 1, '2026-05-15 16:43:41', '2026-05-15 16:43:41', 0),
  (@recipe_id, '鸡肉', '300g', 2, '2026-05-15 16:43:41', '2026-05-15 16:43:41', 0),
  (@recipe_id, '鸡蛋', '2个', 3, '2026-05-15 16:43:41', '2026-05-15 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好土豆、鸡肉、鸡蛋，清洗后按需要切块、切片或分装备用。', '', '2026-05-15 16:43:41', '2026-05-15 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-15 16:43:41', '2026-05-15 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱至食材成熟入味。', '', '2026-05-15 16:43:41', '2026-05-15 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-15 16:43:41', '2026-05-15 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '烤箱迎客菜', '/seed-images/yunyoujun-016.svg', '烤箱迎客菜是一道适合早餐场景的演示菜谱，食材以牛肉、茄子、鸡肉、鸡蛋为主。 口味标签：杂烩。', '简单', 30, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1ug4y1B7CR', 7034, 2082, 3683, 0, 1, '2026-05-14 16:43:41', '2026-05-14 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '早餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '牛肉', '250g', 1, '2026-05-14 16:43:41', '2026-05-14 16:43:41', 0),
  (@recipe_id, '茄子', '1份', 2, '2026-05-14 16:43:41', '2026-05-14 16:43:41', 0),
  (@recipe_id, '鸡肉', '300g', 3, '2026-05-14 16:43:41', '2026-05-14 16:43:41', 0),
  (@recipe_id, '鸡蛋', '2个', 4, '2026-05-14 16:43:41', '2026-05-14 16:43:41', 0),
  (@recipe_id, '豆腐', '适量', 5, '2026-05-14 16:43:41', '2026-05-14 16:43:41', 0),
  (@recipe_id, '菌菇', '适量', 6, '2026-05-14 16:43:41', '2026-05-14 16:43:41', 0),
  (@recipe_id, '番茄', '2个', 7, '2026-05-14 16:43:41', '2026-05-14 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好牛肉、茄子、鸡肉、鸡蛋、豆腐，清洗后按需要切块、切片或分装备用。', '', '2026-05-14 16:43:41', '2026-05-14 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-14 16:43:41', '2026-05-14 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱至食材成熟入味。', '', '2026-05-14 16:43:41', '2026-05-14 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-14 16:43:41', '2026-05-14 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '法棍', '/seed-images/yunyoujun-017.svg', '法棍是一道适合早餐场景的演示菜谱，食材以面包为主。', '简单', 18, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1Kc411h7eJ', 13655, 1594, 474, 0, 1, '2026-05-13 16:43:41', '2026-05-13 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '早餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '面包', '1份', 1, '2026-05-13 16:43:41', '2026-05-13 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好面包，清洗后按需要切块、切片或分装备用。', '', '2026-05-13 16:43:41', '2026-05-13 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-13 16:43:41', '2026-05-13 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱至食材成熟入味。', '', '2026-05-13 16:43:41', '2026-05-13 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-13 16:43:41', '2026-05-13 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '汉堡面包', '/seed-images/yunyoujun-018.svg', '汉堡面包是一道适合早餐场景的演示菜谱，食材以鸡蛋、面包为主。', '简单', 20, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1ga411h7cw', 43200, 2717, 6084, 0, 1, '2026-05-12 16:43:41', '2026-05-12 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '早餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡蛋', '2个', 1, '2026-05-12 16:43:41', '2026-05-12 16:43:41', 0),
  (@recipe_id, '面包', '1份', 2, '2026-05-12 16:43:41', '2026-05-12 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡蛋、面包，清洗后按需要切块、切片或分装备用。', '', '2026-05-12 16:43:41', '2026-05-12 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-12 16:43:41', '2026-05-12 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱至食材成熟入味。', '', '2026-05-12 16:43:41', '2026-05-12 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-12 16:43:41', '2026-05-12 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '火山熔岩蛋', '/seed-images/yunyoujun-019.svg', '火山熔岩蛋是一道适合早餐场景的演示菜谱，食材以土豆、鸡蛋为主。', '困难', 51, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1Xy4y1L7ok', 29343, 1373, 5620, 0, 1, '2026-05-11 16:43:41', '2026-05-11 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '早餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '土豆', '1个', 1, '2026-05-11 16:43:41', '2026-05-11 16:43:41', 0),
  (@recipe_id, '鸡蛋', '2个', 2, '2026-05-11 16:43:41', '2026-05-11 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好土豆、鸡蛋，清洗后按需要切块、切片或分装备用。', '', '2026-05-11 16:43:41', '2026-05-11 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-11 16:43:41', '2026-05-11 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱烘至食材成熟入味。', '', '2026-05-11 16:43:41', '2026-05-11 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-11 16:43:41', '2026-05-11 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '烤箱版黑椒牛肉土豆焖饭', '/seed-images/yunyoujun-020.svg', '烤箱版黑椒牛肉土豆焖饭是一道适合早餐场景的演示菜谱，食材以牛肉、土豆、胡萝卜、米为主。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV14x411D7uN', 23715, 1360, 3105, 0, 1, '2026-05-10 16:43:41', '2026-05-10 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '早餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '牛肉', '250g', 1, '2026-05-10 16:43:41', '2026-05-10 16:43:41', 0),
  (@recipe_id, '土豆', '1个', 2, '2026-05-10 16:43:41', '2026-05-10 16:43:41', 0),
  (@recipe_id, '胡萝卜', '适量', 3, '2026-05-10 16:43:41', '2026-05-10 16:43:41', 0),
  (@recipe_id, '米', '1杯', 4, '2026-05-10 16:43:41', '2026-05-10 16:43:41', 0),
  (@recipe_id, '鸡蛋', '2个', 5, '2026-05-10 16:43:41', '2026-05-10 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好牛肉、土豆、胡萝卜、米、鸡蛋，清洗后按需要切块、切片或分装备用。', '', '2026-05-10 16:43:41', '2026-05-10 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-10 16:43:41', '2026-05-10 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱至食材成熟入味。', '', '2026-05-10 16:43:41', '2026-05-10 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-10 16:43:41', '2026-05-10 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '烤箱版麻薯', '/seed-images/yunyoujun-021.svg', '烤箱版麻薯是一道适合早餐场景的演示菜谱，食材以鸡蛋为主。', '简单', 18, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1CR4y1t7CM', 8559, 1345, 1587, 0, 1, '2026-05-09 16:43:41', '2026-05-09 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '早餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡蛋', '2个', 1, '2026-05-09 16:43:41', '2026-05-09 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡蛋，清洗后按需要切块、切片或分装备用。', '', '2026-05-09 16:43:41', '2026-05-09 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-09 16:43:41', '2026-05-09 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱至食材成熟入味。', '', '2026-05-09 16:43:41', '2026-05-09 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-09 16:43:41', '2026-05-09 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '烤箱鸡蛋', '/seed-images/yunyoujun-022.svg', '烤箱鸡蛋是一道适合早餐场景的演示菜谱，食材以鸡蛋为主。', '简单', 18, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1Vp4y167P4', 10379, 754, 4000, 0, 1, '2026-05-08 16:43:41', '2026-05-08 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '早餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡蛋', '2个', 1, '2026-05-08 16:43:41', '2026-05-08 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡蛋，清洗后按需要切块、切片或分装备用。', '', '2026-05-08 16:43:41', '2026-05-08 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-08 16:43:41', '2026-05-08 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱烤至食材成熟入味。', '', '2026-05-08 16:43:41', '2026-05-08 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-08 16:43:41', '2026-05-08 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '烤箱面包', '/seed-images/yunyoujun-023.svg', '烤箱面包是一道适合早餐场景的演示菜谱，食材以面包为主。', '简单', 18, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1wJ411E7YS', 44060, 176, 2231, 0, 1, '2026-05-07 16:43:41', '2026-05-07 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '早餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '面包', '1份', 1, '2026-05-07 16:43:41', '2026-05-07 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好面包，清洗后按需要切块、切片或分装备用。', '', '2026-05-07 16:43:41', '2026-05-07 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-07 16:43:41', '2026-05-07 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱烤至食材成熟入味。', '', '2026-05-07 16:43:41', '2026-05-07 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-07 16:43:41', '2026-05-07 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '千层土豆烘蛋', '/seed-images/yunyoujun-024.svg', '千层土豆烘蛋是一道适合早餐场景的演示菜谱，食材以土豆、鸡蛋为主。', '困难', 51, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1fY41187Xo', 41331, 2033, 2821, 0, 1, '2026-05-06 16:43:41', '2026-05-06 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '早餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '土豆', '1个', 1, '2026-05-06 16:43:41', '2026-05-06 16:43:41', 0),
  (@recipe_id, '鸡蛋', '2个', 2, '2026-05-06 16:43:41', '2026-05-06 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好土豆、鸡蛋，清洗后按需要切块、切片或分装备用。', '', '2026-05-06 16:43:41', '2026-05-06 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-06 16:43:41', '2026-05-06 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱烘至食材成熟入味。', '', '2026-05-06 16:43:41', '2026-05-06 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-06 16:43:41', '2026-05-06 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '蒜香芝士面包虾', '/seed-images/yunyoujun-025.svg', '蒜香芝士面包虾是一道适合早餐场景的演示菜谱，食材以面包、虾为主。', '困难', 51, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1gB4y1c7GY', 42397, 729, 6019, 0, 1, '2026-05-05 16:43:41', '2026-05-05 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '早餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '面包', '1份', 1, '2026-05-05 16:43:41', '2026-05-05 16:43:41', 0),
  (@recipe_id, '虾', '1份', 2, '2026-05-05 16:43:41', '2026-05-05 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好面包、虾，清洗后按需要切块、切片或分装备用。', '', '2026-05-05 16:43:41', '2026-05-05 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-05 16:43:41', '2026-05-05 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱至食材成熟入味。', '', '2026-05-05 16:43:41', '2026-05-05 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-05 16:43:41', '2026-05-05 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '土豆面包', '/seed-images/yunyoujun-026.svg', '土豆面包是一道适合早餐场景的演示菜谱，食材以土豆、面包、鸡蛋为主。', '简单', 22, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1H4411572T', 28445, 261, 5806, 0, 1, '2026-05-04 16:43:41', '2026-05-04 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '早餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '土豆', '1个', 1, '2026-05-04 16:43:41', '2026-05-04 16:43:41', 0),
  (@recipe_id, '面包', '1份', 2, '2026-05-04 16:43:41', '2026-05-04 16:43:41', 0),
  (@recipe_id, '鸡蛋', '2个', 3, '2026-05-04 16:43:41', '2026-05-04 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好土豆、面包、鸡蛋，清洗后按需要切块、切片或分装备用。', '', '2026-05-04 16:43:41', '2026-05-04 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-04 16:43:41', '2026-05-04 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱至食材成熟入味。', '', '2026-05-04 16:43:41', '2026-05-04 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-04 16:43:41', '2026-05-04 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '烤箱烧烤', '/seed-images/yunyoujun-027.svg', '烤箱烧烤是一道适合午餐场景的演示菜谱，食材以土豆、胡萝卜、花菜、西葫芦为主。 口味标签：杂烩。', '简单', 58, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV17P4y1W7Ze', 15511, 426, 3964, 0, 1, '2026-05-03 16:43:41', '2026-05-03 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '午餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '土豆', '1个', 1, '2026-05-03 16:43:41', '2026-05-03 16:43:41', 0),
  (@recipe_id, '胡萝卜', '1份', 2, '2026-05-03 16:43:41', '2026-05-03 16:43:41', 0),
  (@recipe_id, '花菜', '适量', 3, '2026-05-03 16:43:41', '2026-05-03 16:43:41', 0),
  (@recipe_id, '西葫芦', '适量', 4, '2026-05-03 16:43:41', '2026-05-03 16:43:41', 0),
  (@recipe_id, '芹菜', '适量', 5, '2026-05-03 16:43:41', '2026-05-03 16:43:41', 0),
  (@recipe_id, '洋葱', '半个', 6, '2026-05-03 16:43:41', '2026-05-03 16:43:41', 0),
  (@recipe_id, '莴笋', '适量', 7, '2026-05-03 16:43:41', '2026-05-03 16:43:41', 0),
  (@recipe_id, '菌菇', '适量', 8, '2026-05-03 16:43:41', '2026-05-03 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好土豆、胡萝卜、花菜、西葫芦、芹菜，清洗后按需要切块、切片或分装备用。', '', '2026-05-03 16:43:41', '2026-05-03 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-03 16:43:41', '2026-05-03 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱至食材成熟入味。', '', '2026-05-03 16:43:41', '2026-05-03 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-03 16:43:41', '2026-05-03 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '烤箱腊肠焖饭', '/seed-images/yunyoujun-028.svg', '烤箱腊肠焖饭是一道适合午餐场景的演示菜谱，食材以腊肠、花菜、米为主。', '简单', 30, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV14x411D7uN', 45647, 732, 1824, 0, 1, '2026-05-02 16:43:41', '2026-05-02 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '午餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '腊肠', '1份', 1, '2026-05-02 16:43:41', '2026-05-02 16:43:41', 0),
  (@recipe_id, '花菜', '1份', 2, '2026-05-02 16:43:41', '2026-05-02 16:43:41', 0),
  (@recipe_id, '米', '1杯', 3, '2026-05-02 16:43:41', '2026-05-02 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好腊肠、花菜、米，清洗后按需要切块、切片或分装备用。', '', '2026-05-02 16:43:41', '2026-05-02 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-02 16:43:41', '2026-05-02 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱至食材成熟入味。', '', '2026-05-02 16:43:41', '2026-05-02 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-02 16:43:41', '2026-05-02 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '午餐肉串', '/seed-images/yunyoujun-029.svg', '午餐肉串是一道适合午餐场景的演示菜谱，食材以午餐肉为主。 口味标签：零食。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1MF411t7Ba', 6735, 2736, 5227, 0, 1, '2026-05-01 16:43:41', '2026-05-01 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '午餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '午餐肉', '1份', 1, '2026-05-01 16:43:41', '2026-05-01 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好午餐肉，清洗后按需要切块、切片或分装备用。', '', '2026-05-01 16:43:41', '2026-05-01 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-05-01 16:43:41', '2026-05-01 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅炸至食材成熟入味。', '', '2026-05-01 16:43:41', '2026-05-01 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-05-01 16:43:41', '2026-05-01 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '微波炉版一个番茄焖饭', '/seed-images/yunyoujun-030.svg', '微波炉版一个番茄焖饭是一道适合午餐场景的演示菜谱，食材以番茄、米、胡萝卜、香肠为主。', '简单', 36, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV193411W7nb', 36515, 246, 3311, 0, 1, '2026-04-30 16:43:41', '2026-04-30 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '午餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '番茄', '2个', 1, '2026-04-30 16:43:41', '2026-04-30 16:43:41', 0),
  (@recipe_id, '米', '1杯', 2, '2026-04-30 16:43:41', '2026-04-30 16:43:41', 0),
  (@recipe_id, '胡萝卜', '适量', 3, '2026-04-30 16:43:41', '2026-04-30 16:43:41', 0),
  (@recipe_id, '香肠', '适量', 4, '2026-04-30 16:43:41', '2026-04-30 16:43:41', 0),
  (@recipe_id, '腊肠', '适量', 5, '2026-04-30 16:43:41', '2026-04-30 16:43:41', 0),
  (@recipe_id, '土豆', '1个', 6, '2026-04-30 16:43:41', '2026-04-30 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好番茄、米、胡萝卜、香肠、腊肠，清洗后按需要切块、切片或分装备用。', '', '2026-04-30 16:43:41', '2026-04-30 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-30 16:43:41', '2026-04-30 16:43:41', 0),
  (@recipe_id, 3, '使用微波炉至食材成熟入味。', '', '2026-04-30 16:43:41', '2026-04-30 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-30 16:43:41', '2026-04-30 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '微波炉版煮米饭', '/seed-images/yunyoujun-031.svg', '微波炉版煮米饭是一道适合午餐场景的演示菜谱，食材以米为主。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV193411W7nb', 10161, 194, 3036, 0, 1, '2026-04-29 16:43:41', '2026-04-29 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '午餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '米', '1杯', 1, '2026-04-29 16:43:41', '2026-04-29 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好米，清洗后按需要切块、切片或分装备用。', '', '2026-04-29 16:43:41', '2026-04-29 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-29 16:43:41', '2026-04-29 16:43:41', 0),
  (@recipe_id, 3, '使用微波炉至食材成熟入味。', '', '2026-04-29 16:43:41', '2026-04-29 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-29 16:43:41', '2026-04-29 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '茄子焖饭', '/seed-images/yunyoujun-032.svg', '茄子焖饭是一道适合午餐场景的演示菜谱，食材以茄子为主。 口味标签：单一食材。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1k7411m7nv', 14238, 986, 4679, 0, 1, '2026-04-28 16:43:41', '2026-04-28 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '午餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '茄子', '1份', 1, '2026-04-28 16:43:41', '2026-04-28 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好茄子，清洗后按需要切块、切片或分装备用。', '', '2026-04-28 16:43:41', '2026-04-28 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-28 16:43:41', '2026-04-28 16:43:41', 0),
  (@recipe_id, 3, '使用一口大锅烧至食材成熟入味。', '', '2026-04-28 16:43:41', '2026-04-28 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-28 16:43:41', '2026-04-28 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '拍辣椒炒午餐肉', '/seed-images/yunyoujun-033.svg', '拍辣椒炒午餐肉是一道适合午餐场景的演示菜谱，食材以午餐肉为主。 口味标签：家常菜。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1K4411Z7do', 23784, 1979, 3765, 0, 1, '2026-04-27 16:43:41', '2026-04-27 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '午餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '午餐肉', '1份', 1, '2026-04-27 16:43:41', '2026-04-27 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好午餐肉，清洗后按需要切块、切片或分装备用。', '', '2026-04-27 16:43:41', '2026-04-27 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-27 16:43:41', '2026-04-27 16:43:41', 0),
  (@recipe_id, 3, '使用一口大锅炒至食材成熟入味。', '', '2026-04-27 16:43:41', '2026-04-27 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-27 16:43:41', '2026-04-27 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '花菜虾仁炒饭', '/seed-images/yunyoujun-034.svg', '花菜虾仁炒饭是一道适合午餐场景的演示菜谱，食材以花菜、虾仁、米、洋葱为主。', '简单', 34, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1z4411a7dy', 22683, 1664, 98, 0, 1, '2026-04-26 16:43:41', '2026-04-26 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '午餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '花菜', '1份', 1, '2026-04-26 16:43:41', '2026-04-26 16:43:41', 0),
  (@recipe_id, '虾仁', '1份', 2, '2026-04-26 16:43:41', '2026-04-26 16:43:41', 0),
  (@recipe_id, '米', '1杯', 3, '2026-04-26 16:43:41', '2026-04-26 16:43:41', 0),
  (@recipe_id, '洋葱', '半个', 4, '2026-04-26 16:43:41', '2026-04-26 16:43:41', 0),
  (@recipe_id, '胡萝卜', '适量', 5, '2026-04-26 16:43:41', '2026-04-26 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好花菜、虾仁、米、洋葱、胡萝卜，清洗后按需要切块、切片或分装备用。', '', '2026-04-26 16:43:41', '2026-04-26 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-26 16:43:41', '2026-04-26 16:43:41', 0),
  (@recipe_id, 3, '使用一口大锅至食材成熟入味。', '', '2026-04-26 16:43:41', '2026-04-26 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-26 16:43:41', '2026-04-26 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '金丝午餐肉', '/seed-images/yunyoujun-035.svg', '金丝午餐肉是一道适合午餐场景的演示菜谱，食材以土豆、午餐肉为主。', '简单', 28, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1W34y1k7Bg', 38495, 722, 4779, 0, 1, '2026-04-25 16:43:41', '2026-04-25 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '午餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '土豆', '1个', 1, '2026-04-25 16:43:41', '2026-04-25 16:43:41', 0),
  (@recipe_id, '午餐肉', '1份', 2, '2026-04-25 16:43:41', '2026-04-25 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好土豆、午餐肉，清洗后按需要切块、切片或分装备用。', '', '2026-04-25 16:43:41', '2026-04-25 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-25 16:43:41', '2026-04-25 16:43:41', 0),
  (@recipe_id, 3, '使用一口大锅炸至食材成熟入味。', '', '2026-04-25 16:43:41', '2026-04-25 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-25 16:43:41', '2026-04-25 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '午餐肉土豆锅', '/seed-images/yunyoujun-036.svg', '午餐肉土豆锅是一道适合午餐场景的演示菜谱，食材以午餐肉、土豆、胡萝卜为主。', '简单', 30, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1gT4y1Q7R8', 15060, 164, 2182, 0, 1, '2026-04-24 16:43:41', '2026-04-24 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '午餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '午餐肉', '1份', 1, '2026-04-24 16:43:41', '2026-04-24 16:43:41', 0),
  (@recipe_id, '土豆', '1个', 2, '2026-04-24 16:43:41', '2026-04-24 16:43:41', 0),
  (@recipe_id, '胡萝卜', '适量', 3, '2026-04-24 16:43:41', '2026-04-24 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好午餐肉、土豆、胡萝卜，清洗后按需要切块、切片或分装备用。', '', '2026-04-24 16:43:41', '2026-04-24 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-24 16:43:41', '2026-04-24 16:43:41', 0),
  (@recipe_id, 3, '使用一口大锅煮至食材成熟入味。', '', '2026-04-24 16:43:41', '2026-04-24 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-24 16:43:41', '2026-04-24 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '烤箱版M记同款薯条', '/seed-images/yunyoujun-037.svg', '烤箱版M记同款薯条是一道适合晚餐场景的演示菜谱，食材以土豆为主。 口味标签：同款。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1nA411P7aX', 47312, 2458, 1595, 0, 1, '2026-04-23 16:43:41', '2026-04-23 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '晚餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '土豆', '1个', 1, '2026-04-23 16:43:41', '2026-04-23 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好土豆，清洗后按需要切块、切片或分装备用。', '', '2026-04-23 16:43:41', '2026-04-23 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-23 16:43:41', '2026-04-23 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱至食材成熟入味。', '', '2026-04-23 16:43:41', '2026-04-23 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-23 16:43:41', '2026-04-23 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '气泡小土豆', '/seed-images/yunyoujun-038.svg', '气泡小土豆是一道适合晚餐场景的演示菜谱，食材以土豆为主。 口味标签：零食。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1sL41137jN', 27122, 2019, 4153, 0, 1, '2026-04-22 16:43:41', '2026-04-22 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '晚餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '土豆', '1个', 1, '2026-04-22 16:43:41', '2026-04-22 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好土豆，清洗后按需要切块、切片或分装备用。', '', '2026-04-22 16:43:41', '2026-04-22 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-22 16:43:41', '2026-04-22 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱烘至食材成熟入味。', '', '2026-04-22 16:43:41', '2026-04-22 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-22 16:43:41', '2026-04-22 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '烤箱版KFC同款香辣鸡翅', '/seed-images/yunyoujun-039.svg', '烤箱版KFC同款香辣鸡翅是一道适合晚餐场景的演示菜谱，食材以鸡肉为主。 口味标签：同款。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1jA4y197RR', 20457, 340, 4404, 0, 1, '2026-04-21 16:43:41', '2026-04-21 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '晚餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-04-21 16:43:41', '2026-04-21 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉，清洗后按需要切块、切片或分装备用。', '', '2026-04-21 16:43:41', '2026-04-21 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-21 16:43:41', '2026-04-21 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱至食材成熟入味。', '', '2026-04-21 16:43:41', '2026-04-21 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-21 16:43:41', '2026-04-21 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '烤箱版M记同款薯饼', '/seed-images/yunyoujun-040.svg', '烤箱版M记同款薯饼是一道适合晚餐场景的演示菜谱，食材以土豆为主。 口味标签：同款。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1qy4y1y7Mn', 44835, 2257, 6666, 0, 1, '2026-04-20 16:43:41', '2026-04-20 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '晚餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '土豆', '1个', 1, '2026-04-20 16:43:41', '2026-04-20 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好土豆，清洗后按需要切块、切片或分装备用。', '', '2026-04-20 16:43:41', '2026-04-20 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-20 16:43:41', '2026-04-20 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱至食材成熟入味。', '', '2026-04-20 16:43:41', '2026-04-20 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-20 16:43:41', '2026-04-20 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '爆浆鸡腿', '/seed-images/yunyoujun-041.svg', '爆浆鸡腿是一道适合晚餐场景的演示菜谱，食材以鸡肉为主。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1ju411X7mx', 37711, 2328, 3926, 0, 1, '2026-04-19 16:43:41', '2026-04-19 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '晚餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-04-19 16:43:41', '2026-04-19 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉，清洗后按需要切块、切片或分装备用。', '', '2026-04-19 16:43:41', '2026-04-19 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-19 16:43:41', '2026-04-19 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱烤至食材成熟入味。', '', '2026-04-19 16:43:41', '2026-04-19 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-19 16:43:41', '2026-04-19 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, 'BBQ烤鸡腿', '/seed-images/yunyoujun-042.svg', 'BBQ烤鸡腿是一道适合晚餐场景的演示菜谱，食材以鸡肉为主。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1Zr4y1B7UQ', 44079, 1604, 3260, 0, 1, '2026-04-18 16:43:41', '2026-04-18 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '晚餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-04-18 16:43:41', '2026-04-18 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉，清洗后按需要切块、切片或分装备用。', '', '2026-04-18 16:43:41', '2026-04-18 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-18 16:43:41', '2026-04-18 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱烤至食材成熟入味。', '', '2026-04-18 16:43:41', '2026-04-18 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-18 16:43:41', '2026-04-18 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, 'BBQ烟熏手撕猪肉', '/seed-images/yunyoujun-043.svg', 'BBQ烟熏手撕猪肉是一道适合晚餐场景的演示菜谱，食材以猪肉为主。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1DV411x7SH', 10348, 2216, 192, 0, 1, '2026-04-17 16:43:41', '2026-04-17 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '晚餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '猪肉', '250g', 1, '2026-04-17 16:43:41', '2026-04-17 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好猪肉，清洗后按需要切块、切片或分装备用。', '', '2026-04-17 16:43:41', '2026-04-17 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-17 16:43:41', '2026-04-17 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱烤至食材成熟入味。', '', '2026-04-17 16:43:41', '2026-04-17 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-17 16:43:41', '2026-04-17 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '馋嘴烤箱版烧烤', '/seed-images/yunyoujun-044.svg', '馋嘴烤箱版烧烤是一道适合晚餐场景的演示菜谱，食材以土豆、鸡肉为主。', '简单', 28, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1wv411h7d6', 43675, 1122, 6574, 0, 1, '2026-04-16 16:43:41', '2026-04-16 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '晚餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '土豆', '1个', 1, '2026-04-16 16:43:41', '2026-04-16 16:43:41', 0),
  (@recipe_id, '鸡肉', '300g', 2, '2026-04-16 16:43:41', '2026-04-16 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好土豆、鸡肉，清洗后按需要切块、切片或分装备用。', '', '2026-04-16 16:43:41', '2026-04-16 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-16 16:43:41', '2026-04-16 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱烤至食材成熟入味。', '', '2026-04-16 16:43:41', '2026-04-16 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-16 16:43:41', '2026-04-16 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '脆皮五花肉和蜜汁叉烧', '/seed-images/yunyoujun-045.svg', '脆皮五花肉和蜜汁叉烧是一道适合晚餐场景的演示菜谱，食材以猪肉为主。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV17u411i7jF', 17175, 2136, 3371, 0, 1, '2026-04-15 16:43:41', '2026-04-15 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '晚餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '猪肉', '250g', 1, '2026-04-15 16:43:41', '2026-04-15 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好猪肉，清洗后按需要切块、切片或分装备用。', '', '2026-04-15 16:43:41', '2026-04-15 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-15 16:43:41', '2026-04-15 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱烤至食材成熟入味。', '', '2026-04-15 16:43:41', '2026-04-15 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-15 16:43:41', '2026-04-15 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '烤箱版爆浆鸡腿', '/seed-images/yunyoujun-046.svg', '烤箱版爆浆鸡腿是一道适合晚餐场景的演示菜谱，食材以鸡肉为主。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1ju411X7mx', 8905, 1029, 2737, 0, 1, '2026-04-14 16:43:41', '2026-04-14 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '晚餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-04-14 16:43:41', '2026-04-14 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉，清洗后按需要切块、切片或分装备用。', '', '2026-04-14 16:43:41', '2026-04-14 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-14 16:43:41', '2026-04-14 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱至食材成熟入味。', '', '2026-04-14 16:43:41', '2026-04-14 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-14 16:43:41', '2026-04-14 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '烤箱版橙香鸡翅', '/seed-images/yunyoujun-047.svg', '烤箱版橙香鸡翅是一道适合晚餐场景的演示菜谱，食材以鸡肉为主。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1Mb4y1Q7DU', 1236, 2205, 5719, 0, 1, '2026-04-13 16:43:41', '2026-04-13 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '晚餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-04-13 16:43:41', '2026-04-13 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉，清洗后按需要切块、切片或分装备用。', '', '2026-04-13 16:43:41', '2026-04-13 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-13 16:43:41', '2026-04-13 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱烤至食材成熟入味。', '', '2026-04-13 16:43:41', '2026-04-13 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-13 16:43:41', '2026-04-13 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '烤箱版脆皮五花肉', '/seed-images/yunyoujun-048.svg', '烤箱版脆皮五花肉是一道适合晚餐场景的演示菜谱，食材以猪肉为主。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1VS4y137dE', 30111, 2424, 5506, 0, 1, '2026-04-12 16:43:41', '2026-04-12 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '晚餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '猪肉', '250g', 1, '2026-04-12 16:43:41', '2026-04-12 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好猪肉，清洗后按需要切块、切片或分装备用。', '', '2026-04-12 16:43:41', '2026-04-12 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-12 16:43:41', '2026-04-12 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱烤至食材成熟入味。', '', '2026-04-12 16:43:41', '2026-04-12 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-12 16:43:41', '2026-04-12 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '烤箱版烤串', '/seed-images/yunyoujun-049.svg', '烤箱版烤串是一道适合晚餐场景的演示菜谱，食材以猪肉、花菜为主。', '简单', 28, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV17P4y1W7Ze', 30043, 2008, 3651, 0, 1, '2026-04-11 16:43:41', '2026-04-11 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '晚餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '猪肉', '250g', 1, '2026-04-11 16:43:41', '2026-04-11 16:43:41', 0),
  (@recipe_id, '花菜', '1份', 2, '2026-04-11 16:43:41', '2026-04-11 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好猪肉、花菜，清洗后按需要切块、切片或分装备用。', '', '2026-04-11 16:43:41', '2026-04-11 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-04-11 16:43:41', '2026-04-11 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱烤至食材成熟入味。', '', '2026-04-11 16:43:41', '2026-04-11 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-11 16:43:41', '2026-04-11 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '电饭煲版蛋糕（废手版）', '/seed-images/yunyoujun-050.svg', '电饭煲版蛋糕（废手版）是一道适合甜品场景的演示菜谱，食材以鸡蛋、面食为主。 口味标签：香软。', '简单', 20, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1H7411V7Pz', 847, 339, 6327, 0, 1, '2026-04-10 16:43:41', '2026-04-10 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '甜品'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡蛋', '2个', 1, '2026-04-10 16:43:41', '2026-04-10 16:43:41', 0),
  (@recipe_id, '面食', '1份', 2, '2026-04-10 16:43:41', '2026-04-10 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡蛋、面食，清洗后按需要切块、切片或分装备用。', '', '2026-04-10 16:43:41', '2026-04-10 16:43:41', 0),
  (@recipe_id, 2, '根据甜度加入糖、牛奶或蜂蜜，搅拌均匀。', '', '2026-04-10 16:43:41', '2026-04-10 16:43:41', 0),
  (@recipe_id, 3, '按配方混合食材，小火加热或冷藏定型，保持口感细腻。', '', '2026-04-10 16:43:41', '2026-04-10 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-10 16:43:41', '2026-04-10 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '电饭煲版吐司（尽量不做，废手）', '/seed-images/yunyoujun-051.svg', '电饭煲版吐司（尽量不做，废手）是一道适合甜品场景的演示菜谱，食材以鸡蛋、面包为主。', '困难', 51, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1vY41137F1', 46232, 141, 4710, 0, 1, '2026-04-09 16:43:41', '2026-04-09 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '甜品'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡蛋', '2个', 1, '2026-04-09 16:43:41', '2026-04-09 16:43:41', 0),
  (@recipe_id, '面包', '1份', 2, '2026-04-09 16:43:41', '2026-04-09 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡蛋、面包，清洗后按需要切块、切片或分装备用。', '', '2026-04-09 16:43:41', '2026-04-09 16:43:41', 0),
  (@recipe_id, 2, '根据甜度加入糖、牛奶或蜂蜜，搅拌均匀。', '', '2026-04-09 16:43:41', '2026-04-09 16:43:41', 0),
  (@recipe_id, 3, '按配方混合食材，小火加热或冷藏定型，保持口感细腻。', '', '2026-04-09 16:43:41', '2026-04-09 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-09 16:43:41', '2026-04-09 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '烤布丁', '/seed-images/yunyoujun-052.svg', '烤布丁是一道适合甜品场景的演示菜谱，食材以鸡蛋为主。', '简单', 18, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1TT4y127vu', 30776, 2100, 3554, 0, 1, '2026-04-08 16:43:41', '2026-04-08 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '甜品'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡蛋', '2个', 1, '2026-04-08 16:43:41', '2026-04-08 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡蛋，清洗后按需要切块、切片或分装备用。', '', '2026-04-08 16:43:41', '2026-04-08 16:43:41', 0),
  (@recipe_id, 2, '根据甜度加入糖、牛奶或蜂蜜，搅拌均匀。', '', '2026-04-08 16:43:41', '2026-04-08 16:43:41', 0),
  (@recipe_id, 3, '按配方混合食材，小火加热或冷藏定型，保持口感细腻。', '', '2026-04-08 16:43:41', '2026-04-08 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-08 16:43:41', '2026-04-08 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '流心培根吐司', '/seed-images/yunyoujun-053.svg', '流心培根吐司是一道适合甜品场景的演示菜谱，食材以面包、鸡蛋、猪肉为主。', '简单', 22, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1aZ4y1R7SL', 30856, 2652, 3866, 0, 1, '2026-04-07 16:43:41', '2026-04-07 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '甜品'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '面包', '1份', 1, '2026-04-07 16:43:41', '2026-04-07 16:43:41', 0),
  (@recipe_id, '鸡蛋', '2个', 2, '2026-04-07 16:43:41', '2026-04-07 16:43:41', 0),
  (@recipe_id, '猪肉', '250g', 3, '2026-04-07 16:43:41', '2026-04-07 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好面包、鸡蛋、猪肉，清洗后按需要切块、切片或分装备用。', '', '2026-04-07 16:43:41', '2026-04-07 16:43:41', 0),
  (@recipe_id, 2, '根据甜度加入糖、牛奶或蜂蜜，搅拌均匀。', '', '2026-04-07 16:43:41', '2026-04-07 16:43:41', 0),
  (@recipe_id, 3, '按配方混合食材，小火加热或冷藏定型，保持口感细腻。', '', '2026-04-07 16:43:41', '2026-04-07 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-07 16:43:41', '2026-04-07 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '年轮蛋糕（难度max）', '/seed-images/yunyoujun-054.svg', '年轮蛋糕（难度max）是一道适合甜品场景的演示菜谱，食材以面包、鸡蛋为主。', '困难', 51, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1WQ4y1q7iz', 6345, 2799, 1471, 0, 1, '2026-04-06 16:43:41', '2026-04-06 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '甜品'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '面包', '1份', 1, '2026-04-06 16:43:41', '2026-04-06 16:43:41', 0),
  (@recipe_id, '鸡蛋', '2个', 2, '2026-04-06 16:43:41', '2026-04-06 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好面包、鸡蛋，清洗后按需要切块、切片或分装备用。', '', '2026-04-06 16:43:41', '2026-04-06 16:43:41', 0),
  (@recipe_id, 2, '根据甜度加入糖、牛奶或蜂蜜，搅拌均匀。', '', '2026-04-06 16:43:41', '2026-04-06 16:43:41', 0),
  (@recipe_id, 3, '按配方混合食材，小火加热或冷藏定型，保持口感细腻。', '', '2026-04-06 16:43:41', '2026-04-06 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-06 16:43:41', '2026-04-06 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '牛奶烤土司', '/seed-images/yunyoujun-055.svg', '牛奶烤土司是一道适合甜品场景的演示菜谱，食材以鸡蛋、面包为主。', '简单', 20, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1KF411Y7WP', 42240, 1258, 3765, 0, 1, '2026-04-05 16:43:41', '2026-04-05 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '甜品'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡蛋', '2个', 1, '2026-04-05 16:43:41', '2026-04-05 16:43:41', 0),
  (@recipe_id, '面包', '1份', 2, '2026-04-05 16:43:41', '2026-04-05 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡蛋、面包，清洗后按需要切块、切片或分装备用。', '', '2026-04-05 16:43:41', '2026-04-05 16:43:41', 0),
  (@recipe_id, 2, '根据甜度加入糖、牛奶或蜂蜜，搅拌均匀。', '', '2026-04-05 16:43:41', '2026-04-05 16:43:41', 0),
  (@recipe_id, 3, '按配方混合食材，小火加热或冷藏定型，保持口感细腻。', '', '2026-04-05 16:43:41', '2026-04-05 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-05 16:43:41', '2026-04-05 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '焦糖吐司布丁', '/seed-images/yunyoujun-056.svg', '焦糖吐司布丁是一道适合甜品场景的演示菜谱，食材以鸡蛋、面包、豆腐为主。', '简单', 22, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1sq4y197TK', 26514, 2601, 983, 0, 1, '2026-04-04 16:43:41', '2026-04-04 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '甜品'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡蛋', '2个', 1, '2026-04-04 16:43:41', '2026-04-04 16:43:41', 0),
  (@recipe_id, '面包', '1份', 2, '2026-04-04 16:43:41', '2026-04-04 16:43:41', 0),
  (@recipe_id, '豆腐', '适量', 3, '2026-04-04 16:43:41', '2026-04-04 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡蛋、面包、豆腐，清洗后按需要切块、切片或分装备用。', '', '2026-04-04 16:43:41', '2026-04-04 16:43:41', 0),
  (@recipe_id, 2, '根据甜度加入糖、牛奶或蜂蜜，搅拌均匀。', '', '2026-04-04 16:43:41', '2026-04-04 16:43:41', 0),
  (@recipe_id, 3, '按配方混合食材，小火加热或冷藏定型，保持口感细腻。', '', '2026-04-04 16:43:41', '2026-04-04 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-04 16:43:41', '2026-04-04 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅爆浆巴斯克芝士蛋糕', '/seed-images/yunyoujun-057.svg', '空气炸锅爆浆巴斯克芝士蛋糕是一道适合甜品场景的演示菜谱，食材以鸡蛋为主。', '简单', 18, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1Ja411v7DK', 35462, 1800, 3619, 0, 1, '2026-04-03 16:43:41', '2026-04-03 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '甜品'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡蛋', '2个', 1, '2026-04-03 16:43:41', '2026-04-03 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡蛋，清洗后按需要切块、切片或分装备用。', '', '2026-04-03 16:43:41', '2026-04-03 16:43:41', 0),
  (@recipe_id, 2, '根据甜度加入糖、牛奶或蜂蜜，搅拌均匀。', '', '2026-04-03 16:43:41', '2026-04-03 16:43:41', 0),
  (@recipe_id, 3, '按配方混合食材，小火加热或冷藏定型，保持口感细腻。', '', '2026-04-03 16:43:41', '2026-04-03 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-03 16:43:41', '2026-04-03 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅法式吐司', '/seed-images/yunyoujun-058.svg', '空气炸锅法式吐司是一道适合甜品场景的演示菜谱，食材以面包、鸡蛋为主。', '简单', 20, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1Fh41187GB', 41813, 2731, 2018, 0, 1, '2026-04-02 16:43:41', '2026-04-02 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '甜品'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '面包', '1份', 1, '2026-04-02 16:43:41', '2026-04-02 16:43:41', 0),
  (@recipe_id, '鸡蛋', '2个', 2, '2026-04-02 16:43:41', '2026-04-02 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好面包、鸡蛋，清洗后按需要切块、切片或分装备用。', '', '2026-04-02 16:43:41', '2026-04-02 16:43:41', 0),
  (@recipe_id, 2, '根据甜度加入糖、牛奶或蜂蜜，搅拌均匀。', '', '2026-04-02 16:43:41', '2026-04-02 16:43:41', 0),
  (@recipe_id, 3, '按配方混合食材，小火加热或冷藏定型，保持口感细腻。', '', '2026-04-02 16:43:41', '2026-04-02 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-02 16:43:41', '2026-04-02 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅烤牛奶', '/seed-images/yunyoujun-059.svg', '空气炸锅烤牛奶是一道适合甜品场景的演示菜谱，食材以鸡蛋为主。', '简单', 18, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1ub4y1C7bp', 41161, 1524, 621, 0, 1, '2026-04-01 16:43:41', '2026-04-01 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '甜品'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡蛋', '2个', 1, '2026-04-01 16:43:41', '2026-04-01 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡蛋，清洗后按需要切块、切片或分装备用。', '', '2026-04-01 16:43:41', '2026-04-01 16:43:41', 0),
  (@recipe_id, 2, '根据甜度加入糖、牛奶或蜂蜜，搅拌均匀。', '', '2026-04-01 16:43:41', '2026-04-01 16:43:41', 0),
  (@recipe_id, 3, '按配方混合食材，小火加热或冷藏定型，保持口感细腻。', '', '2026-04-01 16:43:41', '2026-04-01 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-04-01 16:43:41', '2026-04-01 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅酸奶蛋糕', '/seed-images/yunyoujun-060.svg', '空气炸锅酸奶蛋糕是一道适合甜品场景的演示菜谱，食材以鸡蛋为主。', '简单', 18, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1HL4y177B3', 44226, 2694, 3367, 0, 1, '2026-03-31 16:43:41', '2026-03-31 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '甜品'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡蛋', '2个', 1, '2026-03-31 16:43:41', '2026-03-31 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡蛋，清洗后按需要切块、切片或分装备用。', '', '2026-03-31 16:43:41', '2026-03-31 16:43:41', 0),
  (@recipe_id, 2, '根据甜度加入糖、牛奶或蜂蜜，搅拌均匀。', '', '2026-03-31 16:43:41', '2026-03-31 16:43:41', 0),
  (@recipe_id, 3, '按配方混合食材，小火加热或冷藏定型，保持口感细腻。', '', '2026-03-31 16:43:41', '2026-03-31 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-31 16:43:41', '2026-03-31 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅糖醋里脊', '/seed-images/yunyoujun-061.svg', '空气炸锅糖醋里脊是一道适合甜品场景的演示菜谱，食材以猪肉为主。', '简单', 18, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1rS4y137gC', 45973, 1119, 6620, 0, 1, '2026-03-30 16:43:41', '2026-03-30 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '甜品'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '猪肉', '250g', 1, '2026-03-30 16:43:41', '2026-03-30 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好猪肉，清洗后按需要切块、切片或分装备用。', '', '2026-03-30 16:43:41', '2026-03-30 16:43:41', 0),
  (@recipe_id, 2, '根据甜度加入糖、牛奶或蜂蜜，搅拌均匀。', '', '2026-03-30 16:43:41', '2026-03-30 16:43:41', 0),
  (@recipe_id, 3, '按配方混合食材，小火加热或冷藏定型，保持口感细腻。', '', '2026-03-30 16:43:41', '2026-03-30 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-30 16:43:41', '2026-03-30 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '电饭煲版广式腊肠煲饭', '/seed-images/yunyoujun-062.svg', '电饭煲版广式腊肠煲饭是一道适合汤类场景的演示菜谱，食材以腊肠、米为主。 口味标签：广式。', '简单', 53, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1NE411Q7Jj', 42708, 2163, 888, 0, 1, '2026-03-29 16:43:41', '2026-03-29 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '汤类'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '腊肠', '1份', 1, '2026-03-29 16:43:41', '2026-03-29 16:43:41', 0),
  (@recipe_id, '米', '1杯', 2, '2026-03-29 16:43:41', '2026-03-29 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好腊肠、米，清洗后按需要切块、切片或分装备用。', '', '2026-03-29 16:43:41', '2026-03-29 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-03-29 16:43:41', '2026-03-29 16:43:41', 0),
  (@recipe_id, 3, '加入足量清水，先大火煮开，再转小火慢煮至汤色清亮、食材软嫩。', '', '2026-03-29 16:43:41', '2026-03-29 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-29 16:43:41', '2026-03-29 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '电饭煲版烧鸡', '/seed-images/yunyoujun-063.svg', '电饭煲版烧鸡是一道适合汤类场景的演示菜谱，食材以鸡肉、洋葱、菌菇为主。 口味标签：好吃。', '简单', 55, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1T54y1U7Cu', 31251, 834, 3712, 0, 1, '2026-03-28 16:43:41', '2026-03-28 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '汤类'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-03-28 16:43:41', '2026-03-28 16:43:41', 0),
  (@recipe_id, '洋葱', '半个', 2, '2026-03-28 16:43:41', '2026-03-28 16:43:41', 0),
  (@recipe_id, '菌菇', '适量', 3, '2026-03-28 16:43:41', '2026-03-28 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉、洋葱、菌菇，清洗后按需要切块、切片或分装备用。', '', '2026-03-28 16:43:41', '2026-03-28 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-03-28 16:43:41', '2026-03-28 16:43:41', 0),
  (@recipe_id, 3, '加入足量清水，先大火煮开，再转小火慢煮至汤色清亮、食材软嫩。', '', '2026-03-28 16:43:41', '2026-03-28 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-28 16:43:41', '2026-03-28 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '电饭煲焖面', '/seed-images/yunyoujun-064.svg', '电饭煲焖面是一道适合汤类场景的演示菜谱，食材以猪肉、面食为主。 口味标签：筋道。', '简单', 53, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV14b411q7rM', 40792, 1187, 1534, 0, 1, '2026-03-27 16:43:41', '2026-03-27 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '汤类'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '猪肉', '250g', 1, '2026-03-27 16:43:41', '2026-03-27 16:43:41', 0),
  (@recipe_id, '面食', '1份', 2, '2026-03-27 16:43:41', '2026-03-27 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好猪肉、面食，清洗后按需要切块、切片或分装备用。', '', '2026-03-27 16:43:41', '2026-03-27 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-03-27 16:43:41', '2026-03-27 16:43:41', 0),
  (@recipe_id, 3, '加入足量清水，先大火煮开，再转小火慢煮至汤色清亮、食材软嫩。', '', '2026-03-27 16:43:41', '2026-03-27 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-27 16:43:41', '2026-03-27 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '电饭煲版番茄牛腩焖饭', '/seed-images/yunyoujun-065.svg', '电饭煲版番茄牛腩焖饭是一道适合汤类场景的演示菜谱，食材以牛肉、番茄、米为主。 口味标签：懒人。', '简单', 55, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1Bv411C7X3', 6164, 941, 5574, 0, 1, '2026-03-26 16:43:41', '2026-03-26 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '汤类'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '牛肉', '250g', 1, '2026-03-26 16:43:41', '2026-03-26 16:43:41', 0),
  (@recipe_id, '番茄', '2个', 2, '2026-03-26 16:43:41', '2026-03-26 16:43:41', 0),
  (@recipe_id, '米', '1杯', 3, '2026-03-26 16:43:41', '2026-03-26 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好牛肉、番茄、米，清洗后按需要切块、切片或分装备用。', '', '2026-03-26 16:43:41', '2026-03-26 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-03-26 16:43:41', '2026-03-26 16:43:41', 0),
  (@recipe_id, 3, '加入足量清水，先大火煮开，再转小火慢煮至汤色清亮、食材软嫩。', '', '2026-03-26 16:43:41', '2026-03-26 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-26 16:43:41', '2026-03-26 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '电饭煲版蜜汁鸡翅', '/seed-images/yunyoujun-066.svg', '电饭煲版蜜汁鸡翅是一道适合汤类场景的演示菜谱，食材以鸡肉为主。 口味标签：懒人。', '简单', 51, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1dj411f7sR', 10570, 186, 1498, 0, 1, '2026-03-25 16:43:41', '2026-03-25 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '汤类'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-03-25 16:43:41', '2026-03-25 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉，清洗后按需要切块、切片或分装备用。', '', '2026-03-25 16:43:41', '2026-03-25 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-03-25 16:43:41', '2026-03-25 16:43:41', 0),
  (@recipe_id, 3, '加入足量清水，先大火煮开，再转小火慢煮至汤色清亮、食材软嫩。', '', '2026-03-25 16:43:41', '2026-03-25 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-25 16:43:41', '2026-03-25 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '电饭煲版南瓜鸡腿焖饭', '/seed-images/yunyoujun-067.svg', '电饭煲版南瓜鸡腿焖饭是一道适合汤类场景的演示菜谱，食材以鸡肉、洋葱、菌菇、米为主。 口味标签：懒人。', '简单', 57, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1Bv411C7X3', 46954, 1766, 2668, 0, 1, '2026-03-24 16:43:41', '2026-03-24 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '汤类'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-03-24 16:43:41', '2026-03-24 16:43:41', 0),
  (@recipe_id, '洋葱', '半个', 2, '2026-03-24 16:43:41', '2026-03-24 16:43:41', 0),
  (@recipe_id, '菌菇', '适量', 3, '2026-03-24 16:43:41', '2026-03-24 16:43:41', 0),
  (@recipe_id, '米', '1杯', 4, '2026-03-24 16:43:41', '2026-03-24 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉、洋葱、菌菇、米，清洗后按需要切块、切片或分装备用。', '', '2026-03-24 16:43:41', '2026-03-24 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-03-24 16:43:41', '2026-03-24 16:43:41', 0),
  (@recipe_id, 3, '加入足量清水，先大火煮开，再转小火慢煮至汤色清亮、食材软嫩。', '', '2026-03-24 16:43:41', '2026-03-24 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-24 16:43:41', '2026-03-24 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '电饭煲版土豆排骨焖饭', '/seed-images/yunyoujun-068.svg', '电饭煲版土豆排骨焖饭是一道适合汤类场景的演示菜谱，食材以猪肉、土豆、米、腊肠为主。 口味标签：懒人。', '简单', 57, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1Bv411C7X3', 6573, 69, 415, 0, 1, '2026-03-23 16:43:41', '2026-03-23 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '汤类'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '猪肉', '250g', 1, '2026-03-23 16:43:41', '2026-03-23 16:43:41', 0),
  (@recipe_id, '土豆', '1个', 2, '2026-03-23 16:43:41', '2026-03-23 16:43:41', 0),
  (@recipe_id, '米', '1杯', 3, '2026-03-23 16:43:41', '2026-03-23 16:43:41', 0),
  (@recipe_id, '腊肠', '适量', 4, '2026-03-23 16:43:41', '2026-03-23 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好猪肉、土豆、米、腊肠，清洗后按需要切块、切片或分装备用。', '', '2026-03-23 16:43:41', '2026-03-23 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-03-23 16:43:41', '2026-03-23 16:43:41', 0),
  (@recipe_id, 3, '加入足量清水，先大火煮开，再转小火慢煮至汤色清亮、食材软嫩。', '', '2026-03-23 16:43:41', '2026-03-23 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-23 16:43:41', '2026-03-23 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '电饭煲版香菇腊肠焖饭', '/seed-images/yunyoujun-069.svg', '电饭煲版香菇腊肠焖饭是一道适合汤类场景的演示菜谱，食材以腊肠、菌菇、洋葱、米为主。 口味标签：懒人。', '简单', 59, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1Bv411C7X3', 18017, 2268, 4496, 0, 1, '2026-03-22 16:43:41', '2026-03-22 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '汤类'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '腊肠', '1份', 1, '2026-03-22 16:43:41', '2026-03-22 16:43:41', 0),
  (@recipe_id, '菌菇', '适量', 2, '2026-03-22 16:43:41', '2026-03-22 16:43:41', 0),
  (@recipe_id, '洋葱', '半个', 3, '2026-03-22 16:43:41', '2026-03-22 16:43:41', 0),
  (@recipe_id, '米', '1杯', 4, '2026-03-22 16:43:41', '2026-03-22 16:43:41', 0),
  (@recipe_id, '土豆', '1个', 5, '2026-03-22 16:43:41', '2026-03-22 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好腊肠、菌菇、洋葱、米、土豆，清洗后按需要切块、切片或分装备用。', '', '2026-03-22 16:43:41', '2026-03-22 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-03-22 16:43:41', '2026-03-22 16:43:41', 0),
  (@recipe_id, 3, '加入足量清水，先大火煮开，再转小火慢煮至汤色清亮、食材软嫩。', '', '2026-03-22 16:43:41', '2026-03-22 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-22 16:43:41', '2026-03-22 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '电饭煲版香卤牛肉', '/seed-images/yunyoujun-070.svg', '电饭煲版香卤牛肉是一道适合汤类场景的演示菜谱，食材以牛肉、米为主。 口味标签：卤味。', '简单', 53, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1dR4y1F7H2', 7559, 969, 2041, 0, 1, '2026-03-21 16:43:41', '2026-03-21 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '汤类'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '牛肉', '250g', 1, '2026-03-21 16:43:41', '2026-03-21 16:43:41', 0),
  (@recipe_id, '米', '1杯', 2, '2026-03-21 16:43:41', '2026-03-21 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好牛肉、米，清洗后按需要切块、切片或分装备用。', '', '2026-03-21 16:43:41', '2026-03-21 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-03-21 16:43:41', '2026-03-21 16:43:41', 0),
  (@recipe_id, 3, '加入足量清水，先大火煮开，再转小火慢煮至汤色清亮、食材软嫩。', '', '2026-03-21 16:43:41', '2026-03-21 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-21 16:43:41', '2026-03-21 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '电饭煲叉烧排骨', '/seed-images/yunyoujun-071.svg', '电饭煲叉烧排骨是一道适合汤类场景的演示菜谱，食材以猪肉、洋葱为主。 口味标签：下饭。', '简单', 53, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1Ab4y1p7dw', 37059, 930, 577, 0, 1, '2026-03-20 16:43:41', '2026-03-20 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '汤类'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '猪肉', '250g', 1, '2026-03-20 16:43:41', '2026-03-20 16:43:41', 0),
  (@recipe_id, '洋葱', '半个', 2, '2026-03-20 16:43:41', '2026-03-20 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好猪肉、洋葱，清洗后按需要切块、切片或分装备用。', '', '2026-03-20 16:43:41', '2026-03-20 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-03-20 16:43:41', '2026-03-20 16:43:41', 0),
  (@recipe_id, 3, '加入足量清水，先大火煮开，再转小火慢煮至汤色清亮、食材软嫩。', '', '2026-03-20 16:43:41', '2026-03-20 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-20 16:43:41', '2026-03-20 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '电饭煲版红烧肉', '/seed-images/yunyoujun-072.svg', '电饭煲版红烧肉是一道适合汤类场景的演示菜谱，食材以猪肉为主。', '简单', 51, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1SW411t7AX', 43941, 791, 1450, 0, 1, '2026-03-19 16:43:41', '2026-03-19 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '汤类'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '猪肉', '250g', 1, '2026-03-19 16:43:41', '2026-03-19 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好猪肉，清洗后按需要切块、切片或分装备用。', '', '2026-03-19 16:43:41', '2026-03-19 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-03-19 16:43:41', '2026-03-19 16:43:41', 0),
  (@recipe_id, 3, '加入足量清水，先大火煮开，再转小火慢煮至汤色清亮、食材软嫩。', '', '2026-03-19 16:43:41', '2026-03-19 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-19 16:43:41', '2026-03-19 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '电饭煲版可乐鸡翅', '/seed-images/yunyoujun-073.svg', '电饭煲版可乐鸡翅是一道适合汤类场景的演示菜谱，食材以鸡肉为主。', '简单', 51, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV16J411U79k', 7177, 1436, 2054, 0, 1, '2026-03-18 16:43:41', '2026-03-18 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '汤类'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-03-18 16:43:41', '2026-03-18 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉，清洗后按需要切块、切片或分装备用。', '', '2026-03-18 16:43:41', '2026-03-18 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-03-18 16:43:41', '2026-03-18 16:43:41', 0),
  (@recipe_id, 3, '加入足量清水，先大火煮开，再转小火慢煮至汤色清亮、食材软嫩。', '', '2026-03-18 16:43:41', '2026-03-18 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-18 16:43:41', '2026-03-18 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '蔬菜团子', '/seed-images/yunyoujun-074.svg', '蔬菜团子是一道适合减脂餐场景的演示菜谱，食材以包菜为主。', '简单', 18, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1S44y1P7Qp', 31016, 1635, 2422, 0, 1, '2026-03-17 16:43:41', '2026-03-17 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '减脂餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '包菜', '1份', 1, '2026-03-17 16:43:41', '2026-03-17 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好包菜，清洗后按需要切块、切片或分装备用。', '', '2026-03-17 16:43:41', '2026-03-17 16:43:41', 0),
  (@recipe_id, 2, '用少油少盐方式调味，可加入黑胡椒、柠檬汁提升风味。', '', '2026-03-17 16:43:41', '2026-03-17 16:43:41', 0),
  (@recipe_id, 3, '使用烤箱烤至食材成熟入味。', '', '2026-03-17 16:43:41', '2026-03-17 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-17 16:43:41', '2026-03-17 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅减脂餐', '/seed-images/yunyoujun-075.svg', '空气炸锅减脂餐是一道适合减脂餐场景的演示菜谱，食材以菌菇、虾为主。', '简单', 20, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1CY4y1p7qP', 37510, 1846, 4006, 0, 1, '2026-03-16 16:43:41', '2026-03-16 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '减脂餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '菌菇', '适量', 1, '2026-03-16 16:43:41', '2026-03-16 16:43:41', 0),
  (@recipe_id, '虾', '1份', 2, '2026-03-16 16:43:41', '2026-03-16 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好菌菇、虾，清洗后按需要切块、切片或分装备用。', '', '2026-03-16 16:43:41', '2026-03-16 16:43:41', 0),
  (@recipe_id, 2, '用少油少盐方式调味，可加入黑胡椒、柠檬汁提升风味。', '', '2026-03-16 16:43:41', '2026-03-16 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅炸至食材成熟入味。', '', '2026-03-16 16:43:41', '2026-03-16 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-16 16:43:41', '2026-03-16 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅烤鸡胸肉', '/seed-images/yunyoujun-076.svg', '空气炸锅烤鸡胸肉是一道适合减脂餐场景的演示菜谱，食材以鸡肉为主。', '简单', 18, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1dF411q7of', 45379, 1918, 2410, 0, 1, '2026-03-15 16:43:41', '2026-03-15 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '减脂餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-03-15 16:43:41', '2026-03-15 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉，清洗后按需要切块、切片或分装备用。', '', '2026-03-15 16:43:41', '2026-03-15 16:43:41', 0),
  (@recipe_id, 2, '用少油少盐方式调味，可加入黑胡椒、柠檬汁提升风味。', '', '2026-03-15 16:43:41', '2026-03-15 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅炸至食材成熟入味。', '', '2026-03-15 16:43:41', '2026-03-15 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-15 16:43:41', '2026-03-15 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅炸低卡食材', '/seed-images/yunyoujun-077.svg', '空气炸锅炸低卡食材是一道适合减脂餐场景的演示菜谱，食材以包菜、菌菇为主。', '简单', 20, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1cF411s7QH', 27036, 2495, 3513, 0, 1, '2026-03-14 16:43:41', '2026-03-14 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '减脂餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '包菜', '1份', 1, '2026-03-14 16:43:41', '2026-03-14 16:43:41', 0),
  (@recipe_id, '菌菇', '适量', 2, '2026-03-14 16:43:41', '2026-03-14 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好包菜、菌菇，清洗后按需要切块、切片或分装备用。', '', '2026-03-14 16:43:41', '2026-03-14 16:43:41', 0),
  (@recipe_id, 2, '用少油少盐方式调味，可加入黑胡椒、柠檬汁提升风味。', '', '2026-03-14 16:43:41', '2026-03-14 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅炸至食材成熟入味。', '', '2026-03-14 16:43:41', '2026-03-14 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-14 16:43:41', '2026-03-14 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅炸家常蔬菜', '/seed-images/yunyoujun-078.svg', '空气炸锅炸家常蔬菜是一道适合减脂餐场景的演示菜谱，食材以花菜、豆腐、鸡肉、菌菇为主。', '简单', 24, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1FU4y1Z7T1', 31447, 1997, 384, 0, 1, '2026-03-13 16:43:41', '2026-03-13 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '减脂餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '花菜', '1份', 1, '2026-03-13 16:43:41', '2026-03-13 16:43:41', 0),
  (@recipe_id, '豆腐', '1份', 2, '2026-03-13 16:43:41', '2026-03-13 16:43:41', 0),
  (@recipe_id, '鸡肉', '300g', 3, '2026-03-13 16:43:41', '2026-03-13 16:43:41', 0),
  (@recipe_id, '菌菇', '适量', 4, '2026-03-13 16:43:41', '2026-03-13 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好花菜、豆腐、鸡肉、菌菇，清洗后按需要切块、切片或分装备用。', '', '2026-03-13 16:43:41', '2026-03-13 16:43:41', 0),
  (@recipe_id, 2, '用少油少盐方式调味，可加入黑胡椒、柠檬汁提升风味。', '', '2026-03-13 16:43:41', '2026-03-13 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅炸至食材成熟入味。', '', '2026-03-13 16:43:41', '2026-03-13 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-13 16:43:41', '2026-03-13 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅炸蔬菜', '/seed-images/yunyoujun-079.svg', '空气炸锅炸蔬菜是一道适合减脂餐场景的演示菜谱，食材以鸡蛋、黄瓜为主。', '简单', 20, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1qr4y1p7BX', 31132, 1966, 5173, 0, 1, '2026-03-12 16:43:41', '2026-03-12 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '减脂餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡蛋', '2个', 1, '2026-03-12 16:43:41', '2026-03-12 16:43:41', 0),
  (@recipe_id, '黄瓜', '1份', 2, '2026-03-12 16:43:41', '2026-03-12 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡蛋、黄瓜，清洗后按需要切块、切片或分装备用。', '', '2026-03-12 16:43:41', '2026-03-12 16:43:41', 0),
  (@recipe_id, 2, '用少油少盐方式调味，可加入黑胡椒、柠檬汁提升风味。', '', '2026-03-12 16:43:41', '2026-03-12 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅炸至食材成熟入味。', '', '2026-03-12 16:43:41', '2026-03-12 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-12 16:43:41', '2026-03-12 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '微波炉版番茄焖饭', '/seed-images/yunyoujun-080.svg', '微波炉版番茄焖饭是一道适合减脂餐场景的演示菜谱，食材以香肠、番茄为主。 口味标签：减脂餐。', '简单', 20, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV193411W7nb', 46402, 913, 1092, 0, 1, '2026-03-11 16:43:41', '2026-03-11 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '减脂餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '香肠', '1份', 1, '2026-03-11 16:43:41', '2026-03-11 16:43:41', 0),
  (@recipe_id, '番茄', '2个', 2, '2026-03-11 16:43:41', '2026-03-11 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好香肠、番茄，清洗后按需要切块、切片或分装备用。', '', '2026-03-11 16:43:41', '2026-03-11 16:43:41', 0),
  (@recipe_id, 2, '用少油少盐方式调味，可加入黑胡椒、柠檬汁提升风味。', '', '2026-03-11 16:43:41', '2026-03-11 16:43:41', 0),
  (@recipe_id, 3, '使用微波炉微波加热至食材成熟入味。', '', '2026-03-11 16:43:41', '2026-03-11 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-11 16:43:41', '2026-03-11 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '微波炉版菌菇鸡肉焖饭', '/seed-images/yunyoujun-081.svg', '微波炉版菌菇鸡肉焖饭是一道适合减脂餐场景的演示菜谱，食材以鸡肉、胡萝卜、菌菇、米为主。 口味标签：减脂餐。', '简单', 24, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV193411W7nb', 40440, 2064, 6513, 0, 1, '2026-03-10 16:43:41', '2026-03-10 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '减脂餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-03-10 16:43:41', '2026-03-10 16:43:41', 0),
  (@recipe_id, '胡萝卜', '1份', 2, '2026-03-10 16:43:41', '2026-03-10 16:43:41', 0),
  (@recipe_id, '菌菇', '适量', 3, '2026-03-10 16:43:41', '2026-03-10 16:43:41', 0),
  (@recipe_id, '米', '1杯', 4, '2026-03-10 16:43:41', '2026-03-10 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉、胡萝卜、菌菇、米，清洗后按需要切块、切片或分装备用。', '', '2026-03-10 16:43:41', '2026-03-10 16:43:41', 0),
  (@recipe_id, 2, '用少油少盐方式调味，可加入黑胡椒、柠檬汁提升风味。', '', '2026-03-10 16:43:41', '2026-03-10 16:43:41', 0),
  (@recipe_id, 3, '使用微波炉微波加热至食材成熟入味。', '', '2026-03-10 16:43:41', '2026-03-10 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-10 16:43:41', '2026-03-10 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '微波炉版蔬菜脆片', '/seed-images/yunyoujun-082.svg', '微波炉版蔬菜脆片是一道适合减脂餐场景的演示菜谱，食材以土豆、西葫芦、黄瓜为主。 口味标签：杂烩。', '简单', 22, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1n441187r3', 23455, 210, 837, 0, 1, '2026-03-09 16:43:41', '2026-03-09 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '减脂餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '土豆', '1个', 1, '2026-03-09 16:43:41', '2026-03-09 16:43:41', 0),
  (@recipe_id, '西葫芦', '1份', 2, '2026-03-09 16:43:41', '2026-03-09 16:43:41', 0),
  (@recipe_id, '黄瓜', '适量', 3, '2026-03-09 16:43:41', '2026-03-09 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好土豆、西葫芦、黄瓜，清洗后按需要切块、切片或分装备用。', '', '2026-03-09 16:43:41', '2026-03-09 16:43:41', 0),
  (@recipe_id, 2, '用少油少盐方式调味，可加入黑胡椒、柠檬汁提升风味。', '', '2026-03-09 16:43:41', '2026-03-09 16:43:41', 0),
  (@recipe_id, 3, '使用微波炉微波加热至食材成熟入味。', '', '2026-03-09 16:43:41', '2026-03-09 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-09 16:43:41', '2026-03-09 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '微波炉版鸡胸肉脆片', '/seed-images/yunyoujun-083.svg', '微波炉版鸡胸肉脆片是一道适合减脂餐场景的演示菜谱，食材以鸡肉为主。', '简单', 18, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1xu41197tU', 45984, 1849, 6630, 0, 1, '2026-03-08 16:43:41', '2026-03-08 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '减脂餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-03-08 16:43:41', '2026-03-08 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉，清洗后按需要切块、切片或分装备用。', '', '2026-03-08 16:43:41', '2026-03-08 16:43:41', 0),
  (@recipe_id, 2, '用少油少盐方式调味，可加入黑胡椒、柠檬汁提升风味。', '', '2026-03-08 16:43:41', '2026-03-08 16:43:41', 0),
  (@recipe_id, 3, '使用微波炉至食材成熟入味。', '', '2026-03-08 16:43:41', '2026-03-08 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-08 16:43:41', '2026-03-08 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '微波炉版鸡胸肉丸', '/seed-images/yunyoujun-084.svg', '微波炉版鸡胸肉丸是一道适合减脂餐场景的演示菜谱，食材以鸡肉为主。', '简单', 18, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1xu41197tU', 9222, 1274, 6410, 0, 1, '2026-03-07 16:43:41', '2026-03-07 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '减脂餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-03-07 16:43:41', '2026-03-07 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉，清洗后按需要切块、切片或分装备用。', '', '2026-03-07 16:43:41', '2026-03-07 16:43:41', 0),
  (@recipe_id, 2, '用少油少盐方式调味，可加入黑胡椒、柠檬汁提升风味。', '', '2026-03-07 16:43:41', '2026-03-07 16:43:41', 0),
  (@recipe_id, 3, '使用微波炉至食材成熟入味。', '', '2026-03-07 16:43:41', '2026-03-07 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-07 16:43:41', '2026-03-07 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '微波炉版日式嫩蒸鸡胸肉', '/seed-images/yunyoujun-085.svg', '微波炉版日式嫩蒸鸡胸肉是一道适合减脂餐场景的演示菜谱，食材以鸡肉为主。', '简单', 18, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1xu41197tU', 44695, 791, 4116, 0, 1, '2026-03-06 16:43:41', '2026-03-06 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '减脂餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-03-06 16:43:41', '2026-03-06 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉，清洗后按需要切块、切片或分装备用。', '', '2026-03-06 16:43:41', '2026-03-06 16:43:41', 0),
  (@recipe_id, 2, '用少油少盐方式调味，可加入黑胡椒、柠檬汁提升风味。', '', '2026-03-06 16:43:41', '2026-03-06 16:43:41', 0),
  (@recipe_id, 3, '使用微波炉至食材成熟入味。', '', '2026-03-06 16:43:41', '2026-03-06 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-06 16:43:41', '2026-03-06 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '空气炸锅辣子鸡', '/seed-images/yunyoujun-086.svg', '空气炸锅辣子鸡是一道适合川菜场景的演示菜谱，食材以鸡肉为主。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1yL4y1L71E', 31973, 1181, 3255, 0, 1, '2026-03-05 16:43:41', '2026-03-05 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '川菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-03-05 16:43:41', '2026-03-05 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉，清洗后按需要切块、切片或分装备用。', '', '2026-03-05 16:43:41', '2026-03-05 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-03-05 16:43:41', '2026-03-05 16:43:41', 0),
  (@recipe_id, 3, '使用空气炸锅炸至食材成熟入味。', '', '2026-03-05 16:43:41', '2026-03-05 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-05 16:43:41', '2026-03-05 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '微波炉火锅', '/seed-images/yunyoujun-087.svg', '微波炉火锅是一道适合川菜场景的演示菜谱，食材以菌菇、牛肉、方便面、虾为主。 口味标签：杂烩。', '简单', 44, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1o34y1R7BC', 24435, 1463, 4409, 0, 1, '2026-03-04 16:43:41', '2026-03-04 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '川菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '菌菇', '适量', 1, '2026-03-04 16:43:41', '2026-03-04 16:43:41', 0),
  (@recipe_id, '牛肉', '250g', 2, '2026-03-04 16:43:41', '2026-03-04 16:43:41', 0),
  (@recipe_id, '方便面', '适量', 3, '2026-03-04 16:43:41', '2026-03-04 16:43:41', 0),
  (@recipe_id, '虾', '适量', 4, '2026-03-04 16:43:41', '2026-03-04 16:43:41', 0),
  (@recipe_id, '鸡肉', '300g', 5, '2026-03-04 16:43:41', '2026-03-04 16:43:41', 0),
  (@recipe_id, '猪肉', '250g', 6, '2026-03-04 16:43:41', '2026-03-04 16:43:41', 0),
  (@recipe_id, '午餐肉', '适量', 7, '2026-03-04 16:43:41', '2026-03-04 16:43:41', 0),
  (@recipe_id, '莴笋', '适量', 8, '2026-03-04 16:43:41', '2026-03-04 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好菌菇、牛肉、方便面、虾、鸡肉，清洗后按需要切块、切片或分装备用。', '', '2026-03-04 16:43:41', '2026-03-04 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-03-04 16:43:41', '2026-03-04 16:43:41', 0),
  (@recipe_id, 3, '使用微波炉微波加热至食材成熟入味。', '', '2026-03-04 16:43:41', '2026-03-04 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-04 16:43:41', '2026-03-04 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '微波炉版麻辣排骨', '/seed-images/yunyoujun-088.svg', '微波炉版麻辣排骨是一道适合川菜场景的演示菜谱，食材以猪肉为主。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1c44y1T79A', 22438, 906, 6497, 0, 1, '2026-03-03 16:43:41', '2026-03-03 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '川菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '猪肉', '250g', 1, '2026-03-03 16:43:41', '2026-03-03 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好猪肉，清洗后按需要切块、切片或分装备用。', '', '2026-03-03 16:43:41', '2026-03-03 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-03-03 16:43:41', '2026-03-03 16:43:41', 0),
  (@recipe_id, 3, '使用微波炉微波加热至食材成熟入味。', '', '2026-03-03 16:43:41', '2026-03-03 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-03 16:43:41', '2026-03-03 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '微波炉版鱼香肉块', '/seed-images/yunyoujun-089.svg', '微波炉版鱼香肉块是一道适合川菜场景的演示菜谱，食材以胡萝卜、鸡肉为主。', '简单', 28, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1qt411X7Do', 37498, 1186, 5011, 0, 1, '2026-03-02 16:43:41', '2026-03-02 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '川菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '胡萝卜', '1份', 1, '2026-03-02 16:43:41', '2026-03-02 16:43:41', 0),
  (@recipe_id, '鸡肉', '300g', 2, '2026-03-02 16:43:41', '2026-03-02 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好胡萝卜、鸡肉，清洗后按需要切块、切片或分装备用。', '', '2026-03-02 16:43:41', '2026-03-02 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-03-02 16:43:41', '2026-03-02 16:43:41', 0),
  (@recipe_id, 3, '使用微波炉至食材成熟入味。', '', '2026-03-02 16:43:41', '2026-03-02 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-02 16:43:41', '2026-03-02 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '水煮肉片', '/seed-images/yunyoujun-090.svg', '水煮肉片是一道适合川菜场景的演示菜谱，食材以猪肉、芹菜、莴笋为主。 口味标签：川菜。', '简单', 30, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1ZZ4y1379N', 22883, 1562, 5335, 0, 1, '2026-03-01 16:43:41', '2026-03-01 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '川菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '猪肉', '250g', 1, '2026-03-01 16:43:41', '2026-03-01 16:43:41', 0),
  (@recipe_id, '芹菜', '1份', 2, '2026-03-01 16:43:41', '2026-03-01 16:43:41', 0),
  (@recipe_id, '莴笋', '适量', 3, '2026-03-01 16:43:41', '2026-03-01 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好猪肉、芹菜、莴笋，清洗后按需要切块、切片或分装备用。', '', '2026-03-01 16:43:41', '2026-03-01 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-03-01 16:43:41', '2026-03-01 16:43:41', 0),
  (@recipe_id, 3, '使用一口大锅炒至食材成熟入味。', '', '2026-03-01 16:43:41', '2026-03-01 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-03-01 16:43:41', '2026-03-01 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '麻辣土豆片', '/seed-images/yunyoujun-091.svg', '麻辣土豆片是一道适合川菜场景的演示菜谱，食材以土豆为主。 口味标签：单一食材。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1fY41187Xo', 15768, 69, 2808, 0, 1, '2026-02-28 16:43:41', '2026-02-28 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '川菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '土豆', '1个', 1, '2026-02-28 16:43:41', '2026-02-28 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好土豆，清洗后按需要切块、切片或分装备用。', '', '2026-02-28 16:43:41', '2026-02-28 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-02-28 16:43:41', '2026-02-28 16:43:41', 0),
  (@recipe_id, 3, '使用一口大锅煮至食材成熟入味。', '', '2026-02-28 16:43:41', '2026-02-28 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-02-28 16:43:41', '2026-02-28 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '麻辣凉拌包菜', '/seed-images/yunyoujun-092.svg', '麻辣凉拌包菜是一道适合川菜场景的演示菜谱，食材以包菜为主。 口味标签：下饭。', '简单', 26, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV18f4y1e7cy', 38781, 1000, 6112, 0, 1, '2026-02-27 16:43:41', '2026-02-27 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '川菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '包菜', '1份', 1, '2026-02-27 16:43:41', '2026-02-27 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好包菜，清洗后按需要切块、切片或分装备用。', '', '2026-02-27 16:43:41', '2026-02-27 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-02-27 16:43:41', '2026-02-27 16:43:41', 0),
  (@recipe_id, 3, '使用一口大锅拌至食材成熟入味。', '', '2026-02-27 16:43:41', '2026-02-27 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-02-27 16:43:41', '2026-02-27 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '番茄酸汤火锅', '/seed-images/yunyoujun-093.svg', '番茄酸汤火锅是一道适合川菜场景的演示菜谱，食材以番茄、胡萝卜、菌菇、洋葱为主。 口味标签：杂烩。', '困难', 79, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1yz4y1C7Qu', 31739, 255, 5588, 0, 1, '2026-02-26 16:43:41', '2026-02-26 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '川菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '番茄', '2个', 1, '2026-02-26 16:43:41', '2026-02-26 16:43:41', 0),
  (@recipe_id, '胡萝卜', '1份', 2, '2026-02-26 16:43:41', '2026-02-26 16:43:41', 0),
  (@recipe_id, '菌菇', '适量', 3, '2026-02-26 16:43:41', '2026-02-26 16:43:41', 0),
  (@recipe_id, '洋葱', '半个', 4, '2026-02-26 16:43:41', '2026-02-26 16:43:41', 0),
  (@recipe_id, '豆腐', '适量', 5, '2026-02-26 16:43:41', '2026-02-26 16:43:41', 0),
  (@recipe_id, '面食', '1份', 6, '2026-02-26 16:43:41', '2026-02-26 16:43:41', 0),
  (@recipe_id, '白萝卜', '适量', 7, '2026-02-26 16:43:41', '2026-02-26 16:43:41', 0),
  (@recipe_id, '土豆', '1个', 8, '2026-02-26 16:43:41', '2026-02-26 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好番茄、胡萝卜、菌菇、洋葱、豆腐，清洗后按需要切块、切片或分装备用。', '', '2026-02-26 16:43:41', '2026-02-26 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-02-26 16:43:41', '2026-02-26 16:43:41', 0),
  (@recipe_id, 3, '使用一口大锅至食材成熟入味。', '', '2026-02-26 16:43:41', '2026-02-26 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-02-26 16:43:41', '2026-02-26 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '骨头汤火锅锅底做法（全鸡版）', '/seed-images/yunyoujun-094.svg', '骨头汤火锅锅底做法（全鸡版）是一道适合川菜场景的演示菜谱，食材以骨头、土豆、胡萝卜、花菜为主。 口味标签：杂烩。', '困难', 90, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1bi4y187ro', 45329, 2673, 6649, 0, 1, '2026-02-25 16:43:41', '2026-02-25 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '川菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '骨头', '1份', 1, '2026-02-25 16:43:41', '2026-02-25 16:43:41', 0),
  (@recipe_id, '土豆', '1个', 2, '2026-02-25 16:43:41', '2026-02-25 16:43:41', 0),
  (@recipe_id, '胡萝卜', '适量', 3, '2026-02-25 16:43:41', '2026-02-25 16:43:41', 0),
  (@recipe_id, '花菜', '适量', 4, '2026-02-25 16:43:41', '2026-02-25 16:43:41', 0),
  (@recipe_id, '白萝卜', '适量', 5, '2026-02-25 16:43:41', '2026-02-25 16:43:41', 0),
  (@recipe_id, '西葫芦', '适量', 6, '2026-02-25 16:43:41', '2026-02-25 16:43:41', 0),
  (@recipe_id, '芹菜', '适量', 7, '2026-02-25 16:43:41', '2026-02-25 16:43:41', 0),
  (@recipe_id, '菌菇', '适量', 8, '2026-02-25 16:43:41', '2026-02-25 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好骨头、土豆、胡萝卜、花菜、白萝卜，清洗后按需要切块、切片或分装备用。', '', '2026-02-25 16:43:41', '2026-02-25 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-02-25 16:43:41', '2026-02-25 16:43:41', 0),
  (@recipe_id, 3, '使用一口大锅至食材成熟入味。', '', '2026-02-25 16:43:41', '2026-02-25 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-02-25 16:43:41', '2026-02-25 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '麻辣豆腐包', '/seed-images/yunyoujun-095.svg', '麻辣豆腐包是一道适合川菜场景的演示菜谱，食材以面食、豆腐为主。 口味标签：早饭。', '简单', 28, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1y64y1U7jY', 21988, 312, 3491, 0, 1, '2026-02-24 16:43:41', '2026-02-24 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '川菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '面食', '1份', 1, '2026-02-24 16:43:41', '2026-02-24 16:43:41', 0),
  (@recipe_id, '豆腐', '1份', 2, '2026-02-24 16:43:41', '2026-02-24 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好面食、豆腐，清洗后按需要切块、切片或分装备用。', '', '2026-02-24 16:43:41', '2026-02-24 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-02-24 16:43:41', '2026-02-24 16:43:41', 0),
  (@recipe_id, 3, '使用一口大锅蒸至食材成熟入味。', '', '2026-02-24 16:43:41', '2026-02-24 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-02-24 16:43:41', '2026-02-24 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '白菜卷火锅', '/seed-images/yunyoujun-096.svg', '白菜卷火锅是一道适合川菜场景的演示菜谱，食材以白菜、菌菇、胡萝卜、香肠为主。', '简单', 32, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1wY411n7Vk', 18173, 320, 268, 0, 1, '2026-02-23 16:43:41', '2026-02-23 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_1' AND c.`name` = '川菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '白菜', '1份', 1, '2026-02-23 16:43:41', '2026-02-23 16:43:41', 0),
  (@recipe_id, '菌菇', '适量', 2, '2026-02-23 16:43:41', '2026-02-23 16:43:41', 0),
  (@recipe_id, '胡萝卜', '适量', 3, '2026-02-23 16:43:41', '2026-02-23 16:43:41', 0),
  (@recipe_id, '香肠', '适量', 4, '2026-02-23 16:43:41', '2026-02-23 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好白菜、菌菇、胡萝卜、香肠，清洗后按需要切块、切片或分装备用。', '', '2026-02-23 16:43:41', '2026-02-23 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-02-23 16:43:41', '2026-02-23 16:43:41', 0),
  (@recipe_id, 3, '使用一口大锅至食材成熟入味。', '', '2026-02-23 16:43:41', '2026-02-23 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-02-23 16:43:41', '2026-02-23 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '川味泡面', '/seed-images/yunyoujun-097.svg', '川味泡面是一道适合川菜场景的演示菜谱，食材以方便面、鸡蛋为主。', '简单', 28, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1G7411f7FA', 3005, 42, 459, 0, 1, '2026-02-22 16:43:41', '2026-02-22 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_2' AND c.`name` = '川菜'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '方便面', '1份', 1, '2026-02-22 16:43:41', '2026-02-22 16:43:41', 0),
  (@recipe_id, '鸡蛋', '2个', 2, '2026-02-22 16:43:41', '2026-02-22 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好方便面、鸡蛋，清洗后按需要切块、切片或分装备用。', '', '2026-02-22 16:43:41', '2026-02-22 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-02-22 16:43:41', '2026-02-22 16:43:41', 0),
  (@recipe_id, 3, '使用一口大锅煮至食材成熟入味。', '', '2026-02-22 16:43:41', '2026-02-22 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-02-22 16:43:41', '2026-02-22 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '电饭煲卤菜（开店级别）', '/seed-images/yunyoujun-098.svg', '电饭煲卤菜（开店级别）是一道适合午餐场景的演示菜谱，食材以鸡肉、鸡蛋、米为主。 口味标签：小吃。', '简单', 30, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1ZA411E7KT', 1733, 2186, 6515, 0, 1, '2026-02-21 16:43:41', '2026-02-21 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_3' AND c.`name` = '午餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-02-21 16:43:41', '2026-02-21 16:43:41', 0),
  (@recipe_id, '鸡蛋', '2个', 2, '2026-02-21 16:43:41', '2026-02-21 16:43:41', 0),
  (@recipe_id, '米', '1杯', 3, '2026-02-21 16:43:41', '2026-02-21 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉、鸡蛋、米，清洗后按需要切块、切片或分装备用。', '', '2026-02-21 16:43:41', '2026-02-21 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-02-21 16:43:41', '2026-02-21 16:43:41', 0),
  (@recipe_id, 3, '使用电饭煲至食材成熟入味。', '', '2026-02-21 16:43:41', '2026-02-21 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-02-21 16:43:41', '2026-02-21 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '电饭煲卤肉蛋豆腐', '/seed-images/yunyoujun-099.svg', '电饭煲卤肉蛋豆腐是一道适合午餐场景的演示菜谱，食材以鸡肉、鸡蛋、豆腐、米为主。 口味标签：小吃。', '简单', 32, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV1aM4y1L7QR', 10095, 2570, 1605, 0, 1, '2026-02-20 16:43:41', '2026-02-20 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_4' AND c.`name` = '午餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '鸡肉', '300g', 1, '2026-02-20 16:43:41', '2026-02-20 16:43:41', 0),
  (@recipe_id, '鸡蛋', '2个', 2, '2026-02-20 16:43:41', '2026-02-20 16:43:41', 0),
  (@recipe_id, '豆腐', '适量', 3, '2026-02-20 16:43:41', '2026-02-20 16:43:41', 0),
  (@recipe_id, '米', '1杯', 4, '2026-02-20 16:43:41', '2026-02-20 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好鸡肉、鸡蛋、豆腐、米，清洗后按需要切块、切片或分装备用。', '', '2026-02-20 16:43:41', '2026-02-20 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-02-20 16:43:41', '2026-02-20 16:43:41', 0),
  (@recipe_id, 3, '使用电饭煲至食材成熟入味。', '', '2026-02-20 16:43:41', '2026-02-20 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-02-20 16:43:41', '2026-02-20 16:43:41', 0);

INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, '电饭煲版罗宋汤', '/seed-images/yunyoujun-100.svg', '电饭煲版罗宋汤是一道适合午餐场景的演示菜谱，食材以牛肉、番茄、洋葱、芹菜为主。 口味标签：杂烩。', '简单', 40, 'source:YunYouJun/cook seed:v1; 原始条目来自 YunYouJun/cook; BV=BV16Q4y1m7nU', 26286, 2772, 5541, 0, 1, '2026-02-19 16:43:41', '2026-02-19 16:43:41', 0
FROM `user` u JOIN `category` c
WHERE u.`username` = 'seed_author_5' AND c.`name` = '午餐'
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();

INSERT INTO `recipe_ingredient` (`recipe_id`, `name`, `amount`, `sort`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, '牛肉', '250g', 1, '2026-02-19 16:43:41', '2026-02-19 16:43:41', 0),
  (@recipe_id, '番茄', '2个', 2, '2026-02-19 16:43:41', '2026-02-19 16:43:41', 0),
  (@recipe_id, '洋葱', '半个', 3, '2026-02-19 16:43:41', '2026-02-19 16:43:41', 0),
  (@recipe_id, '芹菜', '适量', 4, '2026-02-19 16:43:41', '2026-02-19 16:43:41', 0),
  (@recipe_id, '胡萝卜', '适量', 5, '2026-02-19 16:43:41', '2026-02-19 16:43:41', 0),
  (@recipe_id, '土豆', '1个', 6, '2026-02-19 16:43:41', '2026-02-19 16:43:41', 0),
  (@recipe_id, '包菜', '适量', 7, '2026-02-19 16:43:41', '2026-02-19 16:43:41', 0),
  (@recipe_id, '香肠', '适量', 8, '2026-02-19 16:43:41', '2026-02-19 16:43:41', 0);

INSERT INTO `recipe_step` (`recipe_id`, `step_no`, `content`, `image`, `create_time`, `update_time`, `deleted`) VALUES
  (@recipe_id, 1, '准备好牛肉、番茄、洋葱、芹菜、胡萝卜，清洗后按需要切块、切片或分装备用。', '', '2026-02-19 16:43:41', '2026-02-19 16:43:41', 0),
  (@recipe_id, 2, '加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。', '', '2026-02-19 16:43:41', '2026-02-19 16:43:41', 0),
  (@recipe_id, 3, '使用电饭煲至食材成熟入味。', '', '2026-02-19 16:43:41', '2026-02-19 16:43:41', 0),
  (@recipe_id, 4, '出锅前尝味，撒上葱花或香菜点缀，趁热享用。', '', '2026-02-19 16:43:41', '2026-02-19 16:43:41', 0);
