<script setup lang="ts">
import BottomNav from '@/components/BottomNav.vue'
</script>

<template>
  <div class="shell">
    <main class="main">
      <RouterView />
    </main>
    <BottomNav />
  </div>
</template>

<style scoped>
.shell {
  position: relative;
  width: 100%;
  max-width: 480px;
  margin: 0 auto;
  height: 100vh;
  height: 100dvh;
  display: flex;
  flex-direction: column;
  background: var(--bg);
}
.main {
  flex: 1;
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
  padding-bottom: calc(62px + var(--safe-bottom));
}
</style>
