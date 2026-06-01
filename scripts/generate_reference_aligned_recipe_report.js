import fs from "node:fs";
import path from "node:path";
import { execFileSync } from "node:child_process";
import { fileURLToPath } from "node:url";
import pptxgen from "pptxgenjs";
import { imageSize } from "image-size";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const root = path.resolve(__dirname, "..");
const outDir = path.join(root, "output", "reference_aligned_recipe_report");
const assetDir = path.join(root, "assets", "reference_aligned_recipe_report");
const diagramDir = path.join(root, "diagrams", "reference_aligned_recipe_report");
const pptPath = path.join(outDir, "基于Vue+SpringBoot+MySQL的菜谱分享与管理系统_参考优化版.pptx");
const mermaidConfig = path.join(root, "scripts", "mermaid-puppeteer-config.json");
const logo = path.join(root, "xb1.png");
const wordmark = path.join(root, "xb2.png");
const homeShot = path.join(root, "design.png");

for (const d of [outDir, assetDir, diagramDir]) fs.mkdirSync(d, { recursive: true });

const diagrams = {
  "01_usecase.mmd": `---
config:
  theme: base
  themeVariables:
    fontFamily: Microsoft YaHei, SimHei, Arial
    primaryColor: '#F7FCF5'
    primaryBorderColor: '#6E8F72'
    primaryTextColor: '#1F2E25'
    lineColor: '#6E8F72'
    secondaryColor: '#EAF4EA'
---
flowchart LR
  A["游客"] --> A1["浏览菜谱"]
  A --> A2["搜索 / 分类筛选"]
  A --> A3["查看详情与评论"]
  B["普通用户"] --> B1["注册登录"]
  B --> B2["发布菜谱"]
  B --> B3["收藏菜谱"]
  B --> B4["发表评论"]
  B --> B5["冰箱寻菜"]
  C["管理员"] --> C1["用户启停"]
  C --> C2["菜谱上下架"]
  C --> C3["分类维护"]
  C --> C4["评论治理"]
`,
  "02_top_dfd.mmd": `---
config:
  theme: base
  themeVariables:
    fontFamily: Microsoft YaHei, SimHei, Arial
    primaryColor: '#F7FCF5'
    primaryBorderColor: '#6E8F72'
    lineColor: '#6E8F72'
---
flowchart LR
  U["用户"] -->|注册登录 / 浏览 / 发布 / 收藏 / 评论| S["菜谱分享与管理系统\\nVue + Spring Boot"]
  A["管理员"] -->|用户管理 / 分类维护 / 菜谱治理| S
  S -->|菜谱列表 / 详情 / 收藏状态 / 评论列表| U
  S -->|统计数据 / 管理列表 / 操作结果| A
  S <-->|读写业务数据| DB[("MySQL\\nrecipe_system")]
  S --> R["静态封面资源"]
`,
  "03_level0_dfd.mmd": `---
config:
  theme: base
  themeVariables:
    fontFamily: Microsoft YaHei, SimHei, Arial
    primaryColor: '#F7FCF5'
    primaryBorderColor: '#6E8F72'
    secondaryColor: '#EAF4EA'
    lineColor: '#6E8F72'
---
flowchart TB
  U["用户 / 管理员"] --> P1["P1 认证与权限"]
  U --> P2["P2 菜谱浏览与搜索"]
  U --> P3["P3 菜谱发布维护"]
  U --> P4["P4 收藏与评论互动"]
  U --> P5["P5 后台管理"]
  P1 <--> D1[("D1 user")]
  P2 <--> D2[("D2 recipe / category")]
  P2 <--> D3[("D3 recipe_ingredient")]
  P3 <--> D2
  P3 <--> D4[("D4 recipe_step")]
  P4 <--> D5[("D5 favorite / comment")]
  P5 <--> D1
  P5 <--> D2
  P5 <--> D5
`,
  "04_er_overview.mmd": `---
config:
  theme: base
  themeVariables:
    fontFamily: Microsoft YaHei, SimHei, Arial
    primaryColor: '#F7FCF5'
    primaryBorderColor: '#6E8F72'
    lineColor: '#6E8F72'
---
erDiagram
  USER ||--o{ RECIPE : publishes
  CATEGORY ||--o{ RECIPE : classifies
  RECIPE ||--o{ RECIPE_INGREDIENT : has
  RECIPE ||--o{ RECIPE_STEP : has
  USER ||--o{ FAVORITE : creates
  RECIPE ||--o{ FAVORITE : collected_by
  USER ||--o{ COMMENT : writes
  RECIPE ||--o{ COMMENT : receives
`,
  "05_api_sequence.mmd": `---
config:
  theme: base
  themeVariables:
    fontFamily: Microsoft YaHei, SimHei, Arial
    primaryColor: '#F7FCF5'
    actorBkg: '#EAF4EA'
    actorBorder: '#6E8F72'
    signalColor: '#4F6F55'
    noteBkgColor: '#F7FCF5'
---
sequenceDiagram
  actor User as 用户
  participant Vue as Vue 页面
  participant Axios as Axios 封装
  participant Auth as JWT 拦截器
  participant Ctrl as Controller
  participant Service as Service
  participant DB as MySQL
  User->>Vue: 点击登录 / 发布 / 收藏 / 评论
  Vue->>Axios: 组装参数
  Axios->>Ctrl: /api 请求 + Token
  Ctrl->>Auth: 校验身份与角色
  Ctrl->>Service: 调用业务方法
  Service->>DB: MyBatis-Plus 读写
  DB-->>Service: 返回数据
  Service-->>Ctrl: VO / 业务结果
  Ctrl-->>Vue: Result<T>
  Vue-->>User: 更新页面状态
`,
};

for (const [name, content] of Object.entries(diagrams)) {
  fs.writeFileSync(path.join(diagramDir, name), content, "utf8");
}

function renderMermaid(name, width = 1800) {
  const input = path.join(diagramDir, name);
  const output = path.join(assetDir, name.replace(".mmd", ".png"));
  execFileSync("cmd.exe", [
    "/c", "npx", "mmdc",
    "-p", mermaidConfig,
    "-i", input,
    "-o", output,
    "-b", "white",
    "-w", String(width),
    "-s", "2",
  ], { cwd: root, stdio: "inherit" });
  return output;
}

