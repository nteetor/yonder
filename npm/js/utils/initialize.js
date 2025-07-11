export default function initialize(callback) {
  if (document.readyState === 'complete') {
    callback()
  } else {
    document.addEventListener('DOMContentLoaded', callback)
  }
}
