# 菜谱分享与管理系统

这是根据 `菜谱管理系统需求说明书_v_1.md` 和 `菜谱管理系统数据库设计_v_1.md` 完成的前后端分离项目实现。

当前交付版本为了保证在本机无 Maven/Gradle 的环境下可直接运行，后端采用零依赖 Node.js REST 服务，接口路径、数据模型、统一返回格式和权限规则按需求文档实现。`docs/schema.sql` 提供了对应 MySQL 表结构，后续可平滑迁移到 Spring Boot + MyBatis-Plus。

## 目录

```text
recipe-system-backend/     后端 REST API 与 JSON 持久化
recipe-system-frontend/    前端单页应用
docs/schema.sql            MySQL 建表 SQL
```

## 启动

```bash
cd recipe-system-backend
npm start
```

访问：

```text
http://localhost:8080
```

演示账号：

```text
管理员：admin / admin123
普通用户：demo / 123456
```

## 已实现功能

- 用户注册、登录、退出、当前用户信息、资料修改、密码修改
- 菜谱发布、列表、详情、关键词搜索、分类筛选、编辑、逻辑删除
- 食材清单和制作步骤随菜谱保存
- 收藏、取消收藏、我的收藏
- 评论发布、查看、删除
- 后台统计、用户启用/禁用、菜谱上下架、分类新增/删除
- 统一响应格式：`{ code, message, data }`
- Token 鉴权和管理员权限控制

## 后端接口

核心接口保持需求说明书路径：

```text
POST   /api/user/register
POST   /api/user/login
GET    /api/user/current
PUT    /api/user/profile
PUT    /api/user/password

GET    /api/category/list

POST   /api/recipe
GET    /api/recipe/list
GET    /api/recipe/{id}
PUT    /api/recipe/{id}
DELETE /api/recipe/{id}
GET    /api/recipe/my

POST   /api/favorite/{recipeId}
DELETE /api/favorite/{recipeId}
GET    /api/favorite/my

POST   /api/comment
GET    /api/comment/recipe/{recipeId}
DELETE /api/comment/{id}

GET    /api/admin/stat
GET    /api/admin/user/list
PUT    /api/admin/user/{id}/disable
PUT    /api/admin/user/{id}/enable
GET    /api/admin/recipe/list
PUT    /api/admin/recipe/{id}/disable
POST   /api/admin/category
PUT    /api/admin/category/{id}
DELETE /api/admin/category/{id}
DELETE /api/admin/comment/{id}
```

## 数据

首次启动后端会自动生成：

```text
recipe-system-backend/data/db.json
```

删除该文件后重新启动可恢复种子数据。
