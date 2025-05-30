const boundInputs = new Map()

export default {
  set(element, key, instance) {
    if (!boundInputs.has(element)) {
      boundInputs.set(element, new Map())
    }

    const store = boundInputs.get(element)

    if (!store.has(key) && store.size !== 0) {
      return
    }

    store.set(key, instance)

    console.log(boundInputs)
  },
  get(element, key) {
    if (boundInputs.has(element)) {
      return boundInputs.get(element).get(key) || null
    }

    return null
  },
  remove(element, key) {
    if (!boundInputs.has(element)) {
      return
    }

    const store = boundInputs.get(element)

    store.delete(key)

    if (store.size === 0) {
      boundInputs.delete(element)
    }
  }
}