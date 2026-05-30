#!/usr/bin/env python3
"""
Build a small demo seed dataset from YunYouJun/cook recipe.csv.

Default mode writes a SQL file and local SVG covers without touching MySQL:
  python scripts/import_yunyoujun_cook_seed.py

Optional execute mode imports directly through PyMySQL:
  python scripts/import_yunyoujun_cook_seed.py --execute

The script uses the static CSV from the MIT licensed YunYouJun/cook repository.
It is intentionally not a crawler and caps the demo dataset at 100 recipes.
"""

from __future__ import annotations

import argparse
import csv
import html
import os
import random
import re
import sys
import urllib.request
from dataclasses import dataclass
from datetime import datetime, timedelta
from pathlib import Path


SOURCE_NAME = "YunYouJun/cook"
SOURCE_URL = "https://github.com/YunYouJun/cook"
RAW_CSV_URL = "https://raw.githubusercontent.com/YunYouJun/cook/main/app/data/recipe.csv"
SEED_MARKER = "source:YunYouJun/cook seed:v1"
TARGET_CATEGORIES = ["家常菜", "早餐", "午餐", "晚餐", "甜品", "汤类", "减脂餐", "川菜"]
TARGET_COUNT = 100
DEFAULT_AUTHOR_NAMES = ["食光小厨", "家常料理人", "晚风厨房", "元气早餐铺", "轻食研究员"]


@dataclass
class SourceRecipe:
    name: str
    stuff: list[str]
    bv: str
    difficulty: str
    tags: list[str]
    methods: list[str]
    tools: list[str]


@dataclass
class SeedRecipe:
    title: str
    category: str
    cover: str
    description: str
    difficulty: str
    cooking_time: int
    tips: str
    ingredients: list[tuple[str, str]]
    steps: list[str]
    author: str
    view_count: int
    favorite_count: int
    like_count: int
    created_at: datetime


def split_items(value: str) -> list[str]:
    if not value:
        return []
    return [item.strip() for item in re.split(r"[、,，/|；;]+", value) if item.strip()]


def load_source_csv(csv_path: Path) -> list[SourceRecipe]:
    if not csv_path.exists():
        csv_path.parent.mkdir(parents=True, exist_ok=True)
        print(f"Downloading {RAW_CSV_URL} -> {csv_path}")
        urllib.request.urlretrieve(RAW_CSV_URL, csv_path)

    with csv_path.open("r", encoding="utf-8-sig", newline="") as file:
        reader = csv.DictReader(file)
        recipes = []
        for row in reader:
            name = (row.get("name") or "").strip()
            if not name:
                continue
            recipes.append(
                SourceRecipe(
                    name=name,
                    stuff=split_items(row.get("stuff") or ""),
                    bv=(row.get("bv") or "").strip(),
                    difficulty=(row.get("difficulty") or "简单").strip() or "简单",
                    tags=split_items(row.get("tags") or ""),
                    methods=split_items(row.get("methods") or ""),
                    tools=split_items(row.get("tools") or ""),
                )
            )
    return recipes


def guess_category(recipe: SourceRecipe) -> str:
    text = "".join([recipe.name, *recipe.stuff, *recipe.tags, *recipe.methods, *recipe.tools])
    if any(word in text for word in ["川", "麻辣", "辣子", "水煮", "鱼香", "宫保", "豆瓣", "火锅"]):
        return "川菜"
    if any(word in text for word in ["蛋糕", "甜", "糖", "奶", "布丁", "饼干", "冰", "红豆", "芋圆", "吐司"]):
        return "甜品"
    if any(word in text for word in ["汤", "羹", "煲", "炖", "粥"]):
        return "汤类"
    if any(word in text for word in ["沙拉", "鸡胸", "减脂", "低卡", "蔬菜", "生菜", "玉米", "紫薯"]):
        return "减脂餐"
    if any(word in text for word in ["早餐", "早饭", "煎饼", "包子", "馒头", "豆浆", "油条", "鸡蛋", "面包"]):
        return "早餐"
    if any(word in text for word in ["焖饭", "炒饭", "盖饭", "便当", "米饭", "午餐"]):
        return "午餐"
    if any(word in text for word in ["晚餐", "夜宵", "小炒", "下饭", "烤", "焗"]):
        return "晚餐"
    return "家常菜"


