tmux wrapper
============

ホスト、ステータスバーの色を指定して tmux を起動する


usage
-----

以下のようなラッパースクリプトを作成して叩く

```bash
#!/bin/bash

. base.sh

tmux_wrapper_host=192.168.1.1
tmux_wrapper_color=red

tmux_wrapper_path(){
  # bind key, window name, initial path
  echo c name /path/to/dir
}

tmux_wrapper_main
```

仕様
----

* tmux は -S フラグでソケットパス `~/.tmux.wrapper/$tmux_wrapper_id.sock` を指定
* ~/.tmux.conf をベースにして設定を `~/.tmux.wrapper/$tmux_wrapper_id.conf` に結合させて tmux -f でこれを指定
* 指定したホストに ssh する window を作成する
* 初期 window は `tmux_wrapper_path` で最初に指定されたパスで初期化される
* `tmux_wrapper_path` で指定した bind key, window name, initial path で bind の設定が作成される

規約
----

* ラッパースクリプトを別途作成
* ラッパースクリプトは `~/hosts/project_name/env_name/session_name` のようなパスで生成
* `session_name` だけでどのプロジェクトのどの環境、どのセッションか分かる名前をつける


使用可能なオプションとデフォルト
--------------------------------

```
tmux_wrapper_color=green
tmux_wrapper_host=localhost
tmux_wrapper_path(){
  :
}

tmux_wrapper_term=screen-256color
tmux_wrapper_file=~/.tmux.conf

tmux_wrapper_id="tmux${0//\/-}"
tmux_wrapper_session="<$(basename $0)>"
tmux_wrapper_work_path=~/.tmux.wrapper
```

### たいてい指定するもの

* `tmux_wrapper_host`  : 接続するホスト
* `tmux_wrapper_color` : ステータスラインの色
* `tmux_wrapper_path`  : bind に登録するパス

### 必要に応じて指定するもの

* `tmux_wrapper_term` : ターミナル文字列 : screen-256color を受け付けないホストの場合は screen と指定する
* `tmux_wrapper_file` : ベースにする .tmux.conf ファイル : デフォルトのファイルを別にしておきたい場合指定する

### ほぼ指定しないで良いもの

* `tmux_wrapper_id`      : ソケットパス、生成する設定ファイルパスに使用される id
* `tmux_wrapper_session` : セッション名
* `tmux_wrapper_work`    : スクリプトで生成する作業ファイル、ソケットファイルを保存するパス

### tmux_wrapper_path のサンプル

```
tmux_wrapper_path(){
  echo c name /path/to/dir
  echo C-1 name1 /path/to/dir1
  echo C-2 name2 /path/to/dir2
  echo C-3 name3 /path/to/dir3
}
```

と書くと以下のように bind コマンドが生成される

```
bind c neww -n name "ssh $tmux_wrapper_host -t 'cd /path/to/dir; bash'"
bind C-1 neww -n name1 "ssh $tmux_wrapper_host -t 'cd /path/to/dir1; bash'"
bind C-2 neww -n name2 "ssh $tmux_wrapper_host -t 'cd /path/to/dir2; bash'"
bind C-3 neww -n name3 "ssh $tmux_wrapper_host -t 'cd /path/to/dir3; bash'"
```
