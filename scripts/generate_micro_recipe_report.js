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
const pptPath = path.join(output, "微菜谱系统课程汇报.pptx");

fs.mkdirSync(output, { recursive: true });

const pptx = new pptxgen();
pptx.layout = "LAYOUT_WIDE";
pptx.author = "微菜谱系统";
pptx.company = "Course Project";
pptx.subject = "Vue 3 + Spring Boot + MySQL 课程汇报";
pptx.title = "微菜谱系统课程汇报";
pptx.lang = "zh-CN";
pptx.theme = {
  headFontFace: "Microsoft YaHei",
  bodyFontFace: "Microsoft YaHei",
  lang: "zh-CN",
};
pptx.defineLayout({ name: "LAYOUT_WIDE", width: 13.333, height: 7.5 });

const C = {
  green: "1B7F5F",
  greenDark: "0F513F",
  greenLight: "E8F5EF",
  orange: "EF6C35",
  amber: "F59E0B",
  blue: "2563EB",
  ink: "1F2937",
  muted: "64748B",
  line: "D9E4DD",
  soft: "F7FBF8",
  white: "FFFFFF",
};

function img(name) {
  return path.join(assets, name);
}

function rootImg(name) {
  return path.join(root, name);
}

function addBg(slide, section = "") {
  slide.background = { color: C.white };
  slide.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: 13.333, h: 0.16, fill: { color: C.green }, line: { color: C.green } });
  slide.addShape(pptx.ShapeType.rect, { x: 0, y: 7.24, w: 13.333, h: 0.26, fill: { color: C.soft }, line: { color: C.soft } });
  slide.addText("微菜谱系统", { x: 0.45, y: 7.28, w: 2, h: 0.14, fontSize: 7.5, bold: true, color: C.green, margin: 0 });
  slide.addText(section, { x: 9.2, y: 7.28, w: 3.65, h: 0.14, fontSize: 7.5, color: "94A3B8", align: "right", margin: 0 });
}

function title(slide, text, subtitle = "", section = "") {
  addBg(slide, section);
  slide.addShape(pptx.ShapeType.rect, { x: 0.55, y: 0.52, w: 0.1, h: 0.44, fill: { color: C.orange }, line: { color: C.orange } });
  slide.addText(text, { x: 0.75, y: 0.48, w: 8.9, h: 0.42, fontSize: 22, bold: true, color: C.ink, margin: 0 });
  if (subtitle) {
    slide.addText(subtitle, { x: 0.77, y: 0.96, w: 11.9, h: 0.23, fontSize: 9.5, color: C.muted, margin: 0 });
  }
  slide.addShape(pptx.ShapeType.line, { x: 0.55, y: 1.26, w: 12.15, h: 0, line: { color: C.line, width: 0.8 } });
}

function sectionSlide(no, heading, subheading) {
  const slide = pptx.addSlide();
  slide.background = { color: C.soft };
  slide.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: 4.2, h: 7.5, fill: { color: C.green }, line: { color: C.green } });
  slide.addText(`PART ${no}`, { x: 0.72, y: 2.2, w: 2.8, h: 0.35, fontSize: 17, bold: true, color: "DDF6EA", margin: 0 });
  slide.addText(heading, { x: 0.72, y: 2.72, w: 3.05, h: 0.72, fontSize: 25, bold: true, color: C.white, margin: 0, breakLine: false, fit: "shrink" });
  slide.addShape(pptx.ShapeType.line, { x: 4.85, y: 1.05, w: 0, h: 5.4, line: { color: C.green, width: 1.2 } });
  slide.addText(subheading, { x: 5.45, y: 2.55, w: 6.7, h: 1.05, fontSize: 24, bold: true, color: C.ink, margin: 0, fit: "shrink" });
  slide.addText("基于当前代码与数据库设计整理", { x: 5.48, y: 3.82, w: 5.4, h: 0.26, fontSize: 11, color: C.muted, margin: 0 });
  return slide;
}

