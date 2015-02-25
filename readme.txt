フロント開発用のgulp環境
typescript, lessでの開発を想定。

【フォルダ構成】

├─www    コンパイル結果を保存。アップロードするならここ
│  ├─css
│  └─js
└─_task
   ├─gulp
   │  └─tasks    gulpのタスクを登録するときはここ
   ├─node_modules
   └─src        開発ディレクトリ。ここで作業した内容が自動でコンパイルされる
       ├─js
       │  └─components
       ├─less
       └─www

[基本機能]
srcフォルダ内を監視してless,tsに変更があればコンパイルする
wwwにテスト用のindex.htmlを作成する
_task ディレクトリに移動して gulp で初回buildと監視を開始する

[変更履歴]
2015/02/25 javascriptをtypescriptからの生成に変更。webpackは廃止

[メモ]
build,watch を手入力する必要があるので自動化したい
    ※ tasksディレクトリにjsを追加 -> 自動的にデフォルトと監視タスクに追加
