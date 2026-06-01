from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import scienceplots


ROOT = Path(__file__).resolve().parents[1]
ASSETS_DIR = ROOT / "assets"
ASSETS_DIR.mkdir(parents=True, exist_ok=True)

plt.style.use(["science", "notebook", "grid"])

weeks = np.arange(1, 7)
data = pd.DataFrame(
    {
        "week": weeks,
        "api_success_rate": [91.2, 94.5, 96.8, 97.6, 98.2, 98.7],
        "avg_response_ms": [420, 360, 310, 280, 245, 230],
    }
)

fig, ax1 = plt.subplots(figsize=(8, 4.5), dpi=180)
ax1.plot(data["week"], data["api_success_rate"], marker="o", color="#2563eb", label="API success rate")
ax1.set_xlabel("Test week")
ax1.set_ylabel("Success rate (%)", color="#2563eb")
ax1.tick_params(axis="y", labelcolor="#2563eb")
ax1.set_ylim(88, 100)

ax2 = ax1.twinx()
ax2.bar(data["week"], data["avg_response_ms"], alpha=0.22, color="#f97316", label="Average response")
ax2.set_ylabel("Average response time (ms)", color="#c2410c")
ax2.tick_params(axis="y", labelcolor="#c2410c")
ax2.set_ylim(0, 500)

fig.suptitle("Recipe System API Smoke Test Trend")
fig.tight_layout()

output_path = ASSETS_DIR / "science_plot.png"
fig.savefig(output_path, bbox_inches="tight")
plt.close(fig)

print(output_path)
