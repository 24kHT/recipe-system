import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import pptxgen from "pptxgenjs";
import { imageSize } from "image-size";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const root = path.resolve(__dirname, "..");
const assets = path.join(root, "assets", "micro_recipe_report");
const output = path.join(root, "output", "micro_recipe_report");
const pptPath = path.join(output, "菜谱管理系统课程汇报_v2.pptx");
const logoPath = path.join(root, "xb1.png");

fs.mkdirSync(output, { recursive: true });

const pptx = new pptxgen();
pptx.layout = "LAYOUT_WIDE";
pptx.author = "菜谱管理系统";
pptx.company = "Jiangsu University";
pptx.subject = "Vue 3 + Spring Boot + MySQL 课程汇报";
pptx.title = "菜谱管理系统课程汇报";
pptx.lang = "zh-CN";
pptx.theme = {
  headFontFace: "Microsoft YaHei",
  bodyFontFace: "Microsoft YaHei",
  lang: "zh-CN",
};
pptx.defineLayout({ name: "LAYOUT_WIDE", width: 13.333, height: 7.5 });

const C = {
  green: "1B7F5F",
  deep: "0F513F",
  pale: "F4FAF6",
  mint: "E6F3EB",
  orange: "EF6C35",
  amber: "F59E0B",
  blue: "2563EB",
  ink: "1F2937",
  muted: "64748B",
  line: "D9E4DD",
  white: "FFFFFF",
};

const W = 13.333;
const H = 7.5;

function asset(name) {
  return path.join(assets, name);
}

function rootImg(name) {
  return path.join(root, name);
}

function addLogo(slide, variant = "normal") {
  const size = variant === "cover" ? 0.72 : 0.42;
  const x = variant === "cover" ? 0.72 : 0.34;
  const y = variant === "cover" ? 0.52 : 0.28;
  slide.addImage({ path: logoPath, x, y, w: size, h: size });
}

function bg(slide, section = "") {
  slide.background = { color: C.white };
  slide.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: W, h: 0.13, fill: { color: C.green }, line: { color: C.green } });
  slide.addShape(pptx.ShapeType.rect, { x: 0, y: 7.22, w: W, h: 0.28, fill: { color: C.pale }, line: { color: C.pale } });
  addLogo(slide);
  slide.addText("菜谱管理系统", { x: 0.84, y: 0.36, w: 2.2, h: 0.18, fontSize: 8.5, bold: true, color: C.green, margin: 0 });
  slide.addText(section, { x: 8.9, y: 7.3, w: 3.95, h: 0.14, fontSize: 7.5, color: "94A3B8", align: "right", margin: 0 });
}

function title(slide, text, subtitle = "", section = "") {
  bg(slide, section);
  slide.addShape(pptx.ShapeType.rect, { x: 0.68, y: 0.72, w: 0.1, h: 0.42, fill: { color: C.orange }, line: { color: C.orange } });
  slide.addText(text, { x: 0.88, y: 0.66, w: 9.2, h: 0.42, fontSize: 22, bold: true, color: C.ink, margin: 0, fit: "shrink" });
  if (subtitle) {
    slide.addText(subtitle, { x: 0.9, y: 1.13, w: 11.6, h: 0.22, fontSize: 9.5, color: C.muted, margin: 0 });
  }
  slide.addShape(pptx.ShapeType.line, { x: 0.68, y: 1.43, w: 12.0, h: 0, line: { color: C.line, width: 0.8 } });
}

function card(slide, x, y, w, h, fill = C.white, line = C.line) {
  slide.addShape(pptx.ShapeType.roundRect, {
    x, y, w, h,
    rectRadius: 0.08,
    fill: { color: fill },
    line: { color: line, width: 0.8 },
  });
}

function bullets(slide, items, x, y, w, h, fontSize = 12, color = C.ink) {
  slide.addText(items.map((item) => ({
    text: item,
    options: { bullet: { type: "ul" }, breakLine: true, hanging: 3 },
  })), {
    x, y, w, h,
    fontSize,
    color,
    margin: 0.04,
    paraSpaceAfterPt: 7,
    fit: "shrink",
    breakLine: false,
  });
}