const mmd = {
  usecase: renderMermaid("01_usecase.mmd", 1600),
  topDfd: renderMermaid("02_top_dfd.mmd", 1600),
  level0: renderMermaid("03_level0_dfd.mmd", 1700),
  er: renderMermaid("04_er_overview.mmd", 1500),
  api: renderMermaid("05_api_sequence.mmd", 1500),
};

const pptx = new pptxgen();
pptx.layout = "LAYOUT_WIDE";
pptx.author = "食光菜谱系统";
pptx.company = "江苏大学";
pptx.subject = "基于 Vue + Spring Boot + MySQL 的菜谱分享与管理系统";
pptx.title = "基于 Vue + Spring Boot + MySQL 的菜谱分享与管理系统";
pptx.lang = "zh-CN";
pptx.theme = {
  headFontFace: "Microsoft YaHei",
  bodyFontFace: "Microsoft YaHei",
  lang: "zh-CN",
};
pptx.defineLayout({ name: "LAYOUT_WIDE", width: 13.333, height: 7.5 });

const W = 13.333;
const H = 7.5;
const C = {
  bg: "EAF4EA",
  bg2: "F7FCF5",
  panel: "FFFFFF",
  green: "4F6F55",
  green2: "6E8F72",
  green3: "8FB996",
  mint: "DDEBDD",
  pale: "F2F8F2",
  line: "B8CEB8",
  ink: "1F2E25",
  muted: "5F7063",
  gray: "EDF2ED",
  white: "FFFFFF",
};

function addHeader(slide, section = "") {
  slide.background = { color: C.bg };
  slide.addImage({ path: logo, x: 0.25, y: 0.18, w: 0.43, h: 0.43 });
  slide.addShape(pptx.ShapeType.line, { x: 0.82, y: 0.42, w: 11.95, h: 0, line: { color: C.green, width: 1.1 } });
  slide.addShape(pptx.ShapeType.rect, { x: 0.75, y: 7.02, w: 11.9, h: 0.13, fill: { color: C.green2 }, line: { color: C.green2 } });
  if (section) slide.addText(section, { x: 9.1, y: 7.18, w: 3.35, h: 0.12, fontSize: 7.5, color: C.green, align: "right", margin: 0 });
}

function title(slide, main, sub = "", section = "") {
  addHeader(slide, section);
  slide.addText(`● ${main}`, { x: 1.1, y: 0.22, w: 7.7, h: 0.36, fontSize: 18, bold: true, color: C.ink, margin: 0 });
  if (sub) slide.addText(sub, { x: 1.05, y: 0.86, w: 11.1, h: 0.25, fontSize: 12, color: C.muted, margin: 0, fit: "shrink" });
}

function card(slide, x, y, w, h, fill = C.panel, line = C.line) {
  slide.addShape(pptx.ShapeType.roundRect, {
    x, y, w, h,
    rectRadius: 0.06,
    fill: { color: fill },
    line: { color: line, width: 0.8 },
  });
}

function bullets(slide, items, x, y, w, h, fontSize = 14, color = C.ink) {
  slide.addText(items.map((text) => ({ text, options: { bullet: { type: "ul" }, breakLine: true, hanging: 4 } })), {
    x, y, w, h,
    fontSize,
    color,
    paraSpaceAfterPt: 7,
    fit: "shrink",
    margin: 0.04,
    breakLine: false,
  });
}

function para(slide, text, x, y, w, h, size = 13) {
  slide.addText(text, { x, y, w, h, fontSize: size, color: C.ink, breakLine: false, fit: "shrink", margin: 0.02, valign: "mid" });
}

function imageContain(slide, img, x, y, w, h, border = true) {
  if (border) card(slide, x, y, w, h, C.white, C.line);
  const { width, height } = imageSize(img);
  const ratio = Math.min((w - 0.12) / width, (h - 0.12) / height);
  const iw = width * ratio;
  const ih = height * ratio;
  slide.addImage({ path: img, x: x + (w - iw) / 2, y: y + (h - ih) / 2, w: iw, h: ih });
}

function imageCrop(slide, img, x, y, w, h, crop) {
  slide.addImage({ path: img, x, y, w, h, sizing: { type: "crop", x, y, w, h, crop } });
}

function table(slide, rows, x, y, w, h, colW, fontSize = 10.5) {
  slide.addTable(rows, {
    x, y, w, h, colW,
    fontFace: "Microsoft YaHei",
    fontSize,
    color: C.ink,
    fit: "shrink",
    margin: 0.04,
    border: { type: "solid", color: C.line, pt: 0.7 },
    valign: "mid",
  });
}

function headerRow(labels) {
  return labels.map((text) => ({ text, options: { bold: true, fill: C.green2, color: C.white } }));
}

function sectionCover(no, name, desc) {
  const s = pptx.addSlide();
  s.background = { color: C.bg };
  s.addImage({ path: logo, x: 0.46, y: 0.42, w: 0.62, h: 0.62 });
  s.addShape(pptx.ShapeType.line, { x: 1.25, y: 0.78, w: 10.8, h: 0, line: { color: C.green, width: 1.3 } });
  s.addText(`0${no}`, { x: 1.1, y: 2.0, w: 1.5, h: 0.5, fontSize: 34, bold: true, color: C.green2, margin: 0 });
  s.addText(name, { x: 1.1, y: 2.78, w: 7.8, h: 0.55, fontSize: 30, bold: true, color: C.ink, margin: 0 });
  s.addText(desc, { x: 1.14, y: 3.6, w: 8.5, h: 0.28, fontSize: 14, color: C.muted, margin: 0 });
  s.addShape(pptx.ShapeType.rect, { x: 1.1, y: 5.82, w: 10.95, h: 0.18, fill: { color: C.green2 }, line: { color: C.green2 } });
  s.addText("基于 Vue + Spring Boot + MySQL 的菜谱分享与管理系统", { x: 1.12, y: 6.18, w: 8.4, h: 0.18, fontSize: 10, color: C.green, margin: 0 });
}

function node(slide, text, x, y, w, h, fill = C.bg2, color = C.ink) {
  card(slide, x, y, w, h, fill, C.green2);
  slide.addText(text, { x: x + 0.06, y: y + h / 2 - 0.1, w: w - 0.12, h: 0.2, fontSize: 12, bold: true, color, align: "center", margin: 0, fit: "shrink" });
}

function arrow(slide, x, y, w, h) {
  slide.addShape(pptx.ShapeType.line, { x, y, w, h, line: { color: C.green2, width: 1.4, beginArrowType: "none", endArrowType: "triangle" } });
}

