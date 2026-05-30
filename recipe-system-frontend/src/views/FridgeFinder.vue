<template>
  <section class="fridge-page">
    <div class="fridge-hero">
      <div>
        <span class="tag fridge-kicker">Fridge Finder</span>
        <h1>冰箱寻菜</h1>
        <p>选出你冰箱里现有的食材，看看今天能做什么菜。</p>
      </div>
      <div class="fridge-hero-note">
        <strong>{{ selectedIngredients.length }}</strong>
        <span>种食材已进备菜篮</span>
      </div>
    </div>

    <section class="fridge-workbench">
      <div class="ingredient-board">
        <div class="section-head compact-head">
          <div>
            <h2>冰箱食材</h2>
            <p class="muted">点一下放进锅里，再点一下从清单里拿出来。</p>
          </div>
          <el-button text type="primary" :disabled="selectedIngredients.length === 0" @click="clearSelected">清空</el-button>
        </div>
        <div class="ingredient-grid">
          <button
            v-for="item in ingredientOptions"
            :key="item.name"
            type="button"
            class="ingredient-chip"
            :class="{ active: isSelected(item.name) }"
            @click="toggleIngredient(item, $event)"
          >
            <span class="ingredient-icon">{{ item.icon }}</span>
            <strong>{{ item.name }}</strong>
          </button>
        </div>
      </div>

      <div ref="potRef" class="pot-zone" :class="{ cooking: potCooking }">
        <div class="steam steam-one"></div>
        <div class="steam steam-two"></div>
        <div class="steam steam-three"></div>
        <div class="pot-lid"></div>
        <div class="pot-body">
          <span>咕嘟</span>
        </div>
        <div class="pot-fire"></div>
        <p>把现有食材丢进锅里试试看</p>
      </div>
    </section>

    <section class="selected-panel">
      <div class="section-head compact-head">
        <div>
          <h2>已选择食材</h2>
          <p class="muted">{{ selectedText }}</p>
        </div>
        <el-button type="primary" size="large" @click="searchRecipes">搜索能做什么菜</el-button>
      </div>
      <div v-if="selectedIngredients.length" class="selected-tags">
        <button v-for="name in selectedIngredients" :key="name" type="button" class="selected-tag" @click="removeIngredient(name)">
          {{ iconOf(name) }} {{ name }} ×
        </button>
      </div>
      <el-empty v-else description="先从冰箱里挑几样食材吧" />
    </section>

    <section class="match-panel">
      <div class="section-head compact-head">
        <div>
          <h2>匹配结果</h2>
          <p class="muted">按匹配度从高到低排序，低于 60% 的结果会放在后面作为备菜参考。</p>
        </div>
        <span v-if="searched" class="tag">找到 {{ visibleMatches.length }} 道菜</span>
      </div>

      <div v-if="loading" class="fridge-loading">
        <el-skeleton :rows="5" animated />
      </div>
      <el-empty
        v-else-if="searched && visibleMatches.length === 0"
        description="暂时没有找到合适菜谱，可以多选择几个食材试试。"
      />
      <div v-else-if="visibleMatches.length" class="match-grid">
        <RouterLink v-for="item in visibleMatches" :key="item.id" class="match-card" :to="`/recipe/${item.id}`">
          <img v-if="item.coverImage" :src="item.coverImage" :alt="item.name" />
          <div v-else class="match-cover-fallback">{{ item.name.slice(0, 2) }}</div>
          <div class="match-card-body">
            <div class="match-title-row">
              <h3>{{ item.name }}</h3>
              <strong>{{ item.matchPercent }}%</strong>
            </div>
            <div class="match-meter">
              <span :style="{ width: `${item.matchPercent}%` }"></span>
            </div>
            <div class="tag-row">
              <span class="tag">{{ item.category || "家常菜" }}</span>
              <span class="tag">{{ item.difficulty || "简单" }}</span>
              <span class="tag">{{ item.cookTime || "时间灵活" }}</span>
              <span class="tag accent-tag">{{ matchLabel(item.matchPercent) }}</span>
            </div>
            <p><strong>已有食材：</strong>{{ item.matchedIngredients.join("、") || "无" }}</p>
            <p><strong>缺少食材：</strong>{{ item.missingIngredients.length ? item.missingIngredients.join("、") : "无" }}</p>
          </div>
        </RouterLink>
      </div>
      <div v-else class="fridge-placeholder">
        <span>🍲</span>
        <p>选好食材后点击搜索，锅里会给你端出今天的灵感。</p>
      </div>
    </section>

    <span
      v-for="flyer in flyers"
      :key="flyer.id"
      class="flying-ingredient"
      :style="flyer.style"
    >
      {{ flyer.icon }}
    </span>
  </section>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import { ElMessage } from "element-plus";
