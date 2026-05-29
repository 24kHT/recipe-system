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
    <div class="category-tabs">
      <button :class="{ active: !filters.categoryId }" @click="selectCategory(null)">全部</button>
      <button
        v-for="item in categories"
        :key="item.id"
        :class="{ active: filters.categoryId === item.id }"
        @click="selectCategory(item.id)"
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
import { onMounted, reactive, ref, watch } from "vue";
import { useRoute } from "vue-router";
import RecipeCard from "../components/RecipeCard.vue";
import { categoryApi, recipeApi } from "../api";

const route = useRoute();
const categories = ref([]);
const recipes = ref([]);
const total = ref(0);
const loading = ref(false);
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

function selectCategory(categoryId) {
  filters.categoryId = categoryId;
}

watch(() => filters.categoryId, () => {
  filters.page = 1;
  loadRecipes();
});

onMounted(async () => {
  categories.value = await categoryApi.list();
  filters.keyword = route.query.keyword || "";
  filters.categoryId = route.query.categoryId ? Number(route.query.categoryId) : null;
  loadRecipes();
});
</script>
