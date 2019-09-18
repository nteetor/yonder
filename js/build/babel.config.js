export default {
  presets: [
    [
      "@babel/preset-env",
      {
        modules: false,
        loose: true
      }
    ]
  ],
  plugins: [
    "@babel/plugin-proposal-object-rest-spread",
    "@babel/plugin-proposal-class-properties"
  ],
  exclude: "node_modules/**"
};