function metric(slide, value, label, x, y, w = 2.25) {
  card(slide, x, y, w, 0.86, C.white, C.line);
  slide.addText(value, { x, y: y + 0.1, w, h: 0.28, fontSize: 20, bold: true, color: C.green, align: "center", margin: 0 });
  slide.addText(label, { x: x + 0.1, y: y + 0.52, w: w - 0.2, h: 0.13, fontSize: 8.7, color: C.muted, align: "center", margin: 0 });
}

// 1 Cover
let s = pptx.addSlide();
s.background = { color: C.bg };
s.addImage({ path: wordmark, x: 0.76, y: 0.55, w: 3.6, h: 0.72 });
s.addShape(pptx.ShapeType.line, { x: 0.9, y: 1.55, w: 11.25, h: 0, line: { color: C.green, width: 1.2 } });
s.addText("课程设计汇报", { x: 0.92, y: 2.08, w: 2.3, h: 0.24, fontSize: 14, bold: true, color: C.green, margin: 0 });
s.addText("基于 Vue + Spring Boot + MySQL 的\\n菜谱分享与管理系统", { x: 0.9, y: 2.55, w: 7.8, h: 1.08, fontSize: 30, bold: true, color: C.ink, margin: 0, fit: "shrink", breakLine: false });
s.addText("食光菜谱系统：分享美味、记录生活、连接美食社区", { x: 0.94, y: 3.92, w: 7.3, h: 0.28, fontSize: 14, color: C.muted, margin: 0 });
imageCrop(s, homeShot, 8.1, 1.75, 4.6, 3.4, { x: 260, y: 70, w: 1050, h: 610 });
card(s, 0.95, 5.18, 5.8, 0.82, C.white, C.line);
s.addText("姓名：XXX      课程：XXX      班级：XXX\\n日期：2026 年 6 月 1 日", { x: 1.2, y: 5.46, w: 5.3, h: 0.28, fontSize: 11.2, color: C.ink, align: "center", margin: 0, fit: "shrink" });
s.addShape(pptx.ShapeType.rect, { x: 0.9, y: 6.65, w: 11.25, h: 0.16, fill: { color: C.green2 }, line: { color: C.green2 } });

// 2 TOC
s = pptx.addSlide();
title(s, "汇报目录", "参考课程报告结构组织，同时保留每个大板块封面页。", "目录");
["项目背景与需求分析", "系统总体设计", "数据库设计", "系统详细设计", "系统实现", "系统测试", "AI 工具辅助开发总结"].forEach((t, i) => {
  const y = 1.55 + i * 0.68;
  s.addText(`${i + 1}.`, { x: 1.15, y, w: 0.45, h: 0.2, fontSize: 15, bold: true, color: C.green, margin: 0 });
  s.addText(t, { x: 1.72, y, w: 6.2, h: 0.2, fontSize: 15, bold: true, color: C.ink, margin: 0 });
  s.addShape(pptx.ShapeType.line, { x: 8.1, y: y + 0.13, w: 3.55, h: 0, line: { color: C.line, width: 0.8 } });
});
card(s, 8.45, 1.55, 3.55, 3.72, C.bg2, C.line);
bullets(s, ["按参考 PPT 增加数据流图、非功能需求、关系模型和分端实现。", "按本项目代码补充冰箱寻菜、JWT 权限、食材搜索和后台统计。", "复杂插图拆页放大，表格字体统一优化。"], 8.78, 1.95, 2.92, 2.25, 11.2);

sectionCover(1, "项目背景与需求分析", "说明项目来源、用户角色、功能需求和非功能需求。");

s = pptx.addSlide();
title(s, "1.1 项目背景", "从日常做饭和课程实践两个角度说明系统建设必要性。", "01 项目背景与需求分析");
para(s, "随着生活节奏加快，用户在日常做饭时经常面临“想吃什么、家里有什么、怎么做”的问题。菜谱内容如果分散在聊天记录、短视频收藏和零散网页中，检索效率低，也不利于长期沉淀。", 0.95, 1.55, 11.2, 0.72, 14);
para(s, "食光菜谱系统面向美食分享与管理场景，提供菜谱浏览、搜索、发布、收藏、评论和后台治理能力。项目采用 Vue 3 + Spring Boot 3 + MySQL 的前后端分离架构，适合作为课程设计中贯通需求、数据库、接口、前后端联调和测试的综合实践。", 0.95, 2.6, 11.2, 0.88, 14);
metric(s, "Vue 3", "前端组件化与路由", 1.0, 4.35);
metric(s, "Spring Boot", "后端 REST API", 3.75, 4.35);
metric(s, "MySQL 8.4", "关系数据持久化", 6.5, 4.35);
metric(s, "JWT", "登录认证与权限", 9.25, 4.35);

s = pptx.addSlide();
title(s, "1.2 功能需求分析-用户端", "围绕普通用户的内容发现、内容生产和互动闭环设计。", "01 项目背景与需求分析");
table(s, [
  headerRow(["模块", "本项目已实现内容", "对应页面 / 接口"]),
  ["注册登录", "用户名密码注册登录，登录后保存 token 与用户信息", "/login、/register、/api/user/login"],
  ["菜谱浏览", "首页推荐、最新上传、热门榜单、列表分页浏览", "/、/recipes、GET /api/recipe/list"],
  ["搜索筛选", "支持关键词、分类筛选；后端可按标题、简介和食材名匹配", "RecipeService.page"],
  ["菜谱详情", "展示封面、简介、难度、时间、食材、步骤、作者、评论", "/recipe/:id"],
  ["发布菜谱", "填写基础信息、食材清单、制作步骤和小贴士", "/publish、POST /api/recipe"],
  ["收藏评论", "登录用户可收藏/取消收藏，发表评论并刷新详情", "/api/favorite、/api/comment"],
  ["冰箱寻菜", "选择已有食材，按匹配度推荐可做菜谱", "/fridge"],
], 0.72, 1.25, 11.95, 5.4, [1.45, 6.45, 4.05], 9.5);

