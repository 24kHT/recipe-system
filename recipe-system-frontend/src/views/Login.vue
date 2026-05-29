<template>
  <section class="auth-wrap">
    <el-form class="panel auth-panel" :model="form" label-position="top" @submit.prevent="submit">
      <h2>登录</h2>
      <el-form-item label="用户名">
        <el-input v-model="form.username" autocomplete="username" />
      </el-form-item>
      <el-form-item label="密码">
        <el-input v-model="form.password" type="password" autocomplete="current-password" show-password />
      </el-form-item>
      <el-button type="primary" :loading="loading" native-type="submit">登录</el-button>
      <p class="muted">没有账号？<RouterLink class="text-link" to="/register">去注册</RouterLink></p>
    </el-form>
  </section>
</template>

<script setup>
import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { useUserStore } from "../store/user";

const router = useRouter();
const userStore = useUserStore();
const loading = ref(false);
const form = reactive({
  username: "",
  password: "",
});

async function submit() {
  loading.value = true;
  try {
    await userStore.login(form);
    router.push("/");
  } finally {
    loading.value = false;
  }
}
</script>
