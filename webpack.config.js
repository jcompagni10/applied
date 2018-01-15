var path = require("path");
var webpack = require("webpack");
var plugins = [];


// plugins = plugins.concat( prodPlugins );

module.exports = {
  context: __dirname,
  entry: "./frontend/entry.js",
  output: {
  path: path.resolve(__dirname, 'app', 'assets', 'javascripts'),
  filename: "bundle.js"
  },
  target: 'web',
  plugins: [
    new webpack.IgnorePlugin(/jsdom$/),
    new webpack.IgnorePlugin(/zombie$/)
  ],
  module: {
  loaders: [
    {
    test: [/\.jsx?$/, /\.js?$/],
    exclude: /node_modules/,
    loader: 'babel-loader',
    query: {
      presets: ['es2015', 'react']
    }
    }
  ]
  },
  node: {
    fs: 'empty'
  },
  devtool: 'source-map',
  resolve: {
    extensions: [".js", ".jsx", "*", ".node"]
  }
};