function imageContain(slide, imagePath, x, y, w, h, border = true) {
  if (border) card(slide, x, y, w, h, C.white, "E2E8F0");
  const { width, height } = imageSize(imagePath);
  const ratio = Math.min((w - 0.18) / width, (h - 0.18) / height);
  const iw = width * ratio;
  const ih = height * ratio;
  slide.addImage({ path: imagePath, x: x + (w - iw) / 2, y: y + (h - ih) / 2, w: iw, h: ih });
}

function imageCover(slide, imagePath, x, y, w, h) {
  const { width, height } = imageSize(imagePath);
  const srcRatio = width / height;
  const boxRatio = w / h;
  let crop = {};
  if (srcRatio > boxRatio) {
    const cropW = Math.round(height * boxRatio);
    crop = { x: Math.round((width - cropW) / 2), y: 0, w: cropW, h: height };
  } else {
    const cropH = Math.round(width / boxRatio);
    crop = { x: 0, y: Math.round((height - cropH) / 2), w: width, h: cropH };
  }
  slide.addImage({ path: imagePath, x, y, w, h, sizing: { type: "crop", x, y, w, h, crop } });
}

function table(slide, rows, x, y, w, h, colW) {
  slide.addTable(rows, {
    x, y, w, h,
    colW,
    margin: 0.05,
    fontFace: "Microsoft YaHei",
    fontSize: 9.2,
    color: C.ink,
    fit: "shrink",
    border: { type: "solid", color: "D8E8DF", pt: 0.8 },
  });
}

function metric(slide, x, y, w, value, label, color = C.green) {
  card(slide, x, y, w, 0.92, "FBFEFC", "DCEADF");
  slide.addText(value, { x: x + 0.1, y: y + 0.15, w: w - 0.2, h: 0.3, fontSize: 18, bold: true, color, align: "center", margin: 0 });
  slide.addText(label, { x: x + 0.1, y: y + 0.55, w: w - 0.2, h: 0.18, fontSize: 8.3, color: C.muted, align: "center", margin: 0 });
}

function sectionSlide(no, name, subtitle) {
  const slide = pptx.addSlide();
  slide.background = { color: C.pale };
  slide.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: W, h: H, fill: { color: C.pale }, line: { color: C.pale } });
  slide.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: 4.35, h: H, fill: { color: C.green }, line: { color: C.green } });
  addLogo(slide, "cover");
  slide.addText(`0${no}`, { x: 0.78, y: 2.0, w: 2.3, h: 0.5, fontSize: 32, bold: true, color: "DDF6EA", margin: 0 });
  slide.addText(name, { x: 0.78, y: 2.75, w: 3.0, h: 1.2, fontSize: 24, bold: true, color: C.white, fit: "shrink", margin: 0 });
  slide.addText("菜谱管理系统课程汇报", { x: 0.82, y: 6.62, w: 2.9, h: 0.18, fontSize: 8.8, color: "DDF6EA", margin: 0 });
  slide.addShape(pptx.ShapeType.line, { x: 5.05, y: 1.05, w: 0, h: 5.4, line: { color: C.green, width: 1.2 } });
  slide.addText(subtitle, { x: 5.65, y: 2.74, w: 6.5, h: 0.75, fontSize: 24, bold: true, color: C.ink, margin: 0, fit: "shrink" });
  slide.addText("基于当前项目代码、数据库设计与已生成图表资产整理", { x: 5.68, y: 3.75, w: 5.5, h: 0.24, fontSize: 10.5, color: C.muted, margin: 0 });
  return slide;
}

function headerRow(labels) {
  return labels.map((text) => ({ text, options: { bold: true, fill: C.green, color: C.white } }));
}