def target_quota() -> dict[str, int]:
    quota = {category: TARGET_COUNT // len(TARGET_CATEGORIES) for category in TARGET_CATEGORIES}
    for category in TARGET_CATEGORIES[: TARGET_COUNT % len(TARGET_CATEGORIES)]:
        quota[category] += 1
    return quota


def choose_recipes(source: list[SourceRecipe]) -> list[tuple[SourceRecipe, str]]:
    buckets: dict[str, list[SourceRecipe]] = {category: [] for category in TARGET_CATEGORIES}
    for item in source:
        buckets[guess_category(item)].append(item)

    quota = target_quota()
    selected: list[tuple[SourceRecipe, str]] = []
    seen_names: set[str] = set()
    remaining = [item for item in source]

    for category in TARGET_CATEGORIES:
        for item in buckets[category]:
            if len([1 for _, cat in selected if cat == category]) >= quota[category]:
                break
            if item.name in seen_names:
                continue
            selected.append((item, category))
            seen_names.add(item.name)

    # Some categories are sparse in the source CSV; fill shortages while preserving target coverage.
    for category in TARGET_CATEGORIES:
        while len([1 for _, cat in selected if cat == category]) < quota[category]:
            fallback = next((item for item in remaining if item.name not in seen_names), None)
            if fallback is None:
                break
            selected.append((fallback, category))
            seen_names.add(fallback.name)

    return selected[:TARGET_COUNT]


def amount_for(index: int, ingredient: str) -> str:
    common = {
        "米": "1杯",
        "鸡蛋": "2个",
        "番茄": "2个",
        "土豆": "1个",
        "鸡肉": "300g",
        "猪肉": "250g",
        "牛肉": "250g",
        "面食": "1份",
        "洋葱": "半个",
        "菌菇": "适量",
    }
    return common.get(ingredient, "适量" if index > 2 else "1份")


def build_steps(recipe: SourceRecipe, category: str) -> tuple[list[str], list[tuple[str, str]]]:
    ingredients = "、".join(recipe.stuff[:5]) or "主要食材"
    method = recipe.methods[0] if recipe.methods else ""
    tool = recipe.tools[0] if recipe.tools else ""
    prep = f"准备好{ingredients}，清洗后按需要切块、切片或分装备用。"
    season = "加入盐、生抽、少许糖等基础调味料，按个人口味调整咸淡。"
    cook = f"使用{tool}{method}至食材成熟入味。" if tool or method else "热锅下油，按易熟程度依次放入食材翻炒至成熟。"
    finish = "出锅前尝味，撒上葱花或香菜点缀，趁热享用。"
    extra: list[tuple[str, str]] = [("盐", "适量"), ("生抽", "1勺"), ("糖", "少许"), ("葱花", "适量"), ("香菜", "适量")]
    if category == "汤类":
        cook = "加入足量清水，先大火煮开，再转小火慢煮至汤色清亮、食材软嫩。"
        extra = [("盐", "适量"), ("生抽", "1勺"), ("糖", "少许"), ("清水", "适量"), ("葱花", "适量"), ("香菜", "适量")]
    elif category == "甜品":
        cook = "按配方混合食材，小火加热或冷藏定型，保持口感细腻。"
        season = "根据甜度加入糖、牛奶或蜂蜜，搅拌均匀。"
        finish = "冷藏或趁热装盘，可撒上糖粉或水果点缀，即可享用。"
        extra = [("糖", "适量"), ("牛奶", "适量"), ("蜂蜜", "适量")]
    elif category == "减脂餐":
        season = "用少油少盐方式调味，可加入黑胡椒、柠檬汁提升风味。"
        extra = [("黑胡椒", "适量"), ("柠檬汁", "少许"), ("葱花", "适量"), ("香菜", "适量")]
    return [prep, season, cook, finish], extra


def cooking_time(recipe: SourceRecipe, category: str) -> int:
    if recipe.difficulty == "困难":
        base = 55
    elif recipe.difficulty == "中等":
        base = 38
    else:
        base = 24
    if category == "汤类":
        base += 25
    if category in {"早餐", "甜品", "减脂餐"}:
        base -= 8
    return max(10, min(90, base + len(recipe.stuff) * 2))


def normalize_difficulty(value: str) -> str:
    if value in {"简单", "中等", "困难"}:
        return value
    if "难" in value:
        return "困难"
    if "中" in value:
        return "中等"
    return "简单"


def make_seed_recipes(source: list[SourceRecipe]) -> list[SeedRecipe]:
    random.seed(20260530)
    today = datetime.now().replace(microsecond=0)
    seeds: list[SeedRecipe] = []
    for index, (item, category) in enumerate(choose_recipes(source), start=1):
        author = DEFAULT_AUTHOR_NAMES[(index - 1) % len(DEFAULT_AUTHOR_NAMES)]
        main_ingredients = [(name, amount_for(i, name)) for i, name in enumerate(item.stuff[:8], start=1)]
        if not main_ingredients:
            main_ingredients = [("主要食材", "适量")]
        steps, extra_ingredients = build_steps(item, category)
        existing_names = {name for name, _ in main_ingredients}
        merged_extra = [(name, amt) for name, amt in extra_ingredients if name not in existing_names]
        ingredients = main_ingredients + merged_extra
        tags = "、".join(item.tags[:3])
        description = f"{item.name}是一道适合{category}场景的演示菜谱，食材以{'、'.join(item.stuff[:4]) or '常见食材'}为主。"
        if tags:
            description += f" 口味标签：{tags}。"
        seeds.append(
            SeedRecipe(
                title=item.name,
                category=category,
                cover=f"/seed-images/yunyoujun-{index:03d}.svg",
                description=description,
                difficulty=normalize_difficulty(item.difficulty),
                cooking_time=cooking_time(item, category),
                tips=f"{SEED_MARKER}; 原始条目来自 {SOURCE_NAME}; BV={item.bv or 'N/A'}",
                ingredients=ingredients,
                steps=steps,
                author=author,
                view_count=random.randint(800, 48000),
                favorite_count=random.randint(30, 2800),
                like_count=random.randint(80, 6800),
                created_at=today - timedelta(days=index),
            )
        )
    return seeds


def slug_color(category: str) -> tuple[str, str]:
    colors = {
        "家常菜": ("#ff6b35", "#ffb347"),
        "早餐": ("#ff9f1c", "#ffd166"),
        "午餐": ("#37b24d", "#8ce99a"),
        "晚餐": ("#5c7cfa", "#91a7ff"),
        "甜品": ("#f06595", "#faa2c1"),
        "汤类": ("#15aabf", "#66d9e8"),
        "减脂餐": ("#82c91e", "#c0eb75"),
        "川菜": ("#f03e3e", "#ff8787"),
    }
    return colors.get(category, ("#ff6b35", "#ffb347"))


INGREDIENT_EMOJI = {
    "茄子": "🍆",
    "土豆": "🥔",
    "番茄": "🍅",
    "鸡蛋": "🥚",
    "鸡肉": "🍗",
    "鸡翅": "🍗",
    "鸡腿": "🍗",
    "牛肉": "🥩",
    "猪肉": "🥓",
    "排骨": "🥩",
    "虾仁": "🦐",
    "虾": "🦐",
    "米": "🍚",
    "饭": "🍚",
    "面包": "🍞",
    "法棍": "🥖",
    "汉堡": "🍔",
    "方便面": "🍜",
    "面食": "🍜",
    "面": "🍜",
    "豆腐": "⬜",
    "包菜": "🥬",
    "白菜": "🥬",
    "花菜": "🥦",
    "西葫芦": "🥒",
    "黄瓜": "🥒",
    "胡萝卜": "🥕",
    "白萝卜": "🥕",
    "洋葱": "🧅",
    "菌菇": "🍄",
    "芹菜": "🌿",
    "莴笋": "🌿",
    "香肠": "🌭",
    "午餐肉": "🥓",
    "腊肠": "🌭",
    "骨头": "🍖",
}


def ingredient_emoji(name: str) -> str:
    for key, icon in INGREDIENT_EMOJI.items():
        if key in name:
            return icon
    return "•"


def main_ingredients(recipe: SeedRecipe, limit: int = 4) -> list[str]:
    names = [name for name, _ in recipe.ingredients if name and name != "主要食材"]
    if not names:
        names = [recipe.category]
    return names[:limit]


def split_title(title: str) -> list[str]:
    compact = title.strip()
    if len(compact) <= 12:
        return [compact]
    return [compact[:12], compact[12:22]]


def title_svg(title: str) -> str:
    lines = [html.escape(line) for line in split_title(title)]
    if len(lines) == 1:
        return f"""  <text x="480" y="286" text-anchor="middle" font-size="58" font-weight="900" fill="#502314"
        font-family="Microsoft YaHei, PingFang SC, Arial, sans-serif">{lines[0]}</text>"""
    return f"""  <text x="480" y="260" text-anchor="middle" font-size="50" font-weight="900" fill="#502314"
        font-family="Microsoft YaHei, PingFang SC, Arial, sans-serif">{lines[0]}</text>
  <text x="480" y="318" text-anchor="middle" font-size="44" font-weight="900" fill="#502314"
        font-family="Microsoft YaHei, PingFang SC, Arial, sans-serif">{lines[1]}</text>"""


def ingredient_badges(recipe: SeedRecipe) -> str:
    positions = [(212, 136), (748, 136), (206, 386), (754, 386)]
    badges = []
    for (x, y), name in zip(positions, main_ingredients(recipe)):
        safe_name = html.escape(name[:4])
        icon = html.escape(ingredient_emoji(name))
        badges.append(f"""  <g>
    <circle cx="{x}" cy="{y}" r="52" fill="#fffaf0" opacity=".94"/>
    <text x="{x}" y="{y - 4}" text-anchor="middle" font-size="34"
          font-family="Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji, Microsoft YaHei">{icon}</text>
    <text x="{x}" y="{y + 34}" text-anchor="middle" font-size="17" font-weight="800" fill="#7a3a14"
          font-family="Microsoft YaHei, PingFang SC, Arial, sans-serif">{safe_name}</text>
  </g>""")
    return "\n".join(badges)


def recipe_kind(recipe: SeedRecipe) -> str:
    title = recipe.title
    ingredient_text = "、".join(main_ingredients(recipe, 8))
    if any(key in title for key in ("焖饭", "炒饭", "米饭")) or "米" in ingredient_text:
        return "rice"
    if any(key in title for key in ("汤", "火锅", "锅底", "罗宋汤")):
        return "soup"
    if any(key in title for key in ("面", "泡面", "河粉", "粉")):
        return "noodle"
    if any(key in title for key in ("鸡蛋", "蛋", "蛋黄", "熔岩")):
        return "egg"
    if any(key in title for key in ("面包", "法棍", "汉堡", "包")):
        return "bread"
    if any(key in title for key in ("炸", "薯条", "薯片", "脆片", "烤")):
        return "crispy"
    return "plate"


def cover_scene(recipe: SeedRecipe) -> str:
    icons = [html.escape(ingredient_emoji(name)) for name in main_ingredients(recipe, 4)]
    while len(icons) < 4:
        icons.append("•")
    kind = recipe_kind(recipe)
    if kind == "rice":
        return f"""  <ellipse cx="480" cy="336" rx="214" ry="78" fill="#7a3a14" opacity=".18"/>
  <path d="M300 250 Q480 360 660 250 L612 400 Q480 458 348 400 Z" fill="#fff7e6" stroke="#7a3a14" stroke-width="8"/>
  <ellipse cx="480" cy="250" rx="190" ry="72" fill="#fffdf5" stroke="#7a3a14" stroke-width="8"/>
  <circle cx="420" cy="246" r="34" fill="#ffd43b"/>
  <circle cx="487" cy="230" r="30" fill="#ff8787"/>
  <circle cx="548" cy="260" r="28" fill="#69db7c"/>
  <text x="390" y="242" font-size="42" font-family="Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji">{icons[0]}</text>
  <text x="500" y="250" font-size="42" font-family="Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji">{icons[1]}</text>
  <text x="454" y="292" font-size="40" font-family="Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji">{icons[2]}</text>"""
    if kind == "soup":
        return f"""  <path d="M390 138 C362 108 420 92 392 58" fill="none" stroke="#fff8dc" stroke-width="12" stroke-linecap="round" opacity=".8"/>
  <path d="M486 136 C454 104 520 90 490 58" fill="none" stroke="#fff8dc" stroke-width="12" stroke-linecap="round" opacity=".8"/>
  <path d="M580 138 C552 108 610 92 582 58" fill="none" stroke="#fff8dc" stroke-width="12" stroke-linecap="round" opacity=".8"/>
  <ellipse cx="480" cy="328" rx="226" ry="74" fill="#7a3a14" opacity=".18"/>
  <path d="M286 232 H674 L630 406 Q480 462 330 406 Z" fill="#fff5de" stroke="#7a3a14" stroke-width="8"/>
  <ellipse cx="480" cy="232" rx="200" ry="66" fill="#ffb347" stroke="#7a3a14" stroke-width="8"/>
  <circle cx="406" cy="220" r="24" fill="#ff6b6b"/>
  <circle cx="492" cy="238" r="22" fill="#51cf66"/>
  <circle cx="558" cy="214" r="22" fill="#ffd43b"/>
  <text x="376" y="236" font-size="40" font-family="Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji">{icons[0]}</text>
  <text x="516" y="232" font-size="40" font-family="Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji">{icons[1]}</text>"""
    if kind == "noodle":
        return f"""  <ellipse cx="480" cy="336" rx="214" ry="78" fill="#7a3a14" opacity=".18"/>
  <path d="M296 244 H664 L610 404 Q480 452 350 404 Z" fill="#fff7e6" stroke="#7a3a14" stroke-width="8"/>
  <ellipse cx="480" cy="244" rx="192" ry="68" fill="#ffe8a3" stroke="#7a3a14" stroke-width="8"/>
  <path d="M370 238 C424 212 438 270 492 240 C540 214 560 268 602 240" fill="none" stroke="#f08c00" stroke-width="12" stroke-linecap="round"/>
  <path d="M392 276 C446 250 468 306 526 276" fill="none" stroke="#f08c00" stroke-width="12" stroke-linecap="round"/>
  <text x="416" y="226" font-size="42" font-family="Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji">{icons[0]}</text>
  <text x="540" y="284" font-size="40" font-family="Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji">{icons[1]}</text>"""
    if kind == "egg":
        return f"""  <ellipse cx="480" cy="346" rx="228" ry="74" fill="#7a3a14" opacity=".18"/>
  <rect x="288" y="220" width="384" height="196" rx="56" fill="#45413c"/>
  <rect x="312" y="244" width="336" height="148" rx="42" fill="#fff3bf"/>
  <ellipse cx="480" cy="318" rx="126" ry="78" fill="#fffdf5"/>
  <circle cx="480" cy="318" r="42" fill="#ffb703"/>
  <text x="378" y="282" font-size="40" font-family="Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji">{icons[0]}</text>
  <text x="556" y="288" font-size="38" font-family="Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji">{icons[1]}</text>"""
    if kind == "bread":
        return f"""  <ellipse cx="480" cy="348" rx="222" ry="70" fill="#7a3a14" opacity=".18"/>
  <rect x="292" y="238" width="376" height="158" rx="44" fill="#8d5524"/>
  <ellipse cx="402" cy="298" rx="86" ry="68" fill="#f4a261"/>
  <ellipse cx="512" cy="292" rx="92" ry="72" fill="#f6bd60"/>
  <ellipse cx="594" cy="318" rx="68" ry="50" fill="#e76f51"/>
  <path d="M372 276 Q414 248 456 276" fill="none" stroke="#fff1c7" stroke-width="10" stroke-linecap="round"/>
  <path d="M486 272 Q532 242 574 274" fill="none" stroke="#fff1c7" stroke-width="10" stroke-linecap="round"/>
  <text x="448" y="334" font-size="38" font-family="Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji">{icons[0]}</text>
  <text x="548" y="344" font-size="36" font-family="Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji">{icons[1]}</text>"""
    if kind == "crispy":
        return f"""  <ellipse cx="480" cy="352" rx="224" ry="70" fill="#7a3a14" opacity=".18"/>
  <path d="M318 236 H642 L604 410 H356 Z" fill="#fff0d6" stroke="#7a3a14" stroke-width="8"/>
  <path d="M352 204 H608 L642 236 H318 Z" fill="#ffe8a3" stroke="#7a3a14" stroke-width="8"/>
  <rect x="392" y="246" width="34" height="128" rx="17" fill="#ff922b" transform="rotate(-12 409 310)"/>
  <rect x="454" y="238" width="34" height="136" rx="17" fill="#ffd43b" transform="rotate(8 471 306)"/>
  <rect x="520" y="248" width="34" height="120" rx="17" fill="#ff6b35" transform="rotate(16 537 308)"/>
  <text x="394" y="308" font-size="44" font-family="Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji">{icons[0]}</text>
  <text x="534" y="318" font-size="42" font-family="Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji">{icons[1]}</text>"""
    return f"""  <ellipse cx="480" cy="348" rx="236" ry="76" fill="#7a3a14" opacity=".18"/>
  <ellipse cx="480" cy="302" rx="224" ry="116" fill="#fff7e6" stroke="#7a3a14" stroke-width="8"/>
  <ellipse cx="480" cy="302" rx="154" ry="72" fill="#ffe8a3"/>
  <circle cx="404" cy="278" r="38" fill="#ff8787"/>
  <circle cx="486" cy="326" r="36" fill="#69db7c"/>
  <circle cx="560" cy="276" r="34" fill="#ffd43b"/>
  <text x="382" y="296" font-size="44" font-family="Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji">{icons[0]}</text>
  <text x="486" y="342" font-size="42" font-family="Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji">{icons[1]}</text>
  <text x="552" y="292" font-size="40" font-family="Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji">{icons[2]}</text>"""


def write_cover_svgs(recipes: list[SeedRecipe], image_dir: Path) -> None:
    image_dir.mkdir(parents=True, exist_ok=True)
    for index, recipe in enumerate(recipes, start=1):
        c1, c2 = slug_color(recipe.category)
        category = html.escape(recipe.category)
        scene = cover_scene(recipe)
        title = title_svg(recipe.title)
        badges = ingredient_badges(recipe)
        svg = f"""<svg xmlns="http://www.w3.org/2000/svg" width="960" height="540" viewBox="0 0 960 540">
  <defs>
    <linearGradient id="bg" x1="0" x2="1" y1="0" y2="1">
      <stop offset="0" stop-color="{c2}"/>
      <stop offset="1" stop-color="{c1}"/>
    </linearGradient>
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="18" stdDeviation="18" flood-color="#64230f" flood-opacity=".24"/>
    </filter>
  </defs>
  <rect width="960" height="540" fill="#fff7ef"/>
  <rect x="0" y="0" width="960" height="540" fill="url(#bg)" opacity=".92"/>
  <circle cx="178" cy="118" r="72" fill="#fff" opacity=".22"/>
  <circle cx="790" cy="92" r="110" fill="#fff" opacity=".16"/>
  <rect x="74" y="60" width="812" height="420" rx="34" fill="#fffaf0" opacity=".76" filter="url(#shadow)"/>
{badges}
{scene}
  <rect x="236" y="188" width="488" height="154" rx="32" fill="#fffaf0" opacity=".86"/>
{title}
  <text x="480" y="438" text-anchor="middle" font-size="28" font-weight="800" fill="#fff7ef"
        font-family="Microsoft YaHei, PingFang SC, Arial, sans-serif">{category} · 微菜谱</text>
</svg>
"""
        (image_dir / f"yunyoujun-{index:03d}.svg").write_text(svg, encoding="utf-8")


def sql_string(value: str | None) -> str:
    if value is None:
        return "NULL"
    return "'" + value.replace("\\", "\\\\").replace("'", "''") + "'"


def sql_datetime(value: datetime) -> str:
    return sql_string(value.strftime("%Y-%m-%d %H:%M:%S"))


def insert_sql(table: str, columns: list[str], rows: list[list[object]]) -> str:
    if not rows:
        return ""
    lines = [f"INSERT INTO `{table}` ({', '.join(f'`{col}`' for col in columns)}) VALUES"]
    values = []
    for row in rows:
        rendered = []
        for value in row:
            if value is None:
                rendered.append("NULL")
            elif isinstance(value, int):
                rendered.append(str(value))
            elif isinstance(value, datetime):
                rendered.append(sql_datetime(value))
            else:
                rendered.append(sql_string(str(value)))
        values.append("  (" + ", ".join(rendered) + ")")
    lines.append(",\n".join(values) + ";")
    return "\n".join(lines)


def build_sql(recipes: list[SeedRecipe]) -> str:
    now = datetime.now().replace(microsecond=0)
    author_rows = []
    for index, author in enumerate(DEFAULT_AUTHOR_NAMES, start=1):
        author_rows.append(
            [
                f"seed_author_{index}",
                "seed-author-no-login",
                author,
                "",
                f"seed_author_{index}@example.com",
                "",
                f"{SOURCE_NAME} 演示数据作者",
                "USER",
                1,
                now,
                now,
                0,
            ]
        )

    category_rows = []
    for index, category in enumerate(TARGET_CATEGORIES, start=1):
        category_rows.append([category, f"seed-{index}", index, 1, now, now, 0])

    author_statements = []
    for row in author_rows:
        columns = ["username", "password", "nickname", "avatar", "email", "phone", "bio", "role", "status", "create_time", "update_time", "deleted"]
        values = []
        for value in row:
            if isinstance(value, datetime):
                values.append(sql_datetime(value))
            elif isinstance(value, int):
                values.append(str(value))
            else:
                values.append(sql_string(str(value)))
        author_statements.append(
            f"INSERT INTO `user` ({', '.join(f'`{col}`' for col in columns)}) "
            f"SELECT {', '.join(values)} WHERE NOT EXISTS "
            f"(SELECT 1 FROM `user` WHERE `username` = {sql_string(row[0])});"
        )

    category_statements = []
    for row in category_rows:
        columns = ["name", "icon", "sort", "status", "create_time", "update_time", "deleted"]
        values = []
        for value in row:
            if isinstance(value, datetime):
                values.append(sql_datetime(value))
            elif isinstance(value, int):
                values.append(str(value))
            else:
                values.append(sql_string(str(value)))
        category_statements.append(
            f"INSERT INTO `category` ({', '.join(f'`{col}`' for col in columns)}) "
            f"SELECT {', '.join(values)} WHERE NOT EXISTS "
            f"(SELECT 1 FROM `category` WHERE `name` = {sql_string(row[0])} AND `deleted` = 0);"
        )

    statements = [
        "-- Seed data generated from YunYouJun/cook recipe.csv (MIT License).",
        "-- Run this SQL against the recipe_system database.",
        "SET NAMES utf8mb4;",
        """
SET @like_col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'recipe' AND COLUMN_NAME = 'like_count'
);
SET @like_col_sql := IF(@like_col_exists = 0,
  'ALTER TABLE `recipe` ADD COLUMN `like_count` INT NOT NULL DEFAULT 0 COMMENT ''点赞数'' AFTER `favorite_count`',
  'SELECT 1'
);
PREPARE like_col_stmt FROM @like_col_sql;
EXECUTE like_col_stmt;
DEALLOCATE PREPARE like_col_stmt;
""".strip(),
        "\n".join(author_statements),
        "\n".join(category_statements),
        """
CREATE TEMPORARY TABLE IF NOT EXISTS `_seed_recipe_ids` (`id` BIGINT PRIMARY KEY);
INSERT INTO `_seed_recipe_ids` (`id`)
SELECT `id` FROM `recipe` WHERE `tips` LIKE '%source:YunYouJun/cook seed:v1%';
DELETE FROM `recipe_ingredient` WHERE `recipe_id` IN (SELECT `id` FROM `_seed_recipe_ids`);
DELETE FROM `recipe_step` WHERE `recipe_id` IN (SELECT `id` FROM `_seed_recipe_ids`);
DELETE FROM `favorite` WHERE `recipe_id` IN (SELECT `id` FROM `_seed_recipe_ids`);
DELETE FROM `comment` WHERE `recipe_id` IN (SELECT `id` FROM `_seed_recipe_ids`);
DELETE FROM `recipe` WHERE `id` IN (SELECT `id` FROM `_seed_recipe_ids`);
DROP TEMPORARY TABLE `_seed_recipe_ids`;
""".strip(),
    ]

    for recipe in recipes:
        statements.append(
            f"""
INSERT INTO `recipe` (`user_id`, `category_id`, `title`, `cover_image`, `description`, `difficulty`, `cooking_time`, `tips`, `view_count`, `favorite_count`, `like_count`, `comment_count`, `status`, `create_time`, `update_time`, `deleted`)
SELECT u.`id`, c.`id`, {sql_string(recipe.title)}, {sql_string(recipe.cover)}, {sql_string(recipe.description)}, {sql_string(recipe.difficulty)}, {recipe.cooking_time}, {sql_string(recipe.tips)}, {recipe.view_count}, {recipe.favorite_count}, {recipe.like_count}, 0, 1, {sql_datetime(recipe.created_at)}, {sql_datetime(recipe.created_at)}, 0
FROM `user` u JOIN `category` c
WHERE u.`username` = {sql_string('seed_author_' + str(DEFAULT_AUTHOR_NAMES.index(recipe.author) + 1))} AND c.`name` = {sql_string(recipe.category)}
LIMIT 1;
SET @recipe_id := LAST_INSERT_ID();
""".strip()
        )
        ingredient_rows = [
            [None, name, amount, sort, recipe.created_at, recipe.created_at, 0]
            for sort, (name, amount) in enumerate(recipe.ingredients, start=1)
        ]
        ingredient_sql = insert_sql(
            "recipe_ingredient",
            ["recipe_id", "name", "amount", "sort", "create_time", "update_time", "deleted"],
            ingredient_rows,
        ).replace("NULL, ", "@recipe_id, ")
        statements.append(ingredient_sql)
        step_rows = [
            [None, step_no, content, "", recipe.created_at, recipe.created_at, 0]
            for step_no, content in enumerate(recipe.steps, start=1)
        ]
        step_sql = insert_sql(
            "recipe_step",
            ["recipe_id", "step_no", "content", "image", "create_time", "update_time", "deleted"],
            step_rows,
        ).replace("NULL, ", "@recipe_id, ")
        statements.append(step_sql)

    return "\n\n".join(statement for statement in statements if statement) + "\n"


def execute_with_pymysql(sql: str, args: argparse.Namespace) -> None:
    try:
        import pymysql
    except ImportError as exc:
        raise SystemExit("PyMySQL is required for --execute. Install it with: python -m pip install pymysql") from exc

    connection = pymysql.connect(
        host=args.host,
        port=args.port,
        user=args.user,
        password=args.password,
        database=args.database,
        charset="utf8mb4",
        autocommit=False,
        client_flag=pymysql.constants.CLIENT.MULTI_STATEMENTS,
    )
    try:
        with connection.cursor() as cursor:
            cursor.execute(sql)
            while cursor.nextset():
                pass
        connection.commit()
    except Exception:
        connection.rollback()
        raise
    finally:
        connection.close()


def parse_args() -> argparse.Namespace:
    root = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser(description="Import YunYouJun/cook demo recipes into 微菜谱.")
    parser.add_argument("--source-csv", default=str(root.parent / "tools" / "yunyoujun-cook" / "app" / "data" / "recipe.csv"))
    parser.add_argument("--out-sql", default=str(root / "outputs" / "seed" / "yunyoujun_seed.sql"))
    parser.add_argument("--image-dir", default=str(root / "src" / "main" / "resources" / "static" / "seed-images"))
    parser.add_argument("--execute", action="store_true", help="Execute generated SQL against MySQL through PyMySQL.")
    parser.add_argument("--host", default=os.getenv("MYSQL_HOST", "localhost"))
    parser.add_argument("--port", type=int, default=int(os.getenv("MYSQL_PORT", "3306")))
    parser.add_argument("--database", default=os.getenv("MYSQL_DATABASE", "recipe_system"))
    parser.add_argument("--user", default=os.getenv("MYSQL_USERNAME", "root"))
    parser.add_argument("--password", default=os.getenv("MYSQL_PASSWORD", "201214"))
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    source = load_source_csv(Path(args.source_csv))
    random.seed(20260530)
    recipes = make_seed_recipes(source)
    if len(recipes) < TARGET_COUNT:
        raise SystemExit(f"Only generated {len(recipes)} recipes; expected {TARGET_COUNT}.")

    image_dir = Path(args.image_dir)
    write_cover_svgs(recipes, image_dir)
    target_classes_dir = Path(__file__).resolve().parents[1] / "target" / "classes" / "static" / "seed-images"
    if target_classes_dir.parent.exists():
        write_cover_svgs(recipes, target_classes_dir)

    sql = build_sql(recipes)
    out_sql = Path(args.out_sql)
    out_sql.parent.mkdir(parents=True, exist_ok=True)
    out_sql.write_text(sql, encoding="utf-8")

    print(f"Source: {SOURCE_URL}")
    print(f"Generated recipes: {len(recipes)}")
    print(f"SQL: {out_sql}")
    print(f"Covers: {image_dir}")
    if args.execute:
        execute_with_pymysql(sql, args)
        print(f"Imported into MySQL database: {args.database}")
    else:
        print("Dry run only. To import, run the SQL file with mysql or rerun this script with --execute.")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(130)