s = pptx.addSlide();
title(s, "1.3 功能需求分析-管理员端与角色", "管理员负责系统内容治理和基础数据维护。", "01 项目背景与需求分析");
table(s, [
  headerRow(["角色", "核心能力", "权限边界"]),
  ["游客", "浏览首页、菜谱列表、详情、评论列表，按关键词与分类搜索", "仅访问公开 GET 接口"],
  ["普通用户", "发布/编辑/删除自己的菜谱，收藏、评论、维护个人资料", "需携带 JWT；只能管理自己的内容"],
  ["管理员", "统计概览、用户启停、菜谱上下架、分类新增/编辑/删除、评论删除", "访问 /api/admin/**，需 ADMIN 角色"],
], 0.82, 1.45, 11.65, 2.35, [1.4, 6.8, 3.45], 10.5);
[
  ["游客", "浏览菜谱\n搜索筛选\n查看评论"],
  ["普通用户", "发布菜谱\n收藏评论\n个人中心\n冰箱寻菜"],
  ["管理员", "用户启停\n菜谱上下架\n分类维护\n评论治理"],
].forEach((item, i) => {
  const x = 1.0 + i * 4.05;
  card(s, x, 4.25, 3.35, 1.85, i === 1 ? C.bg2 : C.white, C.line);
  s.addText(item[0], { x: x + 0.25, y: 4.55, w: 2.85, h: 0.22, fontSize: 16, bold: true, color: C.green, align: "center", margin: 0 });
  s.addText(item[1], { x: x + 0.25, y: 4.98, w: 2.85, h: 0.62, fontSize: 12.3, color: C.ink, align: "center", margin: 0, breakLine: false, fit: "shrink" });
});

s = pptx.addSlide();
title(s, "1.4 非功能需求分析", "参考报告要求补充性能、安全、易用性和可维护性。", "01 项目背景与需求分析");
[
  ["数据安全性", ["密码使用 BCrypt 加密存储。", "登录态使用 JWT，后台接口校验 ADMIN 角色。", "用户被禁用后 token 无法继续访问受保护接口。"]],
  ["响应性能", ["列表分页查询，pageSize 最大限制 50。", "常用字段建立索引，如 title、status、create_time。", "前端 Axios 设置 15 秒超时并统一错误提示。"]],
  ["界面易用性", ["首页突出搜索、分类入口和推荐卡片。", "发布页按基础信息、食材、步骤分区填写。", "后台通过统计卡片、Tab 和表格组织管理任务。"]],
].forEach((block, i) => {
  const x = 0.85 + i * 4.05;
  card(s, x, 1.55, 3.55, 4.55, C.white, C.line);
  s.addText(block[0], { x: x + 0.25, y: 1.92, w: 2.8, h: 0.22, fontSize: 16, bold: true, color: C.green, margin: 0 });
  bullets(s, block[1], x + 0.28, 2.42, 2.95, 2.4, 11.5);
});

sectionCover(2, "系统总体设计", "从技术架构、数据流和功能模块三个层面描述系统。");

s = pptx.addSlide();
title(s, "2.1 系统总体架构设计", "三层结构：表现层、业务逻辑层、数据层，职责清晰。", "02 系统总体设计");
node(s, "表现层\\nVue 3 + Vite\\nElement Plus", 0.95, 1.65, 3.1, 1.1);
node(s, "业务逻辑层\\nSpring Boot\\nController / Service / Mapper", 5.05, 1.65, 3.4, 1.1);
node(s, "数据层\\nMySQL 8.4\\n7 张核心业务表", 9.5, 1.65, 2.95, 1.1);
arrow(s, 4.15, 2.2, 0.72, 0);
arrow(s, 8.62, 2.2, 0.72, 0);
card(s, 1.0, 3.28, 11.45, 2.5, C.bg2, C.line);
bullets(s, ["前端通过 Vue Router 管理页面路径，通过 Pinia 保存用户登录态，通过 Axios 统一请求 /api。", "后端以 Spring Boot 提供 REST 接口，AuthInterceptor 解析 JWT 并写入 UserContext。", "Service 层承载发布、搜索、收藏、评论、后台管理等业务逻辑，Mapper 层使用 MyBatis-Plus 操作 MySQL。"], 1.35, 3.72, 10.72, 1.2, 13);

s = pptx.addSlide();
title(s, "2.2 系统顶层数据流图", "明确系统与用户、管理员、数据库和静态资源之间的边界。", "02 系统总体设计");
imageContain(s, mmd.topDfd, 0.8, 1.25, 11.9, 5.75, true);

s = pptx.addSlide();
title(s, "2.3 系统 0 层数据流图", "将系统拆分为认证、浏览搜索、发布维护、互动和后台管理五个核心处理过程。", "02 系统总体设计");
imageContain(s, mmd.level0, 0.8, 1.25, 11.9, 5.75, true);

s = pptx.addSlide();
title(s, "2.4 系统功能模块划分（用户端）", "用户端围绕发现、创作和互动展开。", "02 系统总体设计");
["注册登录", "首页推荐", "菜谱列表", "菜谱详情", "发布菜谱", "个人中心", "收藏评论", "冰箱寻菜"].forEach((t, i) => {
  const col = i % 4, row = Math.floor(i / 4);
  node(s, t, 0.95 + col * 3.05, 2.0 + row * 1.45, 2.35, 0.72, i % 2 ? C.white : C.bg2);
});
card(s, 0.95, 5.35, 11.45, 0.72, C.white, C.line);
para(s, "用户端已覆盖菜谱社区主流程：从浏览与搜索进入详情，再完成发布、收藏、评论和个人内容管理。冰箱寻菜根据已有食材计算匹配度，是本项目区别于普通管理系统的体验亮点。", 1.18, 5.56, 10.95, 0.28, 12.5);

s = pptx.addSlide();
title(s, "2.5 系统功能模块划分（管理员端）", "管理员端保持轻量，但覆盖课程项目需要的后台治理能力。", "02 系统总体设计");
node(s, "后台管理", 5.3, 1.4, 2.5, 0.72, C.green2, C.white);
["统计信息", "用户启停", "菜谱上下架", "分类维护", "评论删除"].forEach((t, i) => {
  const x = 0.95 + i * 2.45;
  node(s, t, x, 3.1, 1.85, 0.72, C.white);
  arrow(s, 6.55, 2.14, x + 0.9 - 6.55, 0.88);
});
table(s, [
  headerRow(["管理功能", "接口路径", "项目实现"]),
  ["统计信息", "GET /api/admin/stat", "返回 userCount、recipeCount、categoryCount、commentCount"],
  ["用户管理", "GET /api/admin/user/list；PUT enable/disable", "管理员可启用或禁用用户"],
  ["菜谱管理", "GET /api/admin/recipe/list；PUT /recipe/{id}/disable", "可查看全量菜谱并切换上下架状态"],
  ["分类管理", "POST/PUT/DELETE /api/admin/category", "支持新增、编辑、删除分类"],
], 0.95, 4.55, 11.45, 1.65, [1.85, 4.25, 5.35], 8.6);

