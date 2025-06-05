class ValuesMap {
  #values = null
  #callback = null

  constructor(iterable = {}) {
    this.#callback = (debounce) => {}
    this.#values = Object.fromEntries(iterable)
  }

  set callback(f) {
    this.#callback = f
  }

  get callback() {
    return this.#callback
  }

  set(key, value) {
    this.#values[key] = value
    this.#callback()
    return this
  }

  get(key) {
    return this.#values[key]
  }

  entries() {
    return this.#values
  }
}

export default ValuesMap