function bullets(slide, items, x, y, w, h, options = {}) {
  const runs = items.map((item) => ({
    text: item,
    options: {
      bullet: { type: "ul" },
      breakLine: true,
      hanging: 3,
    },
  }));
  slide.addText(runs, {
    x, y, w, h,
    fontSize: options.fontSize || 13,
    color: options.color || C.ink,
    fit: "shrink",
    paraSpaceAfterPt: options.spaceAfter || 8,
    margin: 0.04,
    breakLine: false,
  });
}

function card(slide, x, y, w, h, opts = {}) {
  slide.addShape(pptx.ShapeType.roundRect, {
    x, y, w, h,
    rectRadius: 0.08,
    fill: { color: opts.fill || C.white, transparency: opts.transparency ?? 0 },
    line: { color: opts.line || C.line, width: opts.width || 0.8 },
  });
}

function metric(slide, x, y, w, label, value, color = C.green) {
  card(slide, x, y, w, 0.92, { fill: "FBFEFC", line: "DCEADF" });
  slide.addText(value, { x: x + 0.18, y: y + 0.16, w: w - 0.36, h: 0.27, fontSize: 17, bold: true, color, margin: 0, align: "center" });
  slide.addText(label, { x: x + 0.18, y: y + 0.52, w: w - 0.36, h: 0.18, fontSize: 8.5, color: C.muted, margin: 0, align: "center" });
}

function addImageContain(slide, imagePath, x, y, w, h, withBorder = true) {
  if (withBorder) card(slide, x, y, w, h, { fill: C.white, line: "E2E8F0" });
  const { width, height } = imageSize(imagePath);
  const ratio = Math.min((w - 0.18) / width, (h - 0.18) / height);
  const iw = width * ratio;
  const ih = height * ratio;
  slide.addImage({ path: imagePath, x: x + (w - iw) / 2, y: y + (h - ih) / 2, w: iw, h: ih });
}

function addImageCover(slide, imagePath, x, y, w, h) {
  const { width, height } = imageSize(imagePath);
  const srcRatio = width / height;
  const boxRatio = w / h;
  let sizing;
  if (srcRatio > boxRatio) {
    const cropW = Math.round(height * boxRatio);
    const cropX = Math.round((width - cropW) / 2);
    sizing = { type: "crop", x, y, w, h, crop: { x: cropX, y: 0, w: cropW, h: height } };
  } else {
    const cropH = Math.round(width / boxRatio);
    const cropY = Math.round((height - cropH) / 2);
    sizing = { type: "crop", x, y, w, h, crop: { x: 0, y: cropY, w: width, h: cropH } };
  }
  slide.addImage({ path: imagePath, ...sizing });
}

function table(slide, rows, x, y, w, h, widths) {
  slide.addTable(rows, {
    x, y, w, h,
    border: { type: "solid", color: "D8E8DF", pt: 0.8 },
    margin: 0.05,
    fontFace: "Microsoft YaHei",
    fontSize: 9.2,
    color: C.ink,
    fit: "shrink",
    colW: widths,
  });
}

let slide = pptx.addSlide();
slide.background = { color: C.soft };
slide.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: 13.333, h: 0.18, fill: { color: C.green }, line: { color: C.green } });
slide.addShape(pptx.ShapeType.rect, { x: 0, y: 0.18, w: 4.25, h: 7.32, fill: { color: C.green }, line: { color: C.green } });
slide.addText("微菜谱系统", { x: 0.72, y: 1.2, w: 3.1, h: 0.52, fontSize: 30, bold: true, color: C.white, margin: 0 });
slide.addText("课程汇报 PPT", { x: 0.75, y: 1.88, w: 2.7, h: 0.34, fontSize: 17, color: "DDF6EA", margin: 0 });
slide.addShape(pptx.ShapeType.line, { x: 0.76, y: 2.48, w: 2.85, h: 0, line: { color: "BFEAD8", width: 1.2 } });
slide.addText("Vue 3 + Spring Boot 3 + MyBatis-Plus + MySQL", { x: 0.78, y: 2.72, w: 3.0, h: 0.52, fontSize: 11, color: C.white, fit: "shrink", margin: 0 });
slide.addText("基于当前前后端代码与数据库设计生成", { x: 0.78, y: 6.62, w: 3.0, h: 0.2, fontSize: 8.5, color: "DDF6EA", margin: 0 });
addImageCover(slide, rootImg("design.png"), 4.75, 0.74, 7.72, 5.34);
card(slide, 5.25, 6.32, 6.75, 0.6, { fill: C.white, line: "E0EFE6" });
slide.addText("普通用户：浏览、搜索、发布、收藏、评论   |   管理员：用户启停、菜谱上下架、分类维护", { x: 5.48, y: 6.52, w: 6.3, h: 0.16, fontSize: 8.5, color: C.muted, align: "center", margin: 0 });