s = pptx.addSlide();
title(s, "2.6 开发流程与技术栈", "按课程项目流程推进，形成可运行、可汇报、可维护的系统。", "02 系统总体设计");
["需求分析", "数据库设计", "接口设计", "后端开发", "前端开发", "联调测试", "课程汇报"].forEach((t, i) => {
  node(s, t, 0.75 + i * 1.78, 1.75, 1.35, 0.68, i % 2 ? C.white : C.bg2);
  if (i < 6) arrow(s, 2.1 + i * 1.78, 2.09, 0.35, 0);
});
table(s, [
  headerRow(["层级", "技术栈", "说明"]),
  ["前端", "Vue 3、Vite 6、Element Plus、Vue Router、Pinia、Axios", "组件化页面、路由守卫、统一请求与状态管理"],
  ["后端", "Spring Boot 3.3.7、MyBatis-Plus 3.5.9、JWT、Validation", "REST API、业务分层、认证鉴权、统一返回"],
  ["数据库", "MySQL 8.4、InnoDB、utf8mb4、索引、外键", "保存用户、菜谱、分类、食材、步骤、收藏、评论"],
], 0.9, 3.55, 11.55, 2.1, [1.4, 5.2, 4.95], 10);

sectionCover(3, "数据库设计", "说明 ER 关系、关系模型、字段设计和实体映射。");

s = pptx.addSlide();
title(s, "3.1 数据库设计思路", "以菜谱为中心，连接用户、分类、制作明细和互动数据。", "03 数据库设计");
bullets(s, ["核心实体为 user、category、recipe，分别描述用户、分类和菜谱主体。", "recipe_ingredient 与 recipe_step 拆分菜谱的食材和制作步骤，避免把结构化内容堆在一个字段中。", "favorite 与 comment 描述用户对菜谱的收藏和评论互动，支持社区属性。", "status、deleted、create_time、update_time 等字段用于状态控制、逻辑删除和数据追踪。"], 1.0, 1.55, 11.2, 2.2, 14);
metric(s, "7", "核心业务表", 1.0, 4.55);
metric(s, "8", "主要外键关系", 3.75, 4.55);
metric(s, "MyBatis-Plus", "实体与 Mapper 映射", 6.5, 4.55);
metric(s, "逻辑删除", "deleted 字段控制", 9.25, 4.55);

s = pptx.addSlide();
title(s, "3.2 E-R 图设计", "本页只展示实体关系，字段说明拆到下一页，避免图中文字过小。", "03 数据库设计");
imageContain(s, mmd.er, 1.1, 1.2, 11.1, 5.8, true);

s = pptx.addSlide();
title(s, "3.3 核心数据表关系说明", "将参考 PPT 的关系模型说明迁移为本项目真实表结构。", "03 数据库设计");
table(s, [
  headerRow(["关系", "说明", "涉及字段"]),
  ["用户-菜谱", "一个用户可以发布多条菜谱", "recipe.user_id -> user.id"],
  ["分类-菜谱", "一个分类下可包含多条菜谱", "recipe.category_id -> category.id"],
  ["菜谱-食材", "一个菜谱包含多条食材明细", "recipe_ingredient.recipe_id -> recipe.id"],
  ["菜谱-步骤", "一个菜谱包含多个制作步骤", "recipe_step.recipe_id -> recipe.id"],
  ["用户-收藏-菜谱", "收藏表连接用户和菜谱，并通过唯一约束避免重复收藏", "favorite.user_id + favorite.recipe_id"],
  ["用户-评论-菜谱", "评论表连接评论用户和被评论菜谱", "comment.user_id、comment.recipe_id"],
], 0.72, 1.32, 11.95, 4.75, [2.0, 5.25, 4.7], 10);

s = pptx.addSlide();
title(s, "3.4 关系模型与重点字段", "参考关系模型表格，但压缩为答辩可读的核心字段。", "03 数据库设计");
table(s, [
  headerRow(["表名", "用途", "重点字段"]),
  ["user", "用户账号、资料和角色", "id、username、password、nickname、role、status、deleted"],
  ["category", "菜谱分类", "id、name、icon、sort、status、deleted"],
  ["recipe", "菜谱主体", "id、user_id、category_id、title、cover_image、difficulty、cooking_time、status"],
  ["recipe_ingredient", "食材明细", "id、recipe_id、name、amount、sort"],
  ["recipe_step", "制作步骤", "id、recipe_id、step_no、content、image"],
  ["favorite", "收藏关系", "id、user_id、recipe_id、create_time、deleted"],
  ["comment", "评论内容", "id、user_id、recipe_id、content、status、create_time、deleted"],
], 0.62, 1.25, 12.1, 5.05, [2.0, 2.8, 7.3], 9.4);

s = pptx.addSlide();
title(s, "3.5 MyBatis-Plus 实体映射设计", "对应参考 PPT 的实体类 UML，本项目采用 Entity + Mapper 的数据访问模式。", "03 数据库设计");
node(s, "User / Category / Recipe\\n实体类 Entity", 0.95, 1.55, 3.35, 0.88);
node(s, "UserMapper / RecipeMapper\\nMyBatis-Plus Mapper", 5.0, 1.55, 3.45, 0.88);
node(s, "ServiceImpl\\n组合业务逻辑", 9.25, 1.55, 2.95, 0.88);
arrow(s, 4.36, 1.99, 0.5, 0);
arrow(s, 8.52, 1.99, 0.5, 0);
table(s, [
  headerRow(["实现文件", "职责"]),
  ["entity/User.java、Recipe.java、Comment.java 等", "与数据库表字段对应，承载持久化对象"],
  ["mapper/UserMapper.java、RecipeMapper.java 等", "继承 MyBatis-Plus 基础能力，完成 CRUD 与分页查询"],
  ["service/impl/RecipeServiceImpl.java", "发布菜谱时写入 recipe 主表，并替换食材和步骤子表"],
  ["service/impl/FavoriteServiceImpl.java", "收藏/取消收藏后刷新 recipe.favorite_count"],
  ["service/impl/CommentServiceImpl.java", "发表评论/删除评论后刷新 recipe.comment_count"],
], 0.95, 3.25, 11.4, 2.52, [4.6, 6.8], 9.8);

