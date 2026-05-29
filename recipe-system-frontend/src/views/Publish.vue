<template>
  <section class="panel">
    <div class="section-head">
      <div>
        <h2>发布菜谱</h2>
        <p class="muted">填写基本信息、食材和步骤后即可发布。</p>
      </div>
    </div>
    <el-form :model="form" label-position="top" @submit.prevent="submit">
      <div class="form-grid">
        <el-form-item label="菜谱名称">
          <el-input v-model="form.title" />
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="form.categoryId" placeholder="选择分类">
            <el-option v-for="item in categories" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="难度">
          <el-select v-model="form.difficulty">
            <el-option label="简单" value="简单" />
            <el-option label="中等" value="中等" />
            <el-option label="较难" value="较难" />
          </el-select>
        </el-form-item>
        <el-form-item label="烹饪时间（分钟）">
          <el-input-number v-model="form.cookingTime" :min="1" :max="600" />
        </el-form-item>
      </div>
      <el-form-item label="封面图片 URL">
        <el-input v-model="form.coverImage" />
      </el-form-item>
      <el-form-item label="简介">
        <el-input v-model="form.description" type="textarea" :rows="3" />
      </el-form-item>

      <div class="section-head compact">
        <h3>食材</h3>
        <el-button @click="addIngredient">添加食材</el-button>
      </div>
      <div v-for="(item, index) in form.ingredients" :key="index" class="inline-row">
        <el-input v-model="item.name" placeholder="食材名称" />
        <el-input v-model="item.amount" placeholder="用量" />
        <el-button @click="form.ingredients.splice(index, 1)">删除</el-button>
      </div>

      <div class="section-head compact">
        <h3>步骤</h3>
        <el-button @click="addStep">添加步骤</el-button>
      </div>
      <div v-for="(item, index) in form.steps" :key="index" class="inline-row step-row">
        <span class="step-index">{{ index + 1 }}</span>
        <el-input v-model="item.content" placeholder="步骤说明" />
        <el-button @click="form.steps.splice(index, 1)">删除</el-button>
      </div>

      <el-form-item label="小贴士">
        <el-input v-model="form.tips" type="textarea" :rows="3" />
      </el-form-item>
      <el-button type="primary" :loading="loading" native-type="submit">发布</el-button>
    </el-form>
  </section>
</template>

<script setup>
import { onMounted, reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import { categoryApi, recipeApi } from "../api";

const router = useRouter();
const categories = ref([]);
const loading = ref(false);
const form = reactive({
  title: "",
  categoryId: null,
  coverImage: "",
  description: "",
  difficulty: "简单",
  cookingTime: 30,
  tips: "",
  ingredients: [{ name: "", amount: "", sort: 1 }],
  steps: [{ stepNo: 1, content: "", image: "" }],
});

function addIngredient() {
  form.ingredients.push({ name: "", amount: "", sort: form.ingredients.length + 1 });
}

function addStep() {
  form.steps.push({ stepNo: form.steps.length + 1, content: "", image: "" });
}

async function submit() {
  loading.value = true;
  try {
    const payload = {
      ...form,
      ingredients: form.ingredients.map((item, index) => ({ ...item, sort: index + 1 })),
      steps: form.steps.map((item, index) => ({ ...item, stepNo: index + 1 })),
    };
    const recipe = await recipeApi.create(payload);
    ElMessage.success("发布成功");
    router.push(`/recipe/${recipe.id}`);
  } finally {
    loading.value = false;
  }
}

onMounted(async () => {
  categories.value = await categoryApi.list();
});
</script>
