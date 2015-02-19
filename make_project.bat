: *****************************************************************
: *****************************************************************
:
: フロント開発用のgulp環境構築スクリプト
: 下記構成でフォルダが生成される。
:
: ├─www    : コンパイル結果を保存。アップロードするならここ
: │  ├─css
: │  └─js
: └─_taskruner
:    ├─gulp
:    │  └─tasks    : gulpのタスクを登録するときはここ
:    ├─node_modules
:    └─src        : 開発ディレクトリ。ここで作業した内容が自動でコンパイルされる
:        ├─js
:        │  └─components
:        ├─less
:        └─www
:
: [基本機能]
: srcフォルダ内を監視してless,jsに変更があればコンパイルする
: wwwにテスト用のindex.htmlを作成する
: _task ディレクトリに移動して gulp で初回buildと監視を開始する
: *****************************************************************
: *****************************************************************


chcp 65001

mkdir _task
cd _task

: 簡略化のために空のpackage.jsonを出力する
echo {} > package.json
echo gulp > run-gulp.bat
: npmコマンドを非同期実行。非同期でないとnpm終了時に止まるため
start cmd /c npm install -D require-dir gulp gulp-if gulp-uglify gulp-webpack gulp-logger gulp-filter gulp-less gulp-watch --save-dev

mkdir gulp
mkdir src
cd src
mkdir js
mkdir less
mkdir www

: indexとなるJavaScriptファイルを作成
echo (function () {       > .\js\index.js
echo     'use strict';    >> .\js\index.js
echo     var Hello = require('./components/Hello');>> .\js\index.js
echo     var hello = new Hello();>> .\js\index.js
echo     document.write(hello.message);>> .\js\index.js
echo })();>> .\js\index.js

mkdir .\js\components

: サンプル用にHello.jsを作成
echo function Hello() { > .\js\components\Hello.js
echo     'use strict';>> .\js\components\Hello.js
echo     this.message = 'Hello!';>> .\js\components\Hello.js
echo }>> .\js\components\Hello.js
echo module.exports = Hello;>> .\js\components\Hello.js

:gulp関連をインストール
echo install gulp to local dir

cd ../

echo var requireDir = require('require-dir'); > gulpfile.js
echo requireDir('./gulp/tasks', { recurse: true }); >> gulpfile.js

:タスクの設定を別ファイルに
echo var path = require('path'); > .\gulp\config.js
echo var dest = '../www'; // 出力先ディレクトリ >> .\gulp\config.js
echo var src = './src';  // ソースディレクトリ >> .\gulp\config.js
echo var relativeSrcPath = path.relative('.', src); >> .\gulp\config.js
echo module.exports = { >> .\gulp\config.js
echo   // 出力先の指定 >> .\gulp\config.js
echo   dest: dest, >> .\gulp\config.js
echo   // jsのビルド設定 >> .\gulp\config.js
echo   js: { >> .\gulp\config.js
echo     src: src + '/js/**', >> .\gulp\config.js
echo     dest: dest + '/js', >> .\gulp\config.js
echo     uglify: false >> .\gulp\config.js
echo   }, >> .\gulp\config.js

echo   // webpackの設定 >> .\gulp\config.js
echo   webpack: { >> .\gulp\config.js
echo     entry: src + '/js/index.js', >> .\gulp\config.js
echo     output: { >> .\gulp\config.js
echo       filename: 'bundle.js' >> .\gulp\config.js
echo     }, >> .\gulp\config.js
echo     resolve: { >> .\gulp\config.js
echo       extensions: ['', '.js'] >> .\gulp\config.js
echo     } >> .\gulp\config.js
echo   }, >> .\gulp\config.js

echo  copy: { >> .\gulp\config.js
echo    src: [   // 今後ただコピーするファイルが増えそうなので配列にしておく >> .\gulp\config.js
echo      src + '/www/index.html' >> .\gulp\config.js
echo    ], >> .\gulp\config.js
echo    dest: dest >> .\gulp\config.js
echo  }, >> .\gulp\config.js

echo  less:{ >> .\gulp\config.js
echo    src: src + '/less', >> .\gulp\config.js
echo    dest: dest + '/css' >> .\gulp\config.js
echo  }, >> .\gulp\config.js

: watchタスク用設定
echo  watch: {  >> .\gulp\config.js
echo    js: relativeSrcPath + '/js/**',  >> .\gulp\config.js
echo    less: relativeSrcPath + '/less/**',  >> .\gulp\config.js
echo    www: relativeSrcPath + '/www/index.html'  >> .\gulp\config.js
echo  }  >> .\gulp\config.js

echo } >> .\gulp\config.js

mkdir .\gulp\tasks

:gulpにwebpack タスクを登録
echo // @file webpack.js > .\gulp\tasks\webpack.js
echo var gulp = require('gulp'); >> .\gulp\tasks\webpack.js
echo var gulpif = require('gulp-if'); >> .\gulp\tasks\webpack.js
echo var uglify = require('gulp-uglify'); >> .\gulp\tasks\webpack.js
echo var webpack = require('gulp-webpack'); >> .\gulp\tasks\webpack.js
echo var config = require('../config'); >> .\gulp\tasks\webpack.js
echo // タスク名はファイル名と同じにしておくと見通しが良い >> .\gulp\tasks\webpack.js
echo gulp.task('webpack', function () { >> .\gulp\tasks\webpack.js
echo     gulp.src(config.webpack.entry) >> .\gulp\tasks\webpack.js
echo         .pipe(webpack(config.webpack)) >> .\gulp\tasks\webpack.js
echo         .pipe(gulpif(config.js.uglify, uglify())) >> .\gulp\tasks\webpack.js
echo         .pipe(gulp.dest(config.js.dest)); >> .\gulp\tasks\webpack.js
echo }); >> .\gulp\tasks\webpack.js

