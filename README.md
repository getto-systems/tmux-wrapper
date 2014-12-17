tmux wrapper
============

ホスト、ステータスバーの色を指定して tmux を起動する


usage
-----

```bash
#!/bin/bash

. base.sh

tmux_wrapper_session=myhost
tmux_wrapper_color=cyan
tmux_wrapper_host=192.168.1.1

tmux_wrapper_path(){
  # bind key, name, path
  echo C name /path/to/dir
}

tmux_wrapper_main
```

仕様
----

* tmux は -S フラグでソケットパス ~/.tmux.wrapper.sock を指定
* ~/.tmux.conf をベースにして設定を ~/.tmux.wrapper.conf に結合させて tmux -f では ~/.tmux.wrapper.conf を使用する
* 指定したホストに ssh する window を作成する
* 初期 window は `tmux_wrapper_path` で最初に指定されたパスで初期化される
* `tmux_wrapper_path` で指定した bind key, window name, path で bind の設定が作成される


使用可能なオプションとデフォルト
--------------------------------

```
tmux_wrapper_session=Session
tmux_wrapper_file=~/.tmux.conf
tmux_wrapper_color=cyan
tmux_wrapper_term=screen-256color
tmux_wrapper_host=localhost
tmux_wrapper_path(){
  :
}

tmux_wrapper_work=~/.tmux.wrapper.conf
tmux_wrapper_socket=~/.tmux.wrapper.sock
```

* `tmux_wrapper_session` : セッション名
* `tmux_wrapper_file`    : ベースにする .tmux.conf ファイル
* `tmux_wrapper_color`   : ステータスの fg 色
* `tmux_wrapper_term`    : ターミナル文字列
* `tmux_wrapper_host`    : 接続するホスト
* `tmux_wrapper_path`    : bind に登録するパス

* `tmux_wrapper_work`   : 生成する作業 .tmux.conf ファイル
* `tmux_wrapper_socket` : -S で指定するソケットパス

### tmux_wrapper_path

```
tmux_wrapper_path(){
  echo c name /path/to/dir
  echo C-1 name1 /path/to/dir1
  echo C-2 name2 /path/to/dir2
  echo C-3 name3 /path/to/dir3
}
```

と書くと

```
bind c neww -n name "ssh $tmux_wrapper_host -t 'cd /path/to/dir; bash'"
bind C-1 neww -n name1 "ssh $tmux_wrapper_host -t 'cd /path/to/dir1; bash'"
bind C-2 neww -n name2 "ssh $tmux_wrapper_host -t 'cd /path/to/dir2; bash'"
bind C-3 neww -n name3 "ssh $tmux_wrapper_host -t 'cd /path/to/dir3; bash'"
```