// 1. Cover
let slide = pptx.addSlide();
slide.background = { color: C.pale };
slide.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: 4.2, h: H, fill: { color: C.green }, line: { color: C.green } });
addLogo(slide, "cover");
slide.addText("江苏大学", { x: 1.55, y: 0.66, w: 2.0, h: 0.3, fontSize: 16, bold: true, color: C.white, margin: 0 });
slide.addText("JIANGSU UNIVERSITY", { x: 1.57, y: 1.03, w: 2.2, h: 0.18, fontSize: 8.5, color: "DDF6EA", margin: 0 });
slide.addText("菜谱管理系统", { x: 0.78, y: 2.12, w: 3.0, h: 0.86, fontSize: 34, bold: true, color: C.white, fit: "shrink", margin: 0 });
slide.addText("课程设计汇报", { x: 0.82, y: 3.12, w: 2.7, h: 0.34, fontSize: 17, color: "DDF6EA", margin: 0 });
slide.addShape(pptx.ShapeType.line, { x: 0.82, y: 3.78, w: 2.78, h: 0, line: { color: "BFEAD8", width: 1.1 } });
slide.addText("Vue 3 + Spring Boot 3 + MyBatis-Plus + MySQL", { x: 0.84, y: 4.03, w: 2.86, h: 0.45, fontSize: 10.5, color: C.white, fit: "shrink", margin: 0 });
imageContain(slide, rootImg("design.png"), 4.75, 0.72, 7.78, 4.85, false);
card(slide, 5.1, 5.9, 6.95, 0.86, C.white, "DCEADF");
slide.addText("汇报人：XXX        学院：XXX学院        日期：2026年6月1日", { x: 5.35, y: 6.22, w: 6.45, h: 0.2, fontSize: 11, color: C.ink, align: "center", margin: 0 });

// 2. Agenda
slide = pptx.addSlide();
title(slide, "汇报目录", "按照课程报告逻辑重新组织：背景、总体设计、数据库、详细设计、实现、测试与 AI 总结。", "目录");
[
  ["01", "项目背景与需求分析"],
  ["02", "系统设计"],
  ["03", "数据库设计"],
  ["04", "系统详细设计"],
  ["05", "系统实现"],
  ["06", "测试"],
  ["07", "AI 工具实现本项目总结"],
].forEach((item, i) => {
  const col = i < 4 ? 0 : 1;
  const row = i < 4 ? i : i - 4;
  const x = col === 0 ? 0.9 : 6.95;
  const y = 1.7 + row * 1.12;
  card(slide, x, y, 5.25, 0.76, i % 2 ? "FBFEFC" : C.white, "DCEADF");
  slide.addText(item[0], { x: x + 0.25, y: y + 0.16, w: 0.6, h: 0.25, fontSize: 17, bold: true, color: i % 2 ? C.orange : C.green, margin: 0 });
  slide.addText(item[1], { x: x + 1.05, y: y + 0.2, w: 3.8, h: 0.18, fontSize: 13.5, bold: true, color: C.ink, margin: 0 });
});

sectionSlide(1, "项目背景与需求分析", "明确系统为什么做、为谁做、需要完成什么");

slide = pptx.addSlide();
title(slide, "项目背景与建设目标", "面向家庭做饭、菜谱收藏与课程实践的综合 Web 系统。", "01 项目背景与需求分析");
card(slide, 0.82, 1.75, 5.72, 4.52, "FBFEFC");
slide.addText("问题背景", { x: 1.15, y: 2.1, w: 1.5, h: 0.22, fontSize: 15, bold: true, color: C.green, margin: 0 });
bullets(slide, ["菜谱内容分散，缺少统一的浏览、检索与管理入口", "用户希望按分类、关键词、食材快速找到可做菜谱", "菜谱需要收藏、评论、发布、维护等互动能力", "课程实践要求串联前端、后端、数据库和接口联调"], 1.15, 2.55, 4.95, 2.35);
card(slide, 6.78, 1.75, 5.72, 4.52, C.white);
slide.addText("建设目标", { x: 7.12, y: 2.1, w: 1.5, h: 0.22, fontSize: 15, bold: true, color: C.orange, margin: 0 });
bullets(slide, ["完成可运行的菜谱分享与管理平台", "支持注册登录、菜谱浏览、发布、收藏和评论", "管理员可维护用户、菜谱与分类", "形成清晰的 Controller-Service-Mapper 分层和关系型数据库模型"], 7.12, 2.55, 4.9, 2.35);

slide = pptx.addSlide();
title(slide, "需求分析：角色、功能与权限", "系统区分游客、普通用户和管理员，功能边界清晰。", "01 项目背景与需求分析");
table(slide, [
  headerRow(["角色", "核心需求", "权限特征"]),
  ["游客", "浏览首页、菜谱列表、分类筛选、关键词搜索、查看详情", "访问公开 GET 接口"],
  ["普通用户", "注册登录、发布菜谱、收藏菜谱、发表评论、维护个人资料", "携带 JWT 访问互动接口"],
  ["管理员", "查看统计、用户启停、菜谱上下架、分类维护", "访问 /api/admin/**，校验 ADMIN 角色"],
], 0.85, 1.75, 11.65, 2.35, [1.3, 6.4, 3.95]);
metric(slide, 1.0, 4.65, 2.15, "7", "核心数据表");
metric(slide, 3.55, 4.65, 2.15, "9", "前端路由", C.orange);
metric(slide, 6.1, 4.65, 2.15, "6", "后端控制器", C.blue);
metric(slide, 8.65, 4.65, 2.15, "6", "业务模块", C.deep);