slide = pptx.addSlide();
title(slide, "汇报目录", "参考课程设计汇报结构，围绕需求、设计、实现、测试与总结展开", "目录");
const toc = [
  ["01", "项目背景与需求分析", "明确系统要解决的菜谱分享、检索、互动与后台管理问题"],
  ["02", "系统总体设计", "前端路由、后端分层、数据库 ER 和核心业务流程"],
  ["03", "核心功能实现", "登录认证、菜谱发布、收藏评论、后台管理接口"],
  ["04", "测试结果与总结", "构建验证、后续优化方向和项目收获"],
];
toc.forEach((item, idx) => {
  const y = 1.65 + idx * 1.18;
  card(slide, 0.85, y, 11.65, 0.86, { fill: idx % 2 ? "FBFEFC" : C.white, line: "DCEADF" });
  slide.addText(item[0], { x: 1.1, y: y + 0.19, w: 0.7, h: 0.26, fontSize: 18, bold: true, color: idx % 2 ? C.orange : C.green, margin: 0 });
  slide.addText(item[1], { x: 2.0, y: y + 0.15, w: 3.6, h: 0.25, fontSize: 14.5, bold: true, color: C.ink, margin: 0 });
  slide.addText(item[2], { x: 5.7, y: y + 0.19, w: 6.2, h: 0.23, fontSize: 10.5, color: C.muted, margin: 0 });
});

sectionSlide("01", "项目背景", "从菜谱分享与课程实践出发");

slide = pptx.addSlide();
title(slide, "项目背景与建设目标", "面向家庭做饭、菜谱收藏与课程实践的综合 Web 系统", "项目背景");
card(slide, 0.75, 1.58, 5.8, 4.8, { fill: "FBFEFC" });
slide.addText("问题背景", { x: 1.08, y: 1.92, w: 1.9, h: 0.25, fontSize: 15, bold: true, color: C.green, margin: 0 });
bullets(slide, [
  "传统菜谱内容分散，难以统一管理和检索",
  "用户需要按分类、关键词、食材快速找到菜谱",
  "菜谱不只是浏览内容，还需要收藏、评论和二次管理",
  "课程项目需要覆盖前端、后端、数据库与接口联调"
], 1.1, 2.38, 5.05, 2.6, { fontSize: 12.2 });
card(slide, 6.85, 1.58, 5.72, 4.8, { fill: C.white });
slide.addText("系统目标", { x: 7.18, y: 1.92, w: 1.9, h: 0.25, fontSize: 15, bold: true, color: C.orange, margin: 0 });
bullets(slide, [
  "实现可运行的微菜谱分享与管理平台",
  "支持注册登录、发布菜谱、详情查看、收藏与评论",
  "管理员可进行用户、菜谱、分类维护",
  "形成清晰的 Controller-Service-Mapper 分层与关系型数据库设计"
], 7.2, 2.38, 4.95, 2.6, { fontSize: 12.2 });