sectionCover(4, "系统详细设计", "拆解页面、分层、接口、权限和核心业务流程。");

s = pptx.addSlide();
title(s, "4.1 前端页面与路由设计", "路由守卫区分公开页面、登录页面和管理员页面。", "04 系统详细设计");
table(s, [
  headerRow(["路由", "页面", "访问要求"]),
  ["/", "首页 Home", "公开"],
  ["/recipes", "菜谱列表 RecipeList", "公开"],
  ["/fridge", "冰箱寻菜 FridgeFinder", "公开浏览，依赖菜谱数据"],
  ["/recipe/:id", "菜谱详情 RecipeDetail", "公开；收藏评论需登录"],
  ["/login、/register", "登录注册", "公开"],
  ["/publish", "发布菜谱", "auth"],
  ["/profile", "个人中心", "auth"],
  ["/admin", "后台管理", "auth + admin"],
], 0.8, 1.25, 11.65, 5.3, [2.15, 4.65, 4.85], 9.8);

s = pptx.addSlide();
title(s, "4.2 后端分层设计", "Controller 接口入口、Service 业务规则、Mapper 数据访问、VO 返回视图数据。", "04 系统详细设计");
node(s, "Controller\\n接收请求与参数", 0.9, 1.55, 2.2, 0.82);
node(s, "DTO\\n请求数据对象", 3.55, 1.55, 2.0, 0.82);
node(s, "Service\\n业务处理", 6.0, 1.55, 2.0, 0.82);
node(s, "Mapper\\n数据库访问", 8.45, 1.55, 2.0, 0.82);
node(s, "VO / Result\\n统一响应", 10.9, 1.55, 1.75, 0.82);
[3.13, 5.58, 8.03, 10.48].forEach((x) => arrow(s, x, 1.96, 0.32, 0));
table(s, [
  headerRow(["层级", "项目文件示例", "职责"]),
  ["Controller", "UserController、RecipeController、AdminController", "声明 REST 路径，接收请求并返回 Result"],
  ["Service", "RecipeServiceImpl、FavoriteServiceImpl、CommentServiceImpl", "登录校验、发布保存、计数刷新、权限判断"],
  ["Mapper", "RecipeMapper、FavoriteMapper、CommentMapper", "执行 MyBatis-Plus 查询与更新"],
  ["DTO/VO", "RecipeRequest、LoginVO、RecipeVO、CommentVO", "隔离请求参数与前端展示结构"],
], 0.9, 3.3, 11.55, 2.65, [1.5, 4.3, 5.75], 9.4);

s = pptx.addSlide();
title(s, "4.3 登录认证与权限流程", "JWT 贯穿前端状态、请求头和后端拦截器。", "04 系统详细设计");
["填写账号密码", "POST /api/user/login", "返回 token + user", "Pinia + localStorage 保存", "Axios 携带 Bearer Token", "AuthInterceptor 校验", "UserContext 注入身份"].forEach((t, i) => {
  node(s, t, 0.7 + (i % 4) * 3.15, 1.45 + Math.floor(i / 4) * 1.55, 2.35, 0.68, i % 2 ? C.white : C.bg2);
  if (i < 6 && i !== 3) arrow(s, 3.05 + (i % 4) * 3.15, 1.79 + Math.floor(i / 4) * 1.55, 0.45, 0);
});
card(s, 0.9, 5.0, 11.55, 0.82, C.white, C.line);
para(s, "公开接口包括登录、注册、分类列表、菜谱列表、菜谱详情和评论列表；发布、收藏、评论、个人中心与后台管理均需要通过 JWT 校验。", 1.15, 5.28, 11.0, 0.24, 12.5);

s = pptx.addSlide();
title(s, "4.4 发布菜谱流程设计", "主表保存与食材、步骤子表写入构成发布事务。", "04 系统详细设计");
["进入发布页", "路由守卫校验登录", "填写基础信息", "维护食材清单", "维护制作步骤", "POST /api/recipe", "保存 recipe 主表", "写入 ingredient / step", "跳转详情页"].forEach((t, i) => {
  const x = 0.75 + (i % 3) * 4.1, y = 1.35 + Math.floor(i / 3) * 1.55;
  node(s, t, x, y, 3.0, 0.68, i % 2 ? C.white : C.bg2);
});
arrow(s, 3.78, 1.69, 0.85, 0); arrow(s, 7.88, 1.69, 0.85, 0);
arrow(s, 3.78, 3.24, 0.85, 0); arrow(s, 7.88, 3.24, 0.85, 0);
arrow(s, 3.78, 4.79, 0.85, 0); arrow(s, 7.88, 4.79, 0.85, 0);

s = pptx.addSlide();
title(s, "4.5 收藏、评论与冰箱寻菜流程", "体现项目实际实现中的互动和推荐思路。", "04 系统详细设计");
card(s, 0.8, 1.35, 3.65, 4.7, C.white, C.line);
s.addText("收藏流程", { x: 1.08, y: 1.72, w: 2.2, h: 0.22, fontSize: 15, bold: true, color: C.green, margin: 0 });
bullets(s, ["点击收藏按钮", "后端检查菜谱存在", "写入或恢复 favorite", "刷新 favorite_count"], 1.08, 2.18, 2.8, 2.15, 12);
card(s, 4.85, 1.35, 3.65, 4.7, C.white, C.line);
s.addText("评论流程", { x: 5.13, y: 1.72, w: 2.2, h: 0.22, fontSize: 15, bold: true, color: C.green, margin: 0 });
bullets(s, ["登录后输入评论", "POST /api/comment", "写入 comment 表", "刷新 comment_count"], 5.13, 2.18, 2.8, 2.15, 12);
card(s, 8.9, 1.35, 3.65, 4.7, C.white, C.line);
s.addText("冰箱寻菜", { x: 9.18, y: 1.72, w: 2.2, h: 0.22, fontSize: 15, bold: true, color: C.green, margin: 0 });
bullets(s, ["选择已有食材", "加载菜谱食材", "计算主料/调味料匹配度", "按匹配度排序推荐"], 9.18, 2.18, 2.8, 2.15, 12);

s = pptx.addSlide();
title(s, "4.6 接口交互时序图", "前后端通过统一 /api 前缀交互，Result<T> 简化前端处理。", "04 系统详细设计");
imageContain(s, mmd.api, 0.85, 1.25, 11.75, 5.75, true);

