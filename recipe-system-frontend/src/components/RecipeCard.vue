<template>
  <article class="recipe-card">
    <img v-if="recipe.coverImage" class="cover" :src="recipe.coverImage" :alt="recipe.title" />
    <div v-else class="cover food-cover">
      <span>{{ recipe.title?.slice(0, 4) }}</span>
    </div>
    <div class="recipe-card-body">
      <h3><RouterLink :to="`/recipe/${recipe.id}`">{{ recipe.title }}</RouterLink></h3>
      <div class="card-meta">
        <span class="avatar-dot">{{ (recipe.authorName || "食").slice(0, 1) }}</span>
        <span>{{ recipe.authorName || "美食达人" }}</span>
        <span>{{ recipe.cookingTime || 0 }}分钟</span>
      </div>
      <p class="muted">{{ recipe.description || "暂无简介" }}</p>
      <div class="tag-row">
        <span class="tag">{{ recipe.categoryName || "家常菜" }}</span>
        <span class="tag">👁 {{ recipe.viewCount || 0 }}</span>
        <span class="tag accent-tag">♡ {{ recipe.favoriteCount || 0 }}</span>
      </div>
    </div>
  </article>
</template>

<script setup>
defineProps({
  recipe: {
    type: Object,
    required: true,
  },
});
</script>