slide = pptx.addSlide();
title(slide, "需求分析：用户角色与功能边界", "系统围绕普通用户和管理员两类角色展开", "需求分析");
table(slide, [
  [
    { text: "角色", options: { bold: true, fill: C.green, color: C.white } },
    { text: "核心需求", options: { bold: true, fill: C.green, color: C.white } },
    { text: "对应页面 / 接口", options: { bold: true, fill: C.green, color: C.white } },
  ],
  ["游客", "浏览首页、菜谱列表、分类与关键词检索、查看详情和评论", "/、/recipes、/recipe/:id、GET /api/recipe/list"],
  ["普通用户", "注册登录、发布菜谱、收藏菜谱、发表评论、维护个人资料", "/publish、/profile、POST /api/recipe、POST /api/comment"],
  ["管理员", "统计数据、用户启停、菜谱上下架、分类新增编辑删除", "/admin、/api/admin/**"],
], 0.85, 1.68, 11.65, 2.3, [1.25, 5.15, 5.25]);
metric(slide, 0.95, 4.55, 2.25, "核心数据表", "7", C.green);
metric(slide, 3.45, 4.55, 2.25, "前端路由", "9", C.orange);
metric(slide, 5.95, 4.55, 2.25, "后端控制器", "6", C.blue);
metric(slide, 8.45, 4.55, 2.25, "主要业务模块", "6", C.greenDark);
slide.addText("功能覆盖：用户、菜谱、分类、收藏、评论、后台管理。权限覆盖：游客公开访问、登录用户互动、管理员后台治理。", { x: 0.95, y: 5.82, w: 10.8, h: 0.42, fontSize: 12, color: C.muted, margin: 0, fit: "shrink" });

sectionSlide("02", "系统设计", "从架构、路由、分层、数据关系展开");

slide = pptx.addSlide();
title(slide, "技术栈与工程结构", "前后端分离，根目录下保留课程报告与图表生成工具链", "技术栈");
const techRows = [
  ["前端", "Vue 3、Vite 6、Vue Router、Pinia、Axios、Element Plus", "页面组件、路由守卫、状态管理、接口请求"],
  ["后端", "Spring Boot 3.3.7、MyBatis-Plus 3.5.9、JWT、BCrypt", "REST API、认证鉴权、业务分层、数据访问"],
  ["数据库", "MySQL 8.4、InnoDB、utf8mb4、主外键与索引", "用户、菜谱、分类、食材、步骤、收藏、评论"],
  ["汇报工具", "PptxGenJS、Mermaid CLI、Matplotlib、SciencePlots", "生成架构图、ER 图、流程图、测试图和真实 PPTX"],
];
table(slide, [
  [
    { text: "层级", options: { bold: true, fill: C.green, color: C.white } },
    { text: "主要技术", options: { bold: true, fill: C.green, color: C.white } },
    { text: "承担职责", options: { bold: true, fill: C.green, color: C.white } },
  ],
  ...techRows,
], 0.75, 1.55, 11.85, 3.05, [1.3, 5.05, 5.5]);
slide.addText("工程目录", { x: 0.85, y: 5.05, w: 1.3, h: 0.25, fontSize: 14.5, bold: true, color: C.green, margin: 0 });
bullets(slide, [
  "recipe-system-frontend：Vue 页面、路由、API 封装、Pinia 用户状态",
  "recipe-system-backend：Controller、Service、Mapper、Entity、DTO/VO、Config",
  "docs / diagrams / assets / scripts / output：课程汇报图源、图像、脚本与最终 PPT"
], 1.0, 5.48, 10.8, 1.05, { fontSize: 11.2, spaceAfter: 5 });

slide = pptx.addSlide();
title(slide, "系统总体架构", "Vue 前端通过 /api 代理访问 Spring Boot，后端通过 MyBatis-Plus 操作 MySQL", "系统架构");
addImageContain(slide, img("system_architecture.png"), 0.75, 1.5, 11.85, 5.28);

slide = pptx.addSlide();
title(slide, "前端路由与页面结构", "路由守卫区分公开页面、登录页面和管理员后台", "前端路由");
addImageContain(slide, img("frontend_routing.png"), 0.75, 1.5, 11.85, 5.28);

slide = pptx.addSlide();
title(slide, "后端分层架构", "Controller 接收请求，Service 编排业务，Mapper 负责持久化", "后端分层");
addImageContain(slide, img("backend_layers.png"), 0.75, 1.5, 11.85, 5.28);

slide = pptx.addSlide();
title(slide, "数据库 ER 设计", "7 张核心表支撑菜谱发布、展示、互动与后台治理", "数据库设计");
addImageContain(slide, img("er_diagram.png"), 0.65, 1.42, 12.05, 5.42);

