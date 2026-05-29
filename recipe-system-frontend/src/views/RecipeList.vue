<template>
  <section class="panel list-hero">
    <div class="section-head">
      <div>
        <span class="tag">Recipe Gallery</span>
        <h2>菜谱广场</h2>
        <p class="muted">按关键词和分类查找菜谱，把今晚吃什么变成一个好回答。</p>
      </div>
      <RouterLink to="/publish"><el-button type="primary">发布菜谱</el-button></RouterLink>
    </div>
    <div class="filter-row">
      <el-input v-model="filters.keyword" clearable placeholder="搜索菜谱名、简介或食材" @keyup.enter="loadRecipes" />
      <el-select v-model="filters.categoryId" clearable placeholder="全部分类">
        <el-option v-for="item in categories" :key="item.id" :label="item.name" :value="item.id" />
      </el-select>
      <el-button type="primary" @click="loadRecipes">搜索</el-button>
    </div>
  </section>

  <section class="section">
    <div ref="categoryTabsRef" class="category-tabs">
      <button :class="{ active: activeCategory === '全部' }" @click="selectCategory('全部')">全部</button>
      <button
        v-for="item in categories"
        :key="item.id"
        :class="{ active: activeCategory === item.name }"
        @click="selectCategory(item.name)"
      >
        {{ item.name }}
      </button>
    </div>
    <div v-loading="loading" class="card-grid">
      <RecipeCard v-for="recipe in recipes" :key="recipe.id" :recipe="recipe" />
    </div>
    <el-empty v-if="!loading && recipes.length === 0" description="没有找到菜谱" />
    <div class="pager">
      <el-pagination
        layout="prev, pager, next"
        :current-page="filters.page"
        :page-size="filters.pageSize"
        :total="total"
        @current-change="changePage"
      />
    </div>
  </section>
</template>

<script setup>
import { nextTick, onMounted, reactive, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import RecipeCard from "../components/RecipeCard.vue";
import { categoryApi, recipeApi } from "../api";

const route = useRoute();
const router = useRouter();
const categories = ref([]);
const recipes = ref([]);
const total = ref(0);
const loading = ref(false);
const categoryTabsRef = ref(null);
const activeCategory = ref("全部");
const filters = reactive({
  page: 1,
  pageSize: 9,
  keyword: "",
  categoryId: null,
});

async function loadRecipes() {
  loading.value = true;
  try {
    const data = await recipeApi.list({
      page: filters.page,
      pageSize: filters.pageSize,
      keyword: filters.keyword || undefined,
      categoryId: filters.categoryId || undefined,
    });
    recipes.value = data.records || [];
    total.value = data.total || 0;
  } finally {
    loading.value = false;
  }
}

function changePage(page) {
  filters.page = page;
  loadRecipes();
}

function categoryIdByName(categoryName) {
  if (!categoryName || categoryName === "全部") return null;
  return categories.value.find((item) => item.name === categoryName)?.id || null;
}

function syncCategoryFromQuery() {
  const queryCategory = Array.isArray(route.query.category) ? route.query.category[0] : route.query.category;
  const queryCategoryId = Array.isArray(route.query.categoryId) ? route.query.categoryId[0] : route.query.categoryId;

  if (queryCategory) {
    const matchedCategory = categories.value.find((item) => item.name === queryCategory);
    activeCategory.value = matchedCategory?.name || "全部";
    filters.categoryId = matchedCategory?.id || null;
    return;
  }

  if (queryCategoryId) {
    const categoryId = Number(queryCategoryId);
    const matchedCategory = categories.value.find((item) => item.id === categoryId);
    activeCategory.value = matchedCategory?.name || "全部";
    filters.categoryId = matchedCategory?.id || null;
    return;
  }

  activeCategory.value = "全部";
  filters.categoryId = null;
}

function selectCategory(categoryName) {
  const nextCategory = categoryName || "全部";
  activeCategory.value = nextCategory;
  filters.categoryId = categoryIdByName(nextCategory);
  router.push({
    path: "/recipes",
    query: {
      ...route.query,
      category: nextCategory === "全部" ? undefined : nextCategory,
      categoryId: undefined,
    },
  });
}

function scrollToCategoryTabs() {
  if (categoryTabsRef.value) {
    categoryTabsRef.value.scrollIntoView({ behavior: "smooth", block: "start" });
  }
}

watch(() => filters.categoryId, () => {
  filters.page = 1;
  loadRecipes();
});

watch(
  () => [route.query.category, route.query.categoryId],
  () => {
    syncCategoryFromQuery();
    filters.page = 1;
    nextTick(() => scrollToCategoryTabs());
  },
);

onMounted(async () => {
  categories.value = await categoryApi.list();
  filters.keyword = route.query.keyword || "";
  syncCategoryFromQuery();
  loadRecipes();
  if (route.query.category || route.query.categoryId) {
    nextTick(() => scrollToCategoryTabs());
  }
});
</script>
