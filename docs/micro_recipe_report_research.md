# 微菜谱系统课程汇报研究摘要

## 项目定位

微菜谱系统是一个基于 Vue 3 + Spring Boot 3 + MyBatis-Plus + MySQL 的前后端分离菜谱分享与管理平台。普通用户可以浏览、搜索、发布、收藏和评论菜谱；管理员可以进行用户启停、菜谱上下架、分类维护和数据统计。

## 技术栈

- 前端：Vue 3、Vite 6、Vue Router、Pinia、Axios、Element Plus。
- 后端：Spring Boot 3.3.7、MyBatis-Plus 3.5.9、JWT、BCrypt、SpringDoc OpenAPI。
- 数据库：MySQL 8.4，核心库名 `recipe_system`。

## 后端结构

- `controller`：暴露 REST API，包含用户、菜谱、分类、收藏、评论和后台管理。
- `service.impl`：实现核心业务逻辑，如菜谱发布时同步写入主表、食材和步骤。
- `mapper`：MyBatis-Plus 数据访问层。
- `entity`：映射 `user`、`category`、`recipe`、`recipe_ingredient`、`recipe_step`、`favorite`、`comment` 七张核心表。
- `config`：包含 JWT 拦截器、CORS、分页插件和初始数据。
- `common`：统一返回 `Result` 和分页返回 `PageResult`。

## 数据库核心关系

- 用户与菜谱：一对多。
- 分类与菜谱：一对多。
- 菜谱与食材：一对多。
- 菜谱与步骤：一对多。
- 用户与菜谱收藏：通过 `favorite` 中间表形成多对多。
- 用户与评论、菜谱与评论：分别是一对多。

## 前端路由

- `/` 首页
- `/recipes` 菜谱列表
- `/fridge` 冰箱寻菜
- `/recipe/:id` 菜谱详情
- `/login` 登录
- `/register` 注册
- `/publish` 发布菜谱，需要登录
- `/profile` 个人中心，需要登录
- `/admin` 后台管理，需要登录且为管理员

## 已执行验证

- 后端：`mvn test`，编译成功，当前没有测试用例。
- 前端：`npm run build`，构建成功，存在大 chunk 警告。
- PPT 工具链：Mermaid 导图、Python 科研图、PptxGenJS 生成真实 `.pptx`。