sectionSlide(2, "系统设计", "展示系统总体架构、技术栈和前后端组织方式");

slide = pptx.addSlide();
title(slide, "技术栈与工程结构", "前后端分离，接口通过 /api 代理联通。", "02 系统设计");
table(slide, [
  headerRow(["层级", "主要技术", "承担职责"]),
  ["前端", "Vue 3、Vite 6、Vue Router、Pinia、Axios、Element Plus", "页面展示、路由守卫、状态管理、接口请求"],
  ["后端", "Spring Boot 3.3.7、MyBatis-Plus 3.5.9、JWT、BCrypt", "REST API、认证鉴权、业务处理、数据访问"],
  ["数据库", "MySQL 8.4、InnoDB、utf8mb4、索引与外键", "存储用户、菜谱、分类、食材、步骤、收藏、评论"],
  ["汇报工具", "PptxGenJS、Mermaid CLI、Matplotlib、SciencePlots", "生成图表、测试结果图和真实 PPTX"],
], 0.75, 1.7, 11.85, 3.05, [1.25, 5.4, 5.2]);
bullets(slide, ["recipe-system-frontend：页面、路由、API 封装、Pinia 用户状态", "recipe-system-backend：Controller、Service、Mapper、Entity、DTO/VO、Config", "docs / diagrams / assets / scripts / output：图源、资产、脚本与最终汇报文件"], 0.95, 5.2, 11.1, 1.0, 11);

slide = pptx.addSlide();
title(slide, "系统总体架构图", "Vue 前端通过 Axios 访问 Spring Boot，后端通过 MyBatis-Plus 操作 MySQL。", "02 系统设计");
imageContain(slide, asset("system_architecture.png"), 0.75, 1.65, 11.85, 5.2);

slide = pptx.addSlide();
title(slide, "前端路由结构", "路由守卫区分公开页面、登录页面和管理员后台。", "02 系统设计");
imageContain(slide, asset("frontend_routing.png"), 0.75, 1.65, 11.85, 5.2);

slide = pptx.addSlide();
title(slide, "后端分层架构", "Controller 接收请求，Service 编排业务，Mapper 负责持久化。", "02 系统设计");
imageContain(slide, asset("backend_layers.png"), 0.75, 1.65, 11.85, 5.2);

sectionSlide(3, "数据库设计", "围绕菜谱主表拆分食材、步骤、收藏与评论关系");

slide = pptx.addSlide();
title(slide, "数据库 ER 图", "7 张核心表支撑菜谱发布、展示、互动与后台治理。", "03 数据库设计");
imageContain(slide, asset("er_diagram.png"), 0.65, 1.62, 12.05, 5.3);

slide = pptx.addSlide();
title(slide, "核心表设计说明", "菜谱表保存主体信息，食材和步骤独立建表，收藏用中间表表达多对多。", "03 数据库设计");
table(slide, [
  headerRow(["数据表", "作用", "设计要点"]),
  ["user", "保存账号、昵称、角色、状态", "username 唯一，密码 BCrypt 加密，role 区分 USER/ADMIN"],
  ["recipe", "保存菜谱主体信息", "关联作者与分类，维护浏览、收藏、点赞、评论计数"],
  ["recipe_ingredient / recipe_step", "保存食材清单与制作步骤", "一条菜谱对应多条食材和步骤，便于展示和维护"],
  ["favorite / comment", "保存收藏关系与评论内容", "favorite 使用 user_id + recipe_id 唯一约束，comment 支持状态与逻辑删除"],
  ["category", "保存菜谱分类", "支持排序、启停和后台维护"],
], 0.75, 1.7, 11.85, 4.45, [2.25, 3.8, 5.8]);

sectionSlide(4, "系统详细设计", "说明认证链路、核心业务流程与 API 时序");