s = pptx.addSlide();
title(s, "4.7 接口设计示例", "选取答辩中最容易说明的代表接口。", "04 系统详细设计");
table(s, [
  headerRow(["场景", "方法与路径", "请求/响应", "认证"]),
  ["登录", "POST /api/user/login", "LoginRequest -> LoginVO(token、user)", "否"],
  ["发布菜谱", "POST /api/recipe", "RecipeRequest -> RecipeVO", "是"],
  ["查询列表", "GET /api/recipe/list", "page、pageSize、keyword、categoryId -> PageResult", "否"],
  ["查询详情", "GET /api/recipe/{id}", "id -> RecipeVO(作者、分类、食材、步骤、评论)", "否"],
  ["收藏", "POST/DELETE /api/favorite/{recipeId}", "刷新收藏关系与 favorite_count", "是"],
  ["评论", "POST /api/comment", "CommentRequest -> CommentVO", "是"],
  ["后台统计", "GET /api/admin/stat", "userCount、recipeCount、categoryCount、commentCount", "管理员"],
], 0.62, 1.2, 12.1, 5.55, [1.35, 3.65, 5.2, 1.9], 8.8);

sectionCover(5, "系统实现", "从用户端、管理员端、后端和界面展示说明系统成果。");

s = pptx.addSlide();
title(s, "5.1 系统实现-用户端", "用户端功能开发以美食社区体验为核心。", "05 系统实现");
bullets(s, ["实现注册登录，登录后 Pinia 保存 token 和用户信息。", "实现首页推荐、热门榜单、分类入口和关键词搜索。", "实现菜谱列表分页、分类筛选和后端食材名匹配搜索。", "实现菜谱详情、食材步骤展示、收藏和评论。", "实现发布菜谱表单，支持动态添加食材和步骤。", "实现冰箱寻菜，按已有食材计算菜谱匹配度。"], 0.95, 1.45, 6.0, 4.5, 14);
imageCrop(s, homeShot, 7.25, 1.45, 5.05, 4.3, { x: 0, y: 70, w: 1350, h: 700 });

s = pptx.addSlide();
title(s, "5.2 系统实现-管理员端", "管理员端覆盖轻量后台管理场景。", "05 系统实现");
bullets(s, ["实现管理员账号登录和角色区分，非 ADMIN 无法访问后台接口。", "实现统计信息面板，展示用户、菜谱、分类、评论数量。", "实现用户列表与启用/禁用操作。", "实现菜谱管理列表和上下架状态切换。", "实现分类新增、编辑、删除。", "实现评论删除接口，用于内容治理。"], 0.95, 1.45, 6.25, 4.5, 14);
card(s, 7.55, 1.45, 4.35, 4.35, C.white, C.line);
s.addText("后台管理页结构", { x: 7.88, y: 1.85, w: 2.5, h: 0.22, fontSize: 16, bold: true, color: C.green, margin: 0 });
["统计卡片", "用户 Tab", "菜谱 Tab", "分类 Tab", "表格操作"].forEach((t, i) => node(s, t, 8.02, 2.35 + i * 0.55, 3.4, 0.35, i % 2 ? C.bg2 : C.white));

s = pptx.addSlide();
title(s, "5.3 系统实现-后端与数据库", "后端实现围绕认证、业务处理、统一响应和数据一致性。", "05 系统实现");
table(s, [
  headerRow(["实现点", "项目代码", "说明"]),
  ["统一响应", "Result、PageResult", "前端只需要判断 code 和 data"],
  ["统一异常", "BusinessException、GlobalExceptionHandler", "业务错误转为明确提示"],
  ["认证拦截", "AuthInterceptor、JwtUtil、UserContext", "解析 token，校验用户状态与管理员角色"],
  ["菜谱事务", "RecipeServiceImpl.create/update", "主表与食材、步骤子表保持一致"],
  ["互动计数", "FavoriteServiceImpl、CommentServiceImpl", "收藏/评论变更后刷新统计字段"],
  ["初始化数据", "DataInitializer", "初始化 admin 账号和分类数据，补齐 like_count 字段"],
], 0.72, 1.25, 11.95, 5.25, [2.0, 3.8, 6.15], 9.2);

s = pptx.addSlide();
title(s, "5.4 系统界面展示-首页与社区体验", "图片放大展示，避免参考图中多图并列导致看不清。", "05 系统实现");
imageCrop(s, homeShot, 0.72, 1.15, 11.95, 5.65, { x: 0, y: 0, w: 1672, h: 760 });

s = pptx.addSlide();
title(s, "5.5 系统界面展示-分类、推荐与热门榜单", "截取关键区域，突出“美食社区感”。", "05 系统实现");
imageCrop(s, homeShot, 0.72, 1.18, 11.95, 5.35, { x: 35, y: 330, w: 1580, h: 540 });

sectionCover(6, "系统测试", "说明测试环境、测试范围、功能测试和接口数据库测试结论。");

s = pptx.addSlide();
title(s, "6.1 测试环境与测试策略", "覆盖页面、接口、数据库和权限边界。", "06 系统测试");
table(s, [
  headerRow(["类别", "环境 / 工具", "测试重点"]),
  ["操作系统", "Windows", "本地开发、运行与演示"],
  ["前端", "Node.js、Vite、Vue 3、Element Plus", "页面跳转、表单交互、状态提示"],
  ["后端", "JDK 17、Spring Boot 3.3.7", "REST 接口、JWT 拦截、业务逻辑"],
  ["数据库", "MySQL 8.4、DBeaver / Workbench", "表结构、外键关系、写入结果"],
  ["接口工具", "Postman / Apifox", "登录、发布、收藏、评论、后台接口"],
], 0.85, 1.35, 11.55, 3.45, [1.8, 4.3, 5.45], 10.5);
metric(s, "功能测试", "验证用户主流程", 1.0, 5.35);
metric(s, "接口测试", "验证 Result 和权限", 3.75, 5.35);
metric(s, "数据库测试", "验证关联写入", 6.5, 5.35);
metric(s, "通过", "核心功能结论", 9.25, 5.35);