slide = pptx.addSlide();
title(slide, "核心业务流程", "从游客浏览到登录互动，再到管理员治理形成完整闭环", "业务流程");
addImageContain(slide, img("business_flow.png"), 0.8, 1.48, 11.75, 5.35);

sectionSlide("03", "核心实现", "认证、菜谱发布、互动与后台管理");

slide = pptx.addSlide();
title(slide, "API 设计与认证机制", "统一 Result 返回、JWT 鉴权、公开接口和管理接口分离", "API 设计");
table(slide, [
  [
    { text: "模块", options: { bold: true, fill: C.green, color: C.white } },
    { text: "代表接口", options: { bold: true, fill: C.green, color: C.white } },
    { text: "说明", options: { bold: true, fill: C.green, color: C.white } },
  ],
  ["用户", "POST /api/user/login、GET /api/user/current", "登录后返回 token，前端保存并在请求头携带"],
  ["菜谱", "GET /api/recipe/list、POST /api/recipe", "列表公开，发布/编辑/删除需要登录"],
  ["互动", "POST /api/favorite/{id}、POST /api/comment", "收藏和评论会同步刷新统计计数"],
  ["后台", "GET /api/admin/stat、PUT /api/admin/recipe/{id}/disable", "AuthInterceptor 校验 ADMIN 角色"],
], 0.75, 1.48, 11.85, 3.0, [1.3, 4.5, 6.05]);
card(slide, 0.92, 4.98, 11.45, 1.15, { fill: "FBFEFC" });
slide.addText("认证链路", { x: 1.18, y: 5.22, w: 1.2, h: 0.2, fontSize: 12, bold: true, color: C.green, margin: 0 });
slide.addText("登录成功 -> JwtUtil 生成 token -> Pinia/localStorage 保存 -> Axios 注入 Bearer -> AuthInterceptor 解析 -> UserContext 保存当前用户 -> Controller/Service 执行业务", { x: 2.45, y: 5.2, w: 9.55, h: 0.35, fontSize: 10.5, color: C.ink, margin: 0, fit: "shrink" });

slide = pptx.addSlide();
title(slide, "菜谱发布 API 时序图", "发布菜谱同时维护主表、食材表和步骤表", "API 时序");
addImageContain(slide, img("api_sequence.png"), 0.7, 1.42, 12.0, 5.42);

slide = pptx.addSlide();
title(slide, "后台管理 API 时序图", "管理员页面一次性拉取统计、用户、菜谱、分类数据，并可执行状态治理", "后台管理");
addImageContain(slide, img("admin_sequence.png"), 0.7, 1.42, 12.0, 5.42);

slide = pptx.addSlide();
title(slide, "功能实现亮点", "从代码实现看系统的完整性与可维护性", "核心实现");
const highlightRows = [
  ["菜谱发布", "RecipeServiceImpl 使用事务写入 recipe、recipe_ingredient、recipe_step，保持主从数据一致"],
  ["检索筛选", "列表接口支持 page/pageSize、keyword、categoryId；关键词覆盖标题、描述和食材名称"],
  ["互动计数", "收藏与评论后刷新 favorite_count、comment_count，列表展示无需重复聚合"],
  ["权限控制", "AuthInterceptor 对公开接口放行，对登录接口和 /api/admin/** 做 JWT 与角色校验"],
  ["数据治理", "deleted 逻辑删除、status 上下架/启停，兼顾课程演示和数据可追溯"],
];
highlightRows.forEach((row, i) => {
  const y = 1.55 + i * 0.88;
  card(slide, 0.85, y, 11.65, 0.62, { fill: i % 2 ? "FBFEFC" : C.white, line: "DCEADF" });
  slide.addText(row[0], { x: 1.1, y: y + 0.16, w: 1.35, h: 0.18, fontSize: 11.5, bold: true, color: i % 2 ? C.orange : C.green, margin: 0 });
  slide.addText(row[1], { x: 2.65, y: y + 0.13, w: 9.35, h: 0.25, fontSize: 10.2, color: C.ink, fit: "shrink", margin: 0 });
});