slide = pptx.addSlide();
title(slide, "核心业务流程", "游客浏览、登录互动、管理员治理形成完整闭环。", "04 系统详细设计");
imageContain(slide, asset("business_flow.png"), 0.8, 1.65, 11.75, 5.2);

slide = pptx.addSlide();
title(slide, "接口设计与认证机制", "统一 Result 返回、JWT 鉴权、公开接口和管理接口分离。", "04 系统详细设计");
table(slide, [
  headerRow(["模块", "代表接口", "说明"]),
  ["用户", "POST /api/user/login、GET /api/user/current", "登录后返回 token，前端保存并在请求头携带"],
  ["菜谱", "GET /api/recipe/list、POST /api/recipe", "列表公开，发布、编辑、删除需要登录"],
  ["互动", "POST /api/favorite/{id}、POST /api/comment", "收藏和评论会同步刷新统计计数"],
  ["后台", "GET /api/admin/stat、PUT /api/admin/recipe/{id}/disable", "AuthInterceptor 校验 ADMIN 角色"],
], 0.75, 1.7, 11.85, 3.05, [1.3, 4.7, 5.85]);
card(slide, 0.95, 5.1, 11.3, 0.9, "FBFEFC");
slide.addText("登录成功 -> JwtUtil 生成 token -> Pinia/localStorage 保存 -> Axios 注入 Bearer -> AuthInterceptor 解析 -> UserContext 保存当前用户 -> Controller/Service 执行业务", { x: 1.2, y: 5.42, w: 10.8, h: 0.22, fontSize: 10.5, color: C.ink, align: "center", margin: 0, fit: "shrink" });

slide = pptx.addSlide();
title(slide, "菜谱发布 API 时序图", "发布菜谱同时维护主表、食材表和步骤表。", "04 系统详细设计");
imageContain(slide, asset("api_sequence.png"), 0.7, 1.62, 12.0, 5.3);

slide = pptx.addSlide();
title(slide, "后台管理 API 时序图", "管理员拉取统计、用户、菜谱、分类数据，并执行状态治理。", "04 系统详细设计");
imageContain(slide, asset("admin_sequence.png"), 0.7, 1.62, 12.0, 5.3);

sectionSlide(5, "系统实现", "从前端页面、后端服务和功能亮点展示实现成果");

slide = pptx.addSlide();
title(slide, "功能实现亮点", "从当前代码实现看系统的完整性与可维护性。", "05 系统实现");
[
  ["菜谱发布", "RecipeServiceImpl 使用事务写入 recipe、recipe_ingredient、recipe_step，保持主从数据一致"],
  ["检索筛选", "列表接口支持 page/pageSize、keyword、categoryId；关键词覆盖标题、描述和食材名称"],
  ["互动计数", "收藏与评论后刷新 favorite_count、comment_count，列表展示无需重复聚合"],
  ["权限控制", "AuthInterceptor 对公开接口放行，对登录接口和 /api/admin/** 做 JWT 与角色校验"],
  ["数据治理", "deleted 逻辑删除、status 上下架/启停，兼顾课程演示和数据可追溯"],
].forEach((row, i) => {
  const y = 1.78 + i * 0.86;
  card(slide, 0.9, y, 11.55, 0.58, i % 2 ? "FBFEFC" : C.white, "DCEADF");
  slide.addText(row[0], { x: 1.15, y: y + 0.15, w: 1.4, h: 0.16, fontSize: 11.3, bold: true, color: i % 2 ? C.orange : C.green, margin: 0 });
  slide.addText(row[1], { x: 2.75, y: y + 0.12, w: 9.25, h: 0.23, fontSize: 10, color: C.ink, margin: 0, fit: "shrink" });
});

slide = pptx.addSlide();
title(slide, "界面实现展示", "首页效果图展示了菜谱社区的核心入口与内容组织方式。", "05 系统实现");
imageContain(slide, rootImg("design.png"), 0.65, 1.62, 12.05, 5.3);

sectionSlide(6, "测试", "记录真实构建验证结果与可改进项");

