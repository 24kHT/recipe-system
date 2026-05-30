import { createRouter, createWebHistory } from "vue-router";
import { ElMessage } from "element-plus";
import { useUserStore } from "../store/user";

const routes = [
  { path: "/", component: () => import("../views/Home.vue") },
  { path: "/recipes", component: () => import("../views/RecipeList.vue") },
  { path: "/fridge", component: () => import("../views/FridgeFinder.vue") },
  { path: "/recipe/:id", component: () => import("../views/RecipeDetail.vue") },
  { path: "/login", component: () => import("../views/Login.vue") },
  { path: "/register", component: () => import("../views/Register.vue") },
  { path: "/publish", component: () => import("../views/Publish.vue"), meta: { auth: true } },
  { path: "/profile", component: () => import("../views/Profile.vue"), meta: { auth: true } },
  { path: "/admin", component: () => import("../views/Admin.vue"), meta: { auth: true, admin: true } },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((to) => {
  const userStore = useUserStore();
  if (to.meta.auth && !userStore.isLogin) {
    ElMessage.warning("请先登录");
    return "/login";
  }
  if (to.meta.admin && !userStore.isAdmin) {
    ElMessage.warning("没有管理员权限");
    return "/";
  }
  return true;
});

export default router;
