<template>
  <section class="auth-wrap">
    <el-form class="panel auth-panel" :model="form" label-position="top" @submit.prevent="submit">
      <h2>注册</h2>
      <el-form-item label="用户名">
        <el-input v-model="form.username" autocomplete="username" />
      </el-form-item>
      <el-form-item label="密码">
        <el-input v-model="form.password" type="password" autocomplete="new-password" show-password />
      </el-form-item>
      <el-form-item label="昵称">
        <el-input v-model="form.nickname" />
      </el-form-item>
      <el-form-item label="邮箱">
        <el-input v-model="form.email" />
      </el-form-item>
      <el-form-item label="手机号">
        <el-input v-model="form.phone" />
      </el-form-item>
      <el-button type="primary" :loading="loading" native-type="submit">创建账号</el-button>
      <p class="muted">已有账号？<RouterLink class="text-link" to="/login">去登录</RouterLink></p>
    </el-form>
  </section>
</template>

<script setup>
import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import { userApi } from "../api";

const router = useRouter();
const loading = ref(false);
const form = reactive({
  username: "",
  password: "",
  nickname: "",
  email: "",
  phone: "",
});

async function submit() {
  loading.value = true;
  try {
    await userApi.register(form);
    ElMessage.success("注册成功，请登录");
    router.push("/login");
  } finally {
    loading.value = false;
  }
}
</script>
