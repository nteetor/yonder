const dataStore = (() => {
  const storeData = {}
  let id = 1

  return {
    set(element, key, data) {
      if (typeof element.key === "undefined") {
        element.key = {
          key,
          id
        }
        id++
      };

      storeData[element.key.id] = data
    },
    get(element, key) {
      if (!element || typeof element.key === "undefined") {
        return null
      }

      const keyProperties = element.key
      if (keyProperties.key === key) {
        return storeData[keyProperties.id]
      }

      return null
    },
    delete(element, key) {
      if (typeof element.key === "undefined") {
        return
      }

      const keyProperties = element.key
      if (keyProperties.key === key) {
        delete storeData[keyProperties.id]
        delete element.key
      }
    }
  }
})()

const Store = {
  setData(instance, key, data) {
    dataStore.set(instance, key, data)
  },
  getData(instance, key) {
    return dataStore.get(instance, key)
  },
  removeData(instance, key) {
    dataStore.delete(instance, key)
  }
}

export default Store
