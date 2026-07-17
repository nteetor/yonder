const mapConfig = {
  inline: false,
  annotation: true,
  sourcesContent: true
}

export default () => {
  return {
    map: mapConfig,
    plugins: {
      autoprefixer: {
        cascade: false
      }
    }
  }
}
