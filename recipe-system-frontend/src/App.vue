<template>
  <div class="app-shell">
    <header class="topbar">
      <RouterLink class="brand" to="/">
        <span class="brand-mark">食</span>
        <span>
          <strong>微菜谱</strong>
          <small>分享美味 · 记录生活</small>
        </span>
      </RouterLink>
      <nav class="nav">
        <RouterLink to="/">首页</RouterLink>
        <RouterLink to="/recipes">菜谱</RouterLink>
        <RouterLink to="/fridge">冰箱寻菜</RouterLink>
        <RouterLink class="nav-compose" to="/publish">发布菜谱</RouterLink>
        <RouterLink to="/profile">我的收藏</RouterLink>
        <RouterLink v-if="userStore.isAdmin" to="/admin">后台管理</RouterLink>
      </nav>
      <RouterLink v-if="!userStore.isLogin" class="auth-pill" to="/login">登录 / 注册</RouterLink>
      <div v-else class="user-pill">
        <span>{{ userStore.user.nickname || userStore.user.username }}</span>
        <el-button link type="primary" @click="logout">退出</el-button>
      </div>
    </header>
    <main class="page">
      <RouterView v-slot="{ Component, route }">
        <keep-alive :include="cachedViews">
          <component :is="Component" :key="route.name" />
        </keep-alive>
      </RouterView>
    </main>
    <footer class="site-footer">
      <RouterLink class="footer-brand" to="/">
        <span class="brand-mark">食</span>
        <span>
          <strong>微菜谱</strong>
          <small>分享美味 · 记录生活</small>
        </span>
      </RouterLink>
      <p>微菜谱致力于打造温暖有爱的美食社区，分享菜谱、交流心得、发现生活中的美好滋味。</p>
      <div class="footer-links">
        <span>关于我们</span>
        <span>帮助中心</span>
        <span>服务条款</span>
        <span>关注我们</span>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { useRouter } from "vue-router";
import { useUserStore } from "./store/user";

const router = useRouter();
const userStore = useUserStore();

const cachedViews = ["Home", "RecipeList", "FridgeFinder"];

function logout() {
  userStore.logout();
  router.push("/");
}
</script>
