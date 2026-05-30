<template>
  <section v-loading="loading" class="detail-layout">
    <article v-if="recipe" class="panel">
      <div class="section-head">
        <div>
          <span class="tag">{{ recipe.categoryName || recipe.category?.name || "未分类" }}</span>
          <h1>{{ recipe.title }}</h1>
          <p class="muted">{{ recipe.description || "暂无简介" }}</p>
        </div>
        <el-button v-if="userStore.isLogin" :type="recipe.favorited ? 'default' : 'primary'" @click="toggleFavorite">
          {{ recipe.favorited ? "取消收藏" : "收藏" }}
        </el-button>
      </div>
      <img v-if="recipe.coverImage" class="cover detail-cover" :src="recipe.coverImage" :alt="recipe.title" />
      <div v-else class="cover detail-cover">{{ recipe.title?.slice(0, 4) }}</div>
      <div class="tag-row">
        <span class="tag">{{ recipe.difficulty || "简单" }}</span>
        <span class="tag">{{ recipe.cookingTime || 0 }} 分钟</span>
        <span class="tag">浏览 {{ recipe.viewCount || 0 }}</span>
        <span class="tag">点赞 {{ recipe.likeCount || 0 }}</span>
        <span class="tag">收藏 {{ recipe.favoriteCount || 0 }}</span>
      </div>

      <h2>食材</h2>
      <ul class="list">
        <li v-for="item in recipe.ingredients" :key="item.id || item.name">
          <strong>{{ item.name }}<img v-if="ingredientIcon(item.name)" :src="ingredientIcon(item.name)" class="ing-icon" /></strong>
          <span class="muted">{{ item.amount }}</span>
        </li>
      </ul>

      <h2>步骤</h2>
      <ol class="list ordered">
        <li v-for="item in recipe.steps" :key="item.id || item.stepNo">
          <strong>步骤 {{ item.stepNo }}</strong>
          <span>{{ item.content }}</span>
        </li>
      </ol>

      <el-alert v-if="recipe.tips" title="小贴士" :description="recipe.tips" type="success" :closable="false" />
    </article>

    <aside v-if="recipe" class="panel">
      <h2>作者</h2>
      <p>{{ recipe.authorName || recipe.author?.nickname || "未知用户" }}</p>
      <p class="muted">{{ recipe.author?.bio || "这位作者还没有填写简介。" }}</p>

      <h2>评论</h2>
      <div v-if="userStore.isLogin" class="comment-box">
        <el-input v-model="commentContent" type="textarea" :rows="3" placeholder="写下你的评论" />
        <el-button type="primary" @click="submitComment">发表评论</el-button>
      </div>
      <RouterLink v-else to="/login"><el-button type="primary">登录后评论</el-button></RouterLink>
      <div class="comment-list">
        <div v-for="comment in recipe.comments" :key="comment.id" class="comment-item">
          <strong>{{ comment.user?.nickname || comment.user?.username || "用户" }}</strong>
          <p>{{ comment.content }}</p>
        </div>
        <el-empty v-if="recipe.comments?.length === 0" description="暂无评论" />
      </div>
    </aside>
  </section>
</template>

<script setup>
import { onMounted, ref } from "vue";
import { useRoute } from "vue-router";
import { ElMessage } from "element-plus";
import { commentApi, favoriteApi, recipeApi } from "../api";
import { useUserStore } from "../store/user";

const route = useRoute();
const userStore = useUserStore();
const recipe = ref(null);
const loading = ref(false);
const commentContent = ref("");

const iconMap = {
  "包菜": "baocai", "午餐肉": "wucanrou", "土豆": "tudou", "方便面": "fangbianmian",
  "洋葱": "yangcong", "牛肉": "niurou", "猪肉": "zhurou", "番茄": "fanqie",
  "白菜": "baicai", "白萝卜": "bailuobo", "米": "mi", "胡萝卜": "huoluobo",
  "腊肠": "lachang", "花菜": "huacai", "芹菜": "qincai", "茄子": "qiezi",
  "莴笋": "wosun", "菌菇": "jungu", "虾": "xia", "虾仁": "xiaren",
  "西葫芦": "xihulu", "豆腐": "doufu", "面包": "mianbao", "面食": "mianshi",
  "香肠": "xiangchang", "骨头": "gutou", "鸡肉": "jirou", "鸡蛋": "jidan", "黄瓜": "huanggua",
};

function ingredientIcon(name) {
  const key = iconMap[name];
  return key ? `/ingredient-icons/${key}.svg` : "";
}

async function loadDetail() {
  loading.value = true;
  try {
    recipe.value = await recipeApi.detail(route.params.id);
  } finally {
    loading.value = false;
  }
}

async function toggleFavorite() {
  if (recipe.value.favorited) {
    await favoriteApi.cancel(recipe.value.id);
  } else {
    await favoriteApi.add(recipe.value.id);
  }
  await loadDetail();
}

async function submitComment() {
  if (!commentContent.value.trim()) {
    ElMessage.warning("请输入评论内容");
    return;
  }
  await commentApi.create({ recipeId: recipe.value.id, content: commentContent.value.trim() });
  commentContent.value = "";
  await loadDetail();
}

onMounted(loadDetail);
</script>
