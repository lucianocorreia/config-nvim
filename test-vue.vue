<template>
  <div id="app">
    <h1>{{ message }}</h1>
    <button @click="incrementCounter">Count: {{ counter }}</button>
  </div>
</template>

<script>
export default {
  name: 'App',
  data() {
    return {
      message: 'Hello Vue 2!',
      counter: 0
    }
  },
  methods: {
    incrementCounter() {
      this.counter++
    }
  }
}
</script>

<style scoped>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
