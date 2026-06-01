import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import pptxgen from "pptxgenjs";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const root = path.resolve(__dirname, "..");
const assetsDir = path.join(root, "assets");
const outputDir = path.join(root, "output");
const pptPath = path.join(outputDir, "test_project_report.pptx");

fs.mkdirSync(outputDir, { recursive: true });

const requiredImages = [
  path.join(assetsDir, "test_architecture.png"),
  path.join(assetsDir, "test_er.png"),
  path.join(assetsDir, "science_plot.png"),
];

const missingImages = requiredImages.filter((imagePath) => !fs.existsSync(imagePath));
if (missingImages.length > 0) {
  throw new Error(`Missing generated image(s): ${missingImages.join(", ")}`);
}

const pptx = new pptxgen();
pptx.layout = "LAYOUT_WIDE";
pptx.author = "Shiguang Recipe System";
pptx.company = "Course Project";
pptx.subject = "PPT generation toolchain smoke test";
pptx.title = "Shiguang Recipe System PPT Toolchain Test";
pptx.lang = "zh-CN";
pptx.theme = {
  headFontFace: "Microsoft YaHei",
  bodyFontFace: "Microsoft YaHei",
  lang: "zh-CN",
};

const colors = {
  navy: "1f2937",
  blue: "2563eb",
  green: "16a34a",
  orange: "f97316",
  light: "f8fafc",
  muted: "64748b",
};

function addTitle(slide, title, subtitle) {
  slide.addText(title, {
    x: 0.55,
    y: 0.35,
    w: 12.25,
    h: 0.45,
    fontFace: "Microsoft YaHei",
    fontSize: 22,
    bold: true,
    color: colors.navy,
    margin: 0,
  });
  if (subtitle) {
    slide.addText(subtitle, {
      x: 0.58,
      y: 0.83,
      w: 11.8,
      h: 0.28,
      fontFace: "Microsoft YaHei",
      fontSize: 9.5,
      color: colors.muted,
      margin: 0,
    });
  }
  slide.addShape(pptx.ShapeType.line, {
    x: 0.55,
    y: 1.18,
    w: 12.2,
    h: 0,
    line: { color: "e2e8f0", width: 1 },
  });
}

function addFooter(slide) {
  slide.addText("食光菜谱系统 | PPT toolchain smoke test", {
    x: 0.6,
    y: 7.05,
    w: 12.1,
    h: 0.2,
    fontFace: "Microsoft YaHei",
    fontSize: 8,
    color: "94a3b8",
    align: "right",
    margin: 0,
  });
}

let slide = pptx.addSlide();
slide.background = { color: colors.light };
slide.addText("食光菜谱系统", {
  x: 0.75,
  y: 1.35,
  w: 8.5,
  h: 0.75,
  fontFace: "Microsoft YaHei",
  fontSize: 36,
  bold: true,
  color: colors.navy,
  margin: 0,
});
slide.addText("课程汇报 PPT 生成工具链测试", {
  x: 0.8,
  y: 2.22,
  w: 8.5,
  h: 0.38,
  fontFace: "Microsoft YaHei",
  fontSize: 17,
  color: colors.blue,
  margin: 0,
});
slide.addText("PptxGenJS + Mermaid CLI + Matplotlib/SciencePlots", {
  x: 0.82,
  y: 2.75,
  w: 7.2,
  h: 0.32,
  fontFace: "Microsoft YaHei",
  fontSize: 12,
  color: colors.muted,
  margin: 0,
});
slide.addShape(pptx.ShapeType.rect, {
  x: 9.15,
  y: 1.2,
  w: 3.3,
  h: 3.9,
  fill: { color: "ffffff" },
  line: { color: "dbeafe", width: 1 },
  radius: 0.12,
});
slide.addText("Verified Outputs", {
  x: 9.45,
  y: 1.58,
  w: 2.8,
  h: 0.3,
  fontSize: 15,
  bold: true,
  color: colors.navy,
  margin: 0,
});
slide.addText(["Mermaid diagrams", "Scientific chart", "Native .pptx file"].join("\n"), {
  x: 9.48,
  y: 2.15,
  w: 2.6,
  h: 1.2,
  fontSize: 12,
  color: colors.muted,
  breakLine: false,
  fit: "shrink",
  bullet: { type: "ul" },
  paraSpaceAfterPt: 8,
});
addFooter(slide);

slide = pptx.addSlide();
addTitle(slide, "系统架构图导入测试", "Mermaid flowchart exported as PNG and inserted into PowerPoint");
slide.addImage({
  path: path.join(assetsDir, "test_architecture.png"),
  x: 0.85,
  y: 1.45,
  w: 11.65,
  h: 5.2,
});
addFooter(slide);

slide = pptx.addSlide();
addTitle(slide, "数据库 ER 图导入测试", "Mermaid ER diagram exported as PNG and inserted into PowerPoint");
slide.addImage({
  path: path.join(assetsDir, "test_er.png"),
  x: 0.7,
  y: 1.35,
  w: 12.0,
  h: 5.35,
});
addFooter(slide);

slide = pptx.addSlide();
addTitle(slide, "科研/技术数据图导入测试", "Matplotlib + SciencePlots generated chart inserted into PowerPoint");
slide.addImage({
  path: path.join(assetsDir, "science_plot.png"),
  x: 1.1,
  y: 1.45,
  w: 11.0,
  h: 4.95,
});
slide.addText("The chart is generated from local Python code and can be replaced with real testing or experiment data later.", {
  x: 1.1,
  y: 6.47,
  w: 11,
  h: 0.28,
  fontSize: 9.5,
  color: colors.muted,
  align: "center",
  margin: 0,
});
addFooter(slide);

await pptx.writeFile({ fileName: pptPath });
console.log(pptPath);