import { recipeApi } from "../api";

const ingredientOptions = [
  { name: "包菜", icon: "🥬" },
  { name: "午餐肉", icon: "🥫" },
  { name: "土豆", icon: "🥔" },
  { name: "方便面", icon: "🍜" },
  { name: "洋葱", icon: "🧅" },
  { name: "牛肉", icon: "🥩" },
  { name: "猪肉", icon: "🥓" },
  { name: "番茄", icon: "🍅" },
  { name: "白菜", icon: "🥬" },
  { name: "白萝卜", icon: "⚪" },
  { name: "米", icon: "🍚" },
  { name: "胡萝卜", icon: "🥕" },
  { name: "腊肠", icon: "🌭" },
  { name: "花菜", icon: "🥦" },
  { name: "芹菜", icon: "🌿" },
  { name: "茄子", icon: "🍆" },
  { name: "莴笋", icon: "🌱" },
  { name: "菌菇", icon: "🍄" },
  { name: "虾", icon: "🦐" },
  { name: "虾仁", icon: "🦐" },
  { name: "西葫芦", icon: "🥒" },
  { name: "豆腐", icon: "□" },
  { name: "面包", icon: "🍞" },
  { name: "面食", icon: "🥟" },
  { name: "香肠", icon: "🌭" },
  { name: "骨头", icon: "🍖" },
  { name: "鸡肉", icon: "🍗" },
  { name: "鸡蛋", icon: "🥚" },
  { name: "黄瓜", icon: "🥒" },
];

const fallbackRecipes = [
  {
    id: 1,
    name: "番茄炒蛋",
    category: "家常菜",
    coverImage: "",
    requiredIngredients: ["番茄", "鸡蛋"],
    cookTime: "15分钟",
    difficulty: "简单",
  },
  {
    id: 2,
    name: "土豆炖牛肉",
    category: "午餐",
    coverImage: "",
    requiredIngredients: ["土豆", "牛肉", "胡萝卜", "洋葱"],
    cookTime: "45分钟",
    difficulty: "中等",
  },
  {
    id: 3,
    name: "白菜豆腐汤",
    category: "汤类",
    coverImage: "",
    requiredIngredients: ["白菜", "豆腐", "菌菇"],
    cookTime: "25分钟",
    difficulty: "简单",
  },
];

const selectedIngredients = ref([]);
const recipes = ref([]);
const matches = ref([]);
const flyers = ref([]);
const potRef = ref(null);
const potCooking = ref(false);
const loading = ref(false);
const searched = ref(false);

const selectedText = computed(() => (
  selectedIngredients.value.length
    ? `已选择：${selectedIngredients.value.join("、")}`
    : "已选择：暂无"
));

const visibleMatches = computed(() => matches.value);

function iconOf(name) {
  return ingredientOptions.find((item) => item.name === name)?.icon || "·";
}

function isSelected(name) {
  return selectedIngredients.value.includes(name);
}

function toggleIngredient(item, event) {
  if (isSelected(item.name)) {
    removeIngredient(item.name);
    return;
  }
  selectedIngredients.value.push(item.name);
  launchIngredient(item, event);
}

function removeIngredient(name) {
  selectedIngredients.value = selectedIngredients.value.filter((item) => item !== name);
}

function clearSelected() {
  selectedIngredients.value = [];
  matches.value = [];
  searched.value = false;
}

