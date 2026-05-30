import { createRouter, createWebHistory } from "vue-router";
import { ElMessage } from "element-plus";
import { useUserStore } from "../store/user";

const routes = [
  { path: "/", name: "Home", component: () => import("../views/Home.vue"), meta: { keepAlive: true } },
  { path: "/recipes", name: "RecipeList", component: () => import("../views/RecipeList.vue"), meta: { keepAlive: true } },
  { path: "/fridge", name: "FridgeFinder", component: () => import("../views/FridgeFinder.vue"), meta: { keepAlive: true } },
  { path: "/recipe/:id", name: "RecipeDetail", component: () => import("../views/RecipeDetail.vue") },
  { path: "/login", name: "Login", component: () => import("../views/Login.vue") },
  { path: "/register", name: "Register", component: () => import("../views/Register.vue") },
  { path: "/publish", name: "Publish", component: () => import("../views/Publish.vue"), meta: { auth: true } },
  { path: "/profile", name: "Profile", component: () => import("../views/Profile.vue"), meta: { auth: true } },
  { path: "/admin", name: "Admin", component: () => import("../views/Admin.vue"), meta: { auth: true, admin: true } },
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
