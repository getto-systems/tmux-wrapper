# tmux wrapper

create tmux session with host, status-bar color, etc


## Usage

```bash
#!/bin/bash

. tmux_wrapper.sh

tmux_wrapper_shell=/bin/zsh
tmux_wrapper_host=192.168.1.1
tmux_wrapper_color=red

# <bind-key> <window-name> <initial-path>
tmux_wrapper_bind c home /path/to/home

tmux_wrapper_env MY_ENV VALUE

tmux_wrapper_main
```

仕様
----

* ~/.tmux.conf をベースにして設定を `~/.tmux.wrapper/$tmux_wrapper_session.conf` に結合させて tmux -f でこれを指定
* 指定したホストに ssh する window を作成する
* 初期 window は `tmux_wrapper_bind` で最初に指定されたパスで初期化される
* `tmux_wrapper_build_bind` で指定した bind-key, window-name, initial-path で bind の設定が作成される

規約
----

* ラッパースクリプトを別途作成
* ラッパースクリプトは `~/hosts/project_name/env_name/session_name` のようなパスに設置
* ラッパースクリプトの basename `session_name` だけでどのプロジェクトのどの環境、どのセッションか分かる名前をつける
* 一つのセッションで一つのホストへログイン
* 一つのソケット(tmux サーバープロセス)につき一つのセッションのみ生成


使用可能なオプションとデフォルト
--------------------------------

```
tmux_wrapper_color=green
tmux_wrapper_host=localhost
tmux_wrapper_shell=bash

tmux_wrapper_term=xterm-256color
tmux_wrapper_file=~/.tmux.conf
tmux_wrapper_initial_window_name=""
tmux_wrapper_initial_window_path=""

tmux_wrapper_session="<$(basename $0)>"
tmux_wrapper_work_path=~/.tmux.wrapper
tmux_wrapper_status_cmd=uptime

tmux_wrapper_build_status(){
  echo 'set -g status-left "#[fg='$tmux_wrapper_color']<'$tmux_wrapper_session'>"' >> "$conf"
  echo 'set -g status-right "#[fg='$tmux_wrapper_color'][#('$tmux_wrapper_status_cmd' | sed '"'s/.*load average: //'"')]"' >> "$conf"
}
```

### たいてい指定するもの

* `tmux_wrapper_host`  : 接続するホスト
* `tmux_wrapper_color` : ステータスラインの色
* `tmux_wrapper_bind`  : bind コマンドを生成

### 必要に応じて指定するもの

* `tmux_wrapper_term` : ターミナル文字列 : screen-256color を受け付けないホストの場合は screen と指定する
* `tmux_wrapper_file` : ベースにする .tmux.conf ファイル : デフォルトのファイルを別にしておきたい場合指定する
* `tmux_wrapper_initial_window_name` : 初期ウインドウ名 : 空白なら最初に `tmux_wrapper_bind` した名前
* `tmux_wrapper_initial_window_path` : 初期パス : 空白なら最初に `tmux_wrapper_bind` したパス

### ほぼ指定しないで良いもの

* `tmux_wrapper_session`   : セッション名