: webpackを実行
start cmd /c gulp webpack

:動作確認用のhtmlファイルを作成
echo ^<!doctype html^> > .\src\www\index.html
echo ^<html^> >> .\src\www\index.html
echo ^<head^> >> .\src\www\index.html
echo     ^<title^>gulp test^</title^> >> .\src\www\index.html
echo ^</head^> >> .\src\www\index.html
echo ^<body^> >> .\src\www\index.html
echo ^<script src="js/bundle.js"^>^</script^> >> .\src\www\index.html
echo ^</body^> >> .\src\www\index.html
echo ^</html^> >> .\src\www\index.html

: 確認用ファイルをコピーするタスクを追加
echo var gulp = require('gulp'); >> .\gulp\tasks\copy.js
echo var config = require('../config').copy; >> .\gulp\tasks\copy.js

echo gulp.task('copy', function () { >> .\gulp\tasks\copy.js
echo     gulp.src(config.src) >> .\gulp\tasks\copy.js
echo         .pipe(gulp.dest(config.dest)); >> .\gulp\tasks\copy.js
echo }); >> .\gulp\tasks\copy.js

start cmd /c gulp copy

: lessをタスクに追加
echo 'use strict'; > .\gulp\tasks\less.js

echo var config = require('../config').less; >> .\gulp\tasks\less.js

echo var LESS_DIR = config.src; >> .\gulp\tasks\less.js
echo var CSS_DIR = config.dest; >> .\gulp\tasks\less.js
echo. >> .\gulp\tasks\less.js
echo var path = require('path'); >> .\gulp\tasks\less.js
echo. >> .\gulp\tasks\less.js
echo var gulp = require('gulp'); >> .\gulp\tasks\less.js
echo var logger = require('gulp-logger'); >> .\gulp\tasks\less.js
echo var filter = require('gulp-filter'); >> .\gulp\tasks\less.js
echo var lessc = require('gulp-less'); >> .\gulp\tasks\less.js
echo. >> .\gulp\tasks\less.js
echo gulp.task('less', function() { >> .\gulp\tasks\less.js
echo     gulp.src(path.join(LESS_DIR, '**/*.less'), { base: LESS_DIR }) >> .\gulp\tasks\less.js
echo         .pipe(filter([ '*', '!**/_*.less' ])) >> .\gulp\tasks\less.js
echo         .pipe(lessc()) >> .\gulp\tasks\less.js
echo         .pipe(gulp.dest(CSS_DIR)) >> .\gulp\tasks\less.js
echo         .pipe(logger({ beforeEach: '[less] wrote: ' })); >> .\gulp\tasks\less.js
echo }); >> .\gulp\tasks\less.js

mkdir ..\www\css

：buildタスクを登録

echo // @file build.js > .\gulp\tasks\build.js
echo var gulp = require('gulp'); >> .\gulp\tasks\build.js
echo. >> .\gulp\tasks\build.js
echo gulp.task('build', ['webpack', 'less', 'copy']); >> .\gulp\tasks\build.js

: watchタスクを登録

echo // @file watch.js > .\gulp\tasks\watch.js
echo var gulp = require('gulp'); >> .\gulp\tasks\watch.js
echo var watch = require('gulp-watch'); >> .\gulp\tasks\watch.js
echo var config = require('../config').watch; >> .\gulp\tasks\watch.js
echo. >> .\gulp\tasks\watch.js
echo gulp.task('watch', function () { >> .\gulp\tasks\watch.js
echo     // js >> .\gulp\tasks\watch.js
echo     watch(config.js, function () { >> .\gulp\tasks\watch.js
echo         gulp.start(['webpack']); >> .\gulp\tasks\watch.js
echo     }); >> .\gulp\tasks\watch.js
echo. >> .\gulp\tasks\watch.js
echo     // less >> .\gulp\tasks\watch.js
echo     watch(config.less, function () { >> .\gulp\tasks\watch.js
echo         gulp.start(['less']); >> .\gulp\tasks\watch.js
echo     }); >> .\gulp\tasks\watch.js
echo. >> .\gulp\tasks\watch.js
echo     // www >> .\gulp\tasks\watch.js
echo     watch(config.www, function () { >> .\gulp\tasks\watch.js
echo         gulp.start(['copy']); >> .\gulp\tasks\watch.js
echo     }); >> .\gulp\tasks\watch.js
echo }); >> .\gulp\tasks\watch.js

: default タスクを登録
echo // @file default.js > .\gulp\tasks\default.js
echo var gulp = require('gulp'); >> .\gulp\tasks\default.js
echo.  >> .\gulp\tasks\default.js
echo gulp.task('default', ['build', 'watch']); >> .\gulp\tasks\default.js
