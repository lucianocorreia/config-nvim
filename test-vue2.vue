<template>
  <div class="app">
    <h1>{{ title }}</h1>
    <p>{{ message }}</p>
    <button @click="handleClick">Click me</button>
    <ul>
      <li v-for="item in items" :key="item.id">
        {{ item.name }}
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'TestComponent',
  data() {
    return {
      title: 'Vue 2 Test',
      message: 'Hello from Vue 2!',
      items: [
        { id: 1, name: 'Item 1' },
        { id: 2, name: 'Item 2' },
        { id: 3, name: 'Item 3' }
      ]
    }
  },
  methods: {
    handleClick() {
      this.message = 'Button clicked!'
    },
    addItem() {
      this.items.push({
        id: Date.now(),
        name: `Item ${this.items.length + 1}`
      })
    }
  },
  mounted() {
    console.log('Component mounted')
  }
}
</script>

<style scoped>
.app {
  font-family: Arial, sans-serif;
  padding: 20px;
}

h1 {
  color: #42b883;
}

button {
  background-color: #42b883;
  color: white;
  border: none;
  padding: 10px 15px;
  cursor: pointer;
  border-radius: 4px;
}

button:hover {
  background-color: #369870;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  padding: 5px;
  margin: 5px 0;
  background-color: #f4f4f4;
  border-radius: 3px;
}
</style>
