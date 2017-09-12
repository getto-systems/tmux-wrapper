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

### Options

```
tmux_wrapper_color=green
tmux_wrapper_host=localhost
tmux_wrapper_shell=bash

tmux_wrapper_term=xterm-256color
tmux_wrapper_file=~/.tmux.conf

tmux_wrapper_session="<$(basename $0)>"
tmux_wrapper_work_path=~/.tmux.wrapper
tmux_wrapper_status_cmd="uptime | sed 's/.*load average: //'"
```

#### setup tmux new session key bind

```bash
# tmux_wrapper_bind <bind-key> <window-name> <initial-path>

tmux_wrapper_bind c home /path/to/work/dir
```

- create new session with `title = home`, `current dir = /path/to/work/dir`

#### setup environment vars

```bash
tmux_wrapper_env MY_ENV VALUE
```

#### override status func

```bash
tmux_wrapper_build_status(){
  echo 'set -g status-left "#[fg='$tmux_wrapper_color']<'$tmux_wrapper_session'>"' >> "$conf"
  echo 'set -g status-right "#[fg='$tmux_wrapper_color'][#('$tmux_wrapper_status_cmd')]"' >> "$conf"
}
```

#### Almost all

* `tmux_wrapper_host`  : host of connecting ssh. (if localhost, without ssh)
* `tmux_wrapper_color` : status line color -> use in tmux_wrapper_build_status
* `tmux_wrapper_bind`  : setup tmux key bind

#### If nessesary

* `tmux_wrapper_term` : tmux default-terminal
* `tmux_wrapper_session`   : tmux session name

### Examples

```bash
#!/bin/bash

. tmux_wrapper.sh

tmux_wrapper_shell=/bin/zsh
tmux_wrapper_host=192.168.1.1
tmux_wrapper_color=red

tmux_wrapper_bind c home /apps

tmux_wrapper_main
```

- login shell : /bin/zsh
- ssh 192.168.1.1
- status line color : red
- Ctrl-b c -> create new session with `title = home`, `current dir = /apps`

```bash
#!/bin/bash

. tmux_wrapper.sh

tmux_wrapper_color=cyan

tmux_wrapper_main
```

- login shell : bash
- login localhost
- status line color : cyan
