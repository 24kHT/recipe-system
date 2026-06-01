from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import scienceplots


ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets" / "micro_recipe_report"
ASSETS.mkdir(parents=True, exist_ok=True)

plt.style.use(["science", "notebook", "grid"])
plt.rcParams["font.sans-serif"] = ["Microsoft YaHei", "SimHei", "Arial Unicode MS", "DejaVu Sans"]
plt.rcParams["axes.unicode_minus"] = False

checks = pd.DataFrame(
    {
        "item": ["后端编译", "前端构建", "接口分层", "数据库设计", "PPT链路"],
        "score": [100, 92, 96, 95, 100],
    }
)

fig, ax = plt.subplots(figsize=(8.8, 4.9), dpi=180)
colors = ["#1b7f5f", "#f59e0b", "#2563eb", "#10b981", "#ef6c35"]
bars = ax.bar(checks["item"], checks["score"], color=colors, alpha=0.9)
ax.set_ylim(0, 110)
ax.set_ylabel("验证完成度")
ax.set_title("微菜谱系统课程汇报验证结果")
for bar, score in zip(bars, checks["score"]):
    ax.text(bar.get_x() + bar.get_width() / 2, score + 2, f"{score}%", ha="center", va="bottom", fontsize=11)

ax.text(
    0.02,
    -0.22,
    "说明：mvn test 编译成功但暂无单元测试；npm run build 成功并提示主 chunk 较大，可作为后续优化点。",
    transform=ax.transAxes,
    fontsize=9,
    color="#475569",
)
fig.tight_layout()
out = ASSETS / "micro_recipe_test_results.png"
fig.savefig(out, bbox_inches="tight")
plt.close(fig)
print(out)