s = pptx.addSlide();
title(s, "6.2 功能测试结果表", "将主要业务场景逐项验证。", "06 系统测试");
table(s, [
  headerRow(["测试项", "测试操作", "预期结果", "结论"]),
  ["注册", "填写用户名、密码、昵称提交", "账号创建成功，可进入登录流程", "通过"],
  ["登录", "输入正确账号密码", "返回 token 和用户信息", "通过"],
  ["菜谱浏览", "进入首页、列表、分类筛选、关键词搜索", "返回匹配菜谱并正常分页", "通过"],
  ["发布菜谱", "填写分类、标题、食材、步骤后提交", "生成菜谱并可进入详情页", "通过"],
  ["收藏", "登录后收藏/取消收藏菜谱", "收藏状态和 favorite_count 更新", "通过"],
  ["评论", "登录后发表评论并刷新详情", "评论写入并显示在评论列表", "通过"],
  ["冰箱寻菜", "选择已有食材后搜索", "按匹配度展示可做菜谱", "通过"],
  ["后台管理", "管理员启停用户、上下架菜谱、维护分类", "管理操作生效，非管理员被拦截", "通过"],
], 0.55, 1.15, 12.25, 5.75, [1.35, 4.0, 5.0, 1.9], 8.4);

s = pptx.addSlide();
title(s, "6.3 接口测试与数据库测试", "接口返回、权限校验和数据写入共同验证系统可用性。", "06 系统测试");
card(s, 0.85, 1.35, 5.55, 4.6, C.white, C.line);
s.addText("接口测试", { x: 1.15, y: 1.72, w: 2.2, h: 0.22, fontSize: 16, bold: true, color: C.green, margin: 0 });
bullets(s, ["登录接口返回 token。", "未携带 token 访问发布、收藏、后台接口会被拦截。", "列表接口支持 page、pageSize、keyword、categoryId。", "后台接口仅 ADMIN 可访问。"], 1.15, 2.2, 4.8, 2.4, 12.2);
card(s, 6.95, 1.35, 5.55, 4.6, C.white, C.line);
s.addText("数据库测试", { x: 7.25, y: 1.72, w: 2.2, h: 0.22, fontSize: 16, bold: true, color: C.green, margin: 0 });
bullets(s, ["发布后检查 recipe 主表写入。", "检查 recipe_ingredient 与 recipe_step 按 recipe_id 关联。", "收藏唯一约束避免重复收藏。", "删除使用 deleted 逻辑删除，便于数据恢复和审计。"], 7.25, 2.2, 4.8, 2.4, 12.2);

sectionCover(7, "AI 工具辅助开发总结", "说明 AI 对需求、设计、实现、测试和文档整理的辅助价值。");

s = pptx.addSlide();
title(s, "7.1 AI 工具使用总览表", "AI 提效，但项目理解、调试和最终取舍仍由开发者完成。", "07 AI 工具辅助开发总结");
table(s, [
  headerRow(["工具", "使用场景", "具体帮助", "注意事项"]),
  ["ChatGPT", "需求分析、数据库设计、SQL 学习、开发流程梳理、文档生成", "形成结构化思路，辅助解释技术点", "需结合代码和运行结果验证"],
  ["Google Stitch", "前端页面灵感设计、UI 风格参考", "帮助确定温暖、美食社区视觉方向", "设计稿需要转化为真实组件"],
  ["GitHub Copilot / Cursor / Trae", "代码补全、组件生成、Bug 排查", "提升样板代码和重复逻辑编写效率", "生成代码必须阅读、调试、改造"],
  ["DBeaver / Workbench", "数据库管理与 SQL 测试", "查看表结构、验证数据写入与关联", "注意外键、编码和测试数据清理"],
], 0.55, 1.25, 12.25, 5.2, [2.05, 3.65, 3.55, 3.0], 8.4);

s = pptx.addSlide();
title(s, "7.2 AI 辅助开发作用总结", "把 AI 当作学习和工程辅助工具，而不是替代实现。", "07 AI 工具辅助开发总结");
["提高效率：快速梳理需求、生成接口清单、辅助 SQL 与文档。", "辅助学习：解释 JWT、MyBatis-Plus、Vue Router、Pinia 等技术点。", "规范流程：帮助把需求分析、数据库设计、接口设计、测试记录串成完整报告。", "保持主导：核心业务理解、代码调试、数据验证和答辩表达仍需要自己完成。"].forEach((t, i) => {
  card(s, 1.05, 1.45 + i * 1.05, 11.2, 0.72, i % 2 ? C.white : C.bg2, C.line);
  para(s, t, 1.35, 1.65 + i * 1.05, 10.55, 0.2, 13.2);
});

s = pptx.addSlide();
title(s, "项目总结与后续优化", "完成了一个覆盖内容分享、互动和后台治理的前后端分离课程项目。", "总结");
card(s, 0.9, 1.4, 3.55, 3.6, C.white, C.line);
s.addText("项目总结", { x: 1.18, y: 1.78, w: 2.2, h: 0.22, fontSize: 16, bold: true, color: C.green, margin: 0 });
bullets(s, ["实现菜谱分享与管理主流程。", "完成 Vue + Spring Boot + MySQL 联调。", "覆盖用户端、后台端和测试汇报材料。"], 1.18, 2.25, 2.8, 1.7, 12);
card(s, 4.9, 1.4, 3.55, 3.6, C.white, C.line);
s.addText("收获与不足", { x: 5.18, y: 1.78, w: 2.2, h: 0.22, fontSize: 16, bold: true, color: C.green, margin: 0 });
bullets(s, ["掌握前后端分离开发流程。", "理解关系建模和接口设计。", "图片上传、移动端细节和部署仍可加强。"], 5.18, 2.25, 2.8, 1.7, 12);
card(s, 8.9, 1.4, 3.55, 3.6, C.white, C.line);
s.addText("后续优化", { x: 9.18, y: 1.78, w: 2.2, h: 0.22, fontSize: 16, bold: true, color: C.green, margin: 0 });
bullets(s, ["图片上传与裁剪。", "AI 菜谱推荐。", "移动端适配。", "营养分析。", "部署上线。"], 9.18, 2.25, 2.8, 1.7, 12);
s.addText("感谢聆听！", { x: 4.55, y: 5.85, w: 4.2, h: 0.4, fontSize: 28, bold: true, color: C.ink, align: "center", margin: 0 });

await pptx.writeFile({ fileName: pptPath });
console.log(`PPT written: ${pptPath}`);
console.log(`Diagram sources: ${diagramDir}`);
console.log(`Diagram images: ${assetDir}`);
