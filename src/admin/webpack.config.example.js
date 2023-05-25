'use strict';
const MonacoWebpackPlugin = require('monaco-editor-webpack-plugin');

/* eslint-disable no-unused-vars */
module.exports = (config, webpack) => {
  config.plugins.push(new MonacoWebpackPlugin());
  // Note: we provide webpack above so you should not `require` it
  // Perform customizations to webpack config
  // Important: return the modified config
  return config;
};