slide = pptx.addSlide();
title(slide, "功能界面展示", "首页效果图展示了菜谱社区的核心入口与内容组织方式", "功能展示");
addImageContain(slide, rootImg("design.png"), 0.65, 1.42, 12.05, 5.4);

sectionSlide("04", "测试总结", "验证结果、问题记录与后续优化");

slide = pptx.addSlide();
title(slide, "测试与构建结果", "使用真实命令验证当前工程可编译、前端可构建、PPT 工具链可运行", "测试结果");
addImageContain(slide, img("micro_recipe_test_results.png"), 0.75, 1.55, 6.45, 4.88);
card(slide, 7.55, 1.7, 4.95, 4.5, { fill: "FBFEFC" });
slide.addText("已执行命令", { x: 7.9, y: 2.05, w: 1.8, h: 0.25, fontSize: 14, bold: true, color: C.green, margin: 0 });
bullets(slide, [
  "后端：mvn test，BUILD SUCCESS，当前无测试用例",
  "前端：npm run build，构建成功，生成 dist 产物",
  "图表：Mermaid CLI 导出架构图、ER 图、流程图、时序图",
  "PPT：PptxGenJS 输出真实 .pptx 文件"
], 7.9, 2.55, 4.25, 2.2, { fontSize: 11.2, spaceAfter: 5 });
slide.addText("注意：前端构建提示主 chunk 超过 500 kB，后续可通过 manualChunks 或按路由拆包进一步优化。", { x: 7.9, y: 5.35, w: 4.2, h: 0.34, fontSize: 9.5, color: C.muted, margin: 0, fit: "shrink" });

slide = pptx.addSlide();
title(slide, "项目总结与后续改进", "系统已经覆盖课程项目中的前端、后端、数据库和接口联调关键能力", "总结");
card(slide, 0.8, 1.55, 3.65, 4.7, { fill: "FBFEFC" });
slide.addText("项目收获", { x: 1.12, y: 1.92, w: 1.6, h: 0.25, fontSize: 15, bold: true, color: C.green, margin: 0 });
bullets(slide, ["完成前后端分离工程组织", "实践 JWT 登录认证与路由守卫", "完成关系型数据库建模", "形成可汇报的图表与 PPT 产物"], 1.12, 2.38, 2.9, 2.55, { fontSize: 11.2, spaceAfter: 5 });
card(slide, 4.85, 1.55, 3.65, 4.7, { fill: C.white });
slide.addText("当前不足", { x: 5.17, y: 1.92, w: 1.6, h: 0.25, fontSize: 15, bold: true, color: C.orange, margin: 0 });
bullets(slide, ["自动化测试用例仍需补充", "前端构建包体偏大", "图片上传仍以静态资源为主", "推荐算法仍偏规则化"], 5.17, 2.38, 2.9, 2.55, { fontSize: 11.2, spaceAfter: 5 });
card(slide, 8.9, 1.55, 3.65, 4.7, { fill: "FBFEFC" });
slide.addText("优化方向", { x: 9.22, y: 1.92, w: 1.6, h: 0.25, fontSize: 15, bold: true, color: C.blue, margin: 0 });
bullets(slide, ["补充后端单元测试与接口测试", "前端路由级代码分割", "对象存储或本地上传服务", "个性化推荐、点赞、浏览历史"], 9.22, 2.38, 2.9, 2.55, { fontSize: 11.2, spaceAfter: 5 });

slide = pptx.addSlide();
slide.background = { color: C.soft };
slide.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: 13.333, h: 7.5, fill: { color: C.green }, line: { color: C.green } });
slide.addText("感谢聆听", { x: 3.75, y: 2.72, w: 5.9, h: 0.7, fontSize: 34, bold: true, color: C.white, align: "center", margin: 0 });
slide.addText("微菜谱系统课程汇报", { x: 4.2, y: 3.58, w: 5.0, h: 0.28, fontSize: 13, color: "DDF6EA", align: "center", margin: 0 });
slide.addShape(pptx.ShapeType.line, { x: 4.25, y: 4.16, w: 4.82, h: 0, line: { color: "BFEAD8", width: 1.2 } });

await pptx.writeFile({ fileName: pptPath });
console.log(pptPath);
