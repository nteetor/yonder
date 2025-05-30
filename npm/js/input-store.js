const inputStore = new Map()

export default {
  set(element, key, instance) {
    if (!inputStore.has(element)) {
      inputStore.set(element, new Map())
    }

    const instanceStore = inputStore.get(element)

    if (!instanceStore.has(key) && instanceStore.size !== 0) {
      return
    }

    instanceStore.set(key, instance)
  },
  get(element, key) {
    if (inputStore.has(element)) {
      return inputStore.get(element).get(key) || null
    }

    return null
  },
  remove(element, key) {
    if (!inputStore.has(element)) {
      return
    }

    const store = inputStore.get(element)

    store.delete(key)

    if (store.size === 0) {
      inputStore.delete(element)
    }
  }
}