slide = pptx.addSlide();
title(slide, "测试与构建结果", "后端编译、前端构建、图表生成和 PPT 输出均已验证。", "06 测试");
imageContain(slide, asset("micro_recipe_test_results.png"), 0.75, 1.75, 6.35, 4.8);
card(slide, 7.45, 1.9, 4.95, 4.25, "FBFEFC");
slide.addText("已执行命令", { x: 7.78, y: 2.22, w: 1.7, h: 0.22, fontSize: 14, bold: true, color: C.green, margin: 0 });
bullets(slide, ["后端：mvn test，BUILD SUCCESS，当前无测试用例", "前端：npm run build，构建成功，生成 dist 产物", "图表：Mermaid CLI 导出架构图、ER 图、流程图、时序图", "PPT：PptxGenJS 输出真实 .pptx 文件"], 7.78, 2.72, 4.25, 2.1, 11);
slide.addText("构建提示：前端主 chunk 超过 500 kB，后续可按路由拆包或配置 manualChunks 优化。", { x: 7.78, y: 5.46, w: 4.2, h: 0.3, fontSize: 9.3, color: C.muted, margin: 0, fit: "shrink" });

sectionSlide(7, "AI 工具实现本项目总结", "说明哪些环节使用 AI 辅助，哪些环节由项目代码验证");

slide = pptx.addSlide();
title(slide, "AI 工具参与分工", "AI 用于辅助分析、图表生成和汇报材料整理，核心结论基于项目代码与真实命令。", "07 AI 工具实现本项目总结");
table(slide, [
  headerRow(["环节", "使用的 AI / 工具", "产出内容"]),
  ["项目理解", "Codex + 代码检索", "阅读后端 Controller/Service/Entity、SQL、前端路由和 API 封装"],
  ["图表设计", "Mermaid + AI 辅助整理", "系统架构图、前端路由图、后端分层图、ER 图、业务流程图、API 时序图"],
  ["技术图生成", "Mermaid CLI / Puppeteer", "将 .mmd 图源导出为 PPT 可插入 PNG"],
  ["测试结果图", "Python + matplotlib + SciencePlots", "生成课程汇报中的测试结果图"],
  ["PPT 制作", "PptxGenJS + Codex", "生成真实 .pptx，统一版式、章节封面、校标和页面结构"],
], 0.75, 1.7, 11.85, 4.25, [2.3, 3.4, 6.15]);

slide = pptx.addSlide();
title(slide, "项目总结与后续改进", "系统覆盖课程项目的前端、后端、数据库、接口联调和报告生成能力。", "07 AI 工具实现本项目总结");
card(slide, 0.82, 1.76, 3.62, 4.6, "FBFEFC");
slide.addText("项目收获", { x: 1.14, y: 2.1, w: 1.5, h: 0.22, fontSize: 15, bold: true, color: C.green, margin: 0 });
bullets(slide, ["完成前后端分离工程组织", "实践 JWT 登录认证与路由守卫", "完成关系型数据库建模", "形成可汇报图表与 PPT 产物"], 1.14, 2.55, 2.85, 2.35, 11);
card(slide, 4.86, 1.76, 3.62, 4.6, C.white);
slide.addText("当前不足", { x: 5.18, y: 2.1, w: 1.5, h: 0.22, fontSize: 15, bold: true, color: C.orange, margin: 0 });
bullets(slide, ["自动化测试用例仍需补充", "前端构建包体偏大", "图片上传仍以静态资源为主", "推荐算法仍偏规则化"], 5.18, 2.55, 2.85, 2.35, 11);
card(slide, 8.9, 1.76, 3.62, 4.6, "FBFEFC");
slide.addText("优化方向", { x: 9.22, y: 2.1, w: 1.5, h: 0.22, fontSize: 15, bold: true, color: C.blue, margin: 0 });
bullets(slide, ["补充单元测试与接口测试", "前端按路由拆包", "完善图片上传服务", "扩展个性化推荐和浏览历史"], 9.22, 2.55, 2.85, 2.35, 11);

slide = pptx.addSlide();
slide.background = { color: C.green };
addLogo(slide, "cover");
slide.addText("感谢聆听", { x: 3.75, y: 2.72, w: 5.9, h: 0.7, fontSize: 34, bold: true, color: C.white, align: "center", margin: 0 });
slide.addText("菜谱管理系统课程汇报", { x: 4.2, y: 3.58, w: 5.0, h: 0.28, fontSize: 13, color: "DDF6EA", align: "center", margin: 0 });
slide.addShape(pptx.ShapeType.line, { x: 4.25, y: 4.16, w: 4.82, h: 0, line: { color: "BFEAD8", width: 1.2 } });

await pptx.writeFile({ fileName: pptPath });
console.log(pptPath);
