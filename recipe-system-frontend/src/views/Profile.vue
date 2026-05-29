<template>
  <section class="detail-layout">
    <div class="panel">
      <h2>个人资料</h2>
      <el-form :model="profile" label-position="top" @submit.prevent="saveProfile">
        <el-form-item label="昵称">
          <el-input v-model="profile.nickname" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="profile.email" />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="profile.phone" />
        </el-form-item>
        <el-form-item label="头像 URL">
          <el-input v-model="profile.avatar" />
        </el-form-item>
        <el-form-item label="个人简介">
          <el-input v-model="profile.bio" type="textarea" :rows="3" />
        </el-form-item>
        <el-button type="primary" native-type="submit">保存资料</el-button>
      </el-form>

      <h2>修改密码</h2>
      <el-form :model="passwordForm" label-position="top" @submit.prevent="savePassword">
        <el-form-item label="原密码">
          <el-input v-model="passwordForm.oldPassword" type="password" show-password />
        </el-form-item>
        <el-form-item label="新密码">
          <el-input v-model="passwordForm.newPassword" type="password" show-password />
        </el-form-item>
        <el-button native-type="submit">修改密码</el-button>
      </el-form>
    </div>

    <div class="panel">
      <el-tabs v-model="activeTab">
        <el-tab-pane label="我的菜谱" name="recipes">
          <div class="mini-list">
            <div v-for="item in myRecipes" :key="item.id" class="mini-item">
              <RouterLink :to="`/recipe/${item.id}`">{{ item.title }}</RouterLink>
              <span class="muted">{{ item.status === 1 ? "已上架" : "已下架" }}</span>
            </div>
            <el-empty v-if="myRecipes.length === 0" description="暂无发布" />
          </div>
        </el-tab-pane>
        <el-tab-pane label="我的收藏" name="favorites">
          <div class="mini-list">
            <RouterLink v-for="item in favorites" :key="item.id" class="mini-item" :to="`/recipe/${item.id}`">
              {{ item.title }}
            </RouterLink>
            <el-empty v-if="favorites.length === 0" description="暂无收藏" />
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>
  </section>
</template>

<script setup>
import { onMounted, reactive, ref } from "vue";
import { ElMessage } from "element-plus";
import { favoriteApi, recipeApi, userApi } from "../api";
import { useUserStore } from "../store/user";

const userStore = useUserStore();
const activeTab = ref("recipes");
const myRecipes = ref([]);
const favorites = ref([]);
const profile = reactive({
  nickname: "",
  email: "",
  phone: "",
  avatar: "",
  bio: "",
});
const passwordForm = reactive({
  oldPassword: "",
  newPassword: "",
});

function fillProfile(user) {
  Object.assign(profile, {
    nickname: user?.nickname || "",
    email: user?.email || "",
    phone: user?.phone || "",
    avatar: user?.avatar || "",
    bio: user?.bio || "",
  });
}

async function saveProfile() {
  const user = await userApi.updateProfile(profile);
  userStore.user = user;
  localStorage.setItem("recipe_user", JSON.stringify(user));
  ElMessage.success("资料已保存");
}

async function savePassword() {
  await userApi.updatePassword(passwordForm);
  passwordForm.oldPassword = "";
  passwordForm.newPassword = "";
  ElMessage.success("密码已修改");
}

onMounted(async () => {
  fillProfile(userStore.user);
  const [recipes, favoriteRecipes] = await Promise.all([recipeApi.mine(), favoriteApi.mine()]);
  myRecipes.value = recipes;
  favorites.value = favoriteRecipes;
});
</script>
