<template>
  <section class="hero-banner">
    <div class="hero-copy">
      <div class="hero-doodle">♡  ♡</div>
      <h1>把每一道拿手菜 <span>分享</span> 给更多人</h1>
      <p>发现美食灵感 · 学习家常好味 · 记录幸福食光</p>
      <div class="hero-search">
        <el-input v-model="keyword" size="large" placeholder="搜索菜名 / 食材 / 做法" @keyup.enter="goSearch" />
        <el-button size="large" type="primary" @click="goSearch">搜索</el-button>
      </div>
      <div class="hot-words">
        <strong>热门搜索：</strong>
        <button v-for="word in hotWords" :key="word" @click="searchWord(word)">{{ word }}</button>
      </div>
    </div>
    <div class="hero-note">生活要有烟火气<br />也要有好味道 ♥</div>
  </section>

  <section class="category-dock">
    <button v-for="(item, index) in displayCategories" :key="item.id || item.name" @click="goCategory(item)">
      <span :style="{ background: categoryColors[index % categoryColors.length] }">{{ categoryIcon(item.name) }}</span>
      <strong>{{ item.name }}</strong>
    </button>
  </section>

  <section class="home-layout">
    <div>
      <div class="section-head">
        <h2 class="accent-title">今日推荐</h2>
        <RouterLink to="/recipes">查看更多 ›</RouterLink>
      </div>
      <div v-loading="loading" class="card-grid recommended-grid">
        <RecipeCard v-for="recipe in recommendedRecipes" :key="recipe.id" :recipe="recipe" />
      </div>
      <el-empty v-if="!loading && recipes.length === 0" description="暂无菜谱" />

      <div class="section-head latest-head">
        <h2 class="leaf-title">最新上传</h2>
        <RouterLink to="/recipes">查看更多 ›</RouterLink>
      </div>
      <div class="latest-strip">
        <RouterLink v-for="recipe in latestRecipes" :key="recipe.id" class="latest-card" :to="`/recipe/${recipe.id}`">
          <div class="mini-cover">{{ recipe.title?.slice(0, 2) }}</div>
          <div>
            <strong>{{ recipe.title }}</strong>
            <span>{{ recipe.authorName || "美食达人" }} · {{ recipe.cookingTime || 0 }}分钟</span>
          </div>
        </RouterLink>
      </div>
    </div>

    <aside class="hot-panel">
      <div class="section-head">
        <h2>🏆 本周热门</h2>
        <button @click="shuffleHot">换一换</button>
      </div>
      <div class="hot-list">
        <RouterLink v-for="(recipe, index) in hotRecipes" :key="recipe.id" :to="`/recipe/${recipe.id}`" class="hot-item">
          <span class="rank">{{ index + 1 }}</span>
          <div class="hot-thumb">{{ recipe.title?.slice(0, 2) }}</div>
          <div>
            <strong>{{ recipe.title }}</strong>
            <small>{{ recipe.authorName || "美食达人" }}</small>
          </div>
          <em>🔥 {{ formatCount(recipe.viewCount || recipe.favoriteCount || 0) }}</em>
        </RouterLink>
      </div>
    </aside>
  </section>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import { useRouter } from "vue-router";
import RecipeCard from "../components/RecipeCard.vue";
import { categoryApi, recipeApi } from "../api";

const router = useRouter();
const recipes = ref([]);
const categories = ref([]);
const loading = ref(false);
const keyword = ref("");
const hotOffset = ref(0);
const hotWords = ["红烧肉", "可乐鸡翅", "番茄炒蛋", "宫保鸡丁", "蛋糕"];
const fallbackCategories = [
  { id: null, name: "家常菜" },
  { id: null, name: "早餐" },
  { id: null, name: "午餐" },
  { id: null, name: "晚餐" },
  { id: null, name: "甜品" },
  { id: null, name: "汤类" },
  { id: null, name: "减脂餐" },
  { id: null, name: "川菜" },
];
const categoryColors = [
  "linear-gradient(135deg, #ff7a3d, #ff4b1f)",
  "linear-gradient(135deg, #ffbb19, #ff9100)",
  "linear-gradient(135deg, #70d24b, #30b854)",
  "linear-gradient(135deg, #8896ff, #5f70e8)",
  "linear-gradient(135deg, #ff7aa7, #f05a86)",
  "linear-gradient(135deg, #32d4cb, #10a7b7)",
  "linear-gradient(135deg, #a8d92f, #75bd1e)",
  "linear-gradient(135deg, #ff6b5d, #ff3f35)",
];

const displayCategories = computed(() => (categories.value.length ? categories.value : fallbackCategories).slice(0, 8));
const recommendedRecipes = computed(() => recipes.value.slice(0, 5));
const latestRecipes = computed(() => recipes.value.slice(0, 6));
const hotRecipes = computed(() => {
  const source = [...recipes.value].sort((a, b) => (b.viewCount || 0) - (a.viewCount || 0));
  if (source.length <= 5) return source;
  return source.slice(hotOffset.value, hotOffset.value + 5).concat(source.slice(0, Math.max(0, hotOffset.value + 5 - source.length)));
});

function categoryIcon(name = "") {
  if (name.includes("早")) return "☀";
  if (name.includes("午")) return "🍱";
  if (name.includes("晚")) return "🍽";
  if (name.includes("甜")) return "🍰";
  if (name.includes("汤")) return "🥣";
  if (name.includes("减")) return "🌱";
  if (name.includes("川")) return "🌶";
  return "🍚";
}

function goSearch() {
  router.push({ path: "/recipes", query: { keyword: keyword.value || undefined } });
}

function searchWord(word) {
  keyword.value = word;
  goSearch();
}

function goCategory(category) {
  router.push({ path: "/recipes", query: { category: category?.name || undefined } });
}

function shuffleHot() {
  hotOffset.value = hotRecipes.value.length ? (hotOffset.value + 1) % recipes.value.length : 0;
}

function formatCount(value) {
  return value > 999 ? `${(value / 1000).toFixed(1)}k` : value;
}

onMounted(async () => {
  loading.value = true;
  try {
    const [recipePage, categories] = await Promise.all([
      recipeApi.list({ page: 1, pageSize: 10 }),
      categoryApi.list(),
    ]);
    recipes.value = recipePage.records || [];
    categories.value = categories;
  } finally {
    loading.value = false;
  }
});
</script>
