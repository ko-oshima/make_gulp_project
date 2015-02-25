var path = require('path');
var dest = '../www'; // 出力先ディレクトリ
var src = './src';  // ソースディレクトリ
var relativeSrcPath = path.relative('.', src);
module.exports = {
  // 出力先の指定
  dest: dest,
  // jsのビルド設定
  js: {
    src: src + '/js/**',
    dest: dest + '/js',
    uglify: false
  },
//  // webpackの設定
//  webpack: {
//    entry: src + '/js/index.js',
//    output: {
//      filename: 'bundle.js'
//    },
//    resolve: {
//      extensions: ['', '.js']
//    }
//  },
 tsc: {
     src: src + '/js/*.ts',
     destname: 'main.js',
     options:{ target: "ES5", removeComments: true, sortOutput: true }
 },
 copy: {
   src: [   // 今後ただコピーするファイルが増えそうなので配列にしておく
     src + '/www/index.html'
   ],
   dest: dest
 },
 less:{
   src: src + '/less',
   dest: dest + '/css'
 },
 watch: {
   js: relativeSrcPath + '/js/**',
   less: relativeSrcPath + '/less/**',
   www: relativeSrcPath + '/www/index.html'
 }
}
