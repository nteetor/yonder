module.exports = {
  presets: [
    [
      "@babel/preset-env",
      {
        modules: false,
        bugfixes: true,
        loose: true
      }
    ]
  ],
  exclude: "node_modules/**"
};
