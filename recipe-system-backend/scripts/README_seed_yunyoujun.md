# 食光菜谱演示种子数据

数据源：YunYouJun/cook，GitHub: https://github.com/YunYouJun/cook ，License: MIT。

本项目只使用该仓库的静态 `recipe.csv` 生成约 100 条演示数据，不做实时爬虫，不导入全量数据。封面图由脚本生成到本项目静态资源目录，页面通过 `/seed-images/*.svg` 访问，不热链外部图片。

## 生成 SQL 和封面

在 `recipe-system-backend` 目录执行：

```powershell
python scripts/import_yunyoujun_cook_seed.py
```

脚本会生成：

- `outputs/seed/yunyoujun_seed.sql`
- `src/main/resources/static/seed-images/yunyoujun-001.svg` 至 `yunyoujun-100.svg`

如果本地没有源 CSV，脚本会从 `https://raw.githubusercontent.com/YunYouJun/cook/main/app/data/recipe.csv` 下载一份到 `../tools/yunyoujun-cook/app/data/recipe.csv`。

## 导入 MySQL

方式一：手动执行 SQL：

```powershell
mysql -h localhost -P 3306 -u root -p recipe_system < outputs/seed/yunyoujun_seed.sql
```

方式二：安装 PyMySQL 后让脚本直接执行：

```powershell
python -m pip install pymysql
python scripts/import_yunyoujun_cook_seed.py --execute
```

可通过环境变量或参数覆盖数据库连接：`MYSQL_HOST`、`MYSQL_PORT`、`MYSQL_DATABASE`、`MYSQL_USERNAME`、`MYSQL_PASSWORD`。

## 页面验证

导入后启动后端和前端，检查：

- 首页推荐是否显示种子菜谱和本地封面。
- 菜谱广场是否有约 100 条演示菜谱。
- 分类筛选是否覆盖：家常菜、早餐、午餐、晚餐、甜品、汤类、减脂餐、川菜。
- 关键词搜索是否能命中菜名、简介或食材。
- 菜谱详情页是否显示封面、简介、食材、步骤、时间、难度、作者、浏览量、收藏量、点赞量。
