# 食光菜谱系统 (Shiguang Recipe System)

> 基于 Vue 3 + Spring Boot 3 + MyBatis-Plus + MySQL 的全栈菜谱管理系统，支持菜谱浏览、发布、收藏和评论功能。

---

## 项目简介

本系统是一个菜谱分享与管理平台，用户可以：

- 浏览最新和热门菜谱
- 根据分类快速查找菜谱
- 查看菜谱详情，包括食材和制作步骤
- 发布自己的菜谱
- 收藏喜欢的菜谱
- 评论与互动

系统分为前端和后端两部分：

- **前端**：Vue 3 + Element Plus + Pinia + Vue Router
- **后端**：Spring Boot 3 + MyBatis-Plus + Spring Security Crypto + JWT
- **数据库**：MySQL 8.4

---

## 技术栈

| 层级 | 技术 | 版本 |
| --- | --- | --- |
| 前端框架 | Vue 3 | ^3.5.13 |
| 构建工具 | Vite | ^6.0.7 |
| UI 组件库 | Element Plus | ^2.9.1 |
| 状态管理 | Pinia | ^2.3.0 |
| 路由 | Vue Router | ^4.5.0 |
| HTTP 客户端 | Axios | ^1.7.9 |
| 后端框架 | Spring Boot | 3.3.7 |
| ORM | MyBatis-Plus | 3.5.9 |
| 安全 | Spring Security Crypto + JWT (jjwt 0.12.6) | - |
| API 文档 | SpringDoc OpenAPI | 2.6.0 |
| 数据库 | MySQL | 8.4 |

---

## 项目结构

```
recipe-system-backend/              后端
├── src/main/java/com/example/recipe/
│   ├── config/                    配置（MyBatis-Plus、Web、JWT 拦截器、数据初始化）
│   ├── controller/                REST 控制器
│   ├── dto/                       请求 DTO
│   ├── entity/                    数据库实体
│   ├── mapper/                    MyBatis-Plus Mapper
│   ├── service/                   业务接口
│   ├── service/impl/              业务实现
│   ├── vo/                        响应 VO
│   ├── common/                    通用类（Result、PageResult）
│   ├── context/                   上下文（LoginUser、UserContext）
│   ├── exception/                 异常处理
│   └── util/                      工具类（JwtUtil）
├── src/main/resources/
│   └── application.yml            应用配置
└── pom.xml                        Maven 依赖

recipe-system-frontend/             前端
├── src/
│   ├── api/                       API 接口封装
│   ├── components/                公共组件
│   ├── router/                    路由配置
│   ├── store/                     Pinia 状态管理
│   ├── utils/                     Axios 封装
│   └── views/                     页面组件
├── index.html
├── package.json
└── vite.config.js                 Vite 配置（含 /api 代理）

docs/
└── schema.sql                     数据库建表脚本（含初始化数据）
```

---

## 快速开始

### 1. 数据库

执行 `docs/schema.sql` 创建数据库和表：

```sql
source docs/schema.sql;
```

或手动创建：

```sql
CREATE DATABASE recipe_system
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;
```

### 2. 后端

```bash
cd recipe-system-backend
mvn spring-boot:run
```

后端启动后访问：`http://localhost:8080`

首次启动会自动初始化管理员账号和菜谱分类。

### 3. 前端

```bash
cd recipe-system-frontend
npm install
npm run dev
```

前端开发服务：`http://localhost:5173`，自动代理 `/api` 到后端 `8080`。

---

## 演示账号

| 角色 | 用户名 | 密码 |
| --- | --- | --- |
| 管理员 | admin | admin123 |
| 普通用户 | 自行注册 | - |

---

## 数据库表结构

| 表名 | 说明 |
| --- | --- |
| `user` | 用户表 |
| `category` | 菜谱分类表 |
| `recipe` | 菜谱表 |
| `recipe_ingredient` | 菜谱食材表 |
| `recipe_step` | 菜谱步骤表 |
| `favorite` | 收藏表 |
| `comment` | 评论表 |

---

## API 接口

### 用户

| 方法 | 路径 | 说明 | 认证 |
| --- | --- | --- | --- |
| POST | `/api/user/register` | 注册 | - |
| POST | `/api/user/login` | 登录 | - |
| GET | `/api/user/current` | 当前用户信息 | Token |
| PUT | `/api/user/profile` | 修改个人资料 | Token |
| PUT | `/api/user/password` | 修改密码 | Token |

### 菜谱

| 方法 | 路径 | 说明 | 认证 |
| --- | --- | --- | --- |
| GET | `/api/recipe/list` | 菜谱列表 | - |
| GET | `/api/recipe/{id}` | 菜谱详情 | - |
| POST | `/api/recipe` | 发布菜谱 | Token |
| PUT | `/api/recipe/{id}` | 编辑菜谱 | Token |
| DELETE | `/api/recipe/{id}` | 删除菜谱 | Token |
| GET | `/api/recipe/my` | 我的菜谱 | Token |

### 分类

| 方法 | 路径 | 说明 | 认证 |
| --- | --- | --- | --- |
| GET | `/api/category/list` | 分类列表 | - |

### 收藏

| 方法 | 路径 | 说明 | 认证 |
| --- | --- | --- | --- |
| POST | `/api/favorite/{recipeId}` | 收藏 | Token |
| DELETE | `/api/favorite/{recipeId}` | 取消收藏 | Token |
| GET | `/api/favorite/my` | 我的收藏 | Token |

### 评论

| 方法 | 路径 | 说明 | 认证 |
| --- | --- | --- | --- |
| POST | `/api/comment` | 发表评论 | Token |
| GET | `/api/comment/recipe/{recipeId}` | 菜谱评论 | - |
| DELETE | `/api/comment/{id}` | 删除评论 | Token |

### 管理员

| 方法 | 路径 | 说明 |
| --- | --- | --- |
| GET | `/api/admin/stat` | 统计信息 |
| GET | `/api/admin/user/list` | 用户列表 |
| PUT | `/api/admin/user/{id}/enable` | 启用用户 |
| PUT | `/api/admin/user/{id}/disable` | 禁用用户 |
| GET | `/api/admin/recipe/list` | 菜谱管理列表 |
| PUT | `/api/admin/recipe/{id}/disable` | 菜谱上下架 |
| POST | `/api/admin/category` | 新增分类 |
| PUT | `/api/admin/category/{id}` | 编辑分类 |
| DELETE | `/api/admin/category/{id}` | 删除分类 |
| DELETE | `/api/admin/comment/{id}` | 删除评论 |

---

## Swagger 文档

启动后端后访问：`http://localhost:8080/swagger-ui.html`