function launchIngredient(item, event) {
  if (!potRef.value || !event?.currentTarget) return;
  const start = event.currentTarget.getBoundingClientRect();
  const end = potRef.value.getBoundingClientRect();
  const id = Date.now() + Math.random();
  flyers.value.push({
    id,
    icon: item.icon,
    style: {
      "--from-x": `${start.left + start.width / 2}px`,
      "--from-y": `${start.top + start.height / 2}px`,
      "--to-x": `${end.left + end.width / 2}px`,
      "--to-y": `${end.top + end.height / 2}px`,
    },
  });
  potCooking.value = true;
  window.setTimeout(() => {
    flyers.value = flyers.value.filter((flyer) => flyer.id !== id);
    potCooking.value = false;
  }, 820);
}

function normalizeIngredient(name = "") {
  return name.replace(/\s/g, "").replace(/（.*?）|\(.*?\)/g, "");
}

function extractRequiredIngredients(recipe) {
  const names = (recipe.ingredients || [])
    .map((item) => normalizeIngredient(item.name))
    .filter(Boolean);
  const known = ingredientOptions.map((item) => item.name).sort((a, b) => b.length - a.length);
  const matchedKnown = names
    .map((ingredient) => known.find((name) => ingredient === name || ingredient.includes(name) || name.includes(ingredient)))
    .filter(Boolean);
  return [...new Set(matchedKnown.length ? matchedKnown : names.slice(0, 6))];
}

function toFridgeRecipe(recipe) {
  return {
    id: recipe.id,
    name: recipe.title,
    category: recipe.categoryName || recipe.category?.name,
    coverImage: recipe.coverImage,
    requiredIngredients: extractRequiredIngredients(recipe),
    cookTime: recipe.cookingTime ? `${recipe.cookingTime}分钟` : "",
    difficulty: recipe.difficulty,
  };
}

async function loadRecipes() {
  loading.value = true;
  try {
    const firstPage = await recipeApi.list({ page: 1, pageSize: 50 });
    const pages = [firstPage];
    const total = firstPage.total || firstPage.records?.length || 0;
    const pageSize = firstPage.pageSize || 50;
    const pageCount = Math.ceil(total / pageSize);
    for (let page = 2; page <= pageCount; page++) {
      pages.push(await recipeApi.list({ page, pageSize }));
    }
    const summaries = pages.flatMap((page) => page.records || []).slice(0, 120);
    let mappedRecipes = summaries.map(toFridgeRecipe).filter((recipe) => recipe.id && recipe.requiredIngredients.length);
    if (mappedRecipes.length === 0 && summaries.length) {
      const details = await Promise.all(
        summaries.slice(0, 80).map((recipe) => recipeApi.detail(recipe.id).catch(() => null)),
      );
      mappedRecipes = details.filter(Boolean).map(toFridgeRecipe).filter((recipe) => recipe.id && recipe.requiredIngredients.length);
    }
    recipes.value = mappedRecipes.length ? mappedRecipes : fallbackRecipes;
  } catch (error) {
    recipes.value = fallbackRecipes;
  } finally {
    loading.value = false;
  }
}

function searchRecipes() {
  if (selectedIngredients.value.length === 0) {
    ElMessage.warning("请先选择你已有的食材。");
    return;
  }
  const selected = new Set(selectedIngredients.value);
  matches.value = recipes.value
    .map((recipe) => {
      const required = [...new Set(recipe.requiredIngredients || [])];
      const matchedIngredients = required.filter((name) => selected.has(name));
      const missingIngredients = required.filter((name) => !selected.has(name));
      const matchPercent = required.length ? Math.round((matchedIngredients.length / required.length) * 100) : 0;
      return {
        ...recipe,
        matchedIngredients,
        missingIngredients,
        matchPercent,
      };
    })
    .filter((recipe) => recipe.matchPercent > 0)
    .sort((a, b) => b.matchPercent - a.matchPercent || a.missingIngredients.length - b.missingIngredients.length);
  searched.value = true;
}

function matchLabel(percent) {
  if (percent === 100) return "完全够做";
  if (percent >= 80) return "很适合做";
  if (percent >= 60) return "还差一点";
  return "备菜参考";
}

onMounted(loadRecipes);
</script>
