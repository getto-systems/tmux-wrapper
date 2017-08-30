#!/bin/bash

declare -A tmux_wrapper_envs
declare -a tmux_wrapper_env_names

declare -A tmux_wrapper_bind_titles
declare -A tmux_wrapper_bind_paths
declare -a tmux_wrapper_bind_names

tmux_wrapper_env(){
  tmux_wrapper_env_names[${#tmux_wrapper_env_names[@]}]=$1
  tmux_wrapper_envs[$1]=$2
}
tmux_wrapper_bind(){
  if [ -z "$tmux_wrapper_initial_window_name" ]; then
    tmux_wrapper_initial_window_name=$2
  fi
  if [ -z "$tmux_wrapper_initial_window_path" ]; then
    tmux_wrapper_initial_window_path=$3
  fi

  tmux_wrapper_bind_names[${#tmux_wrapper_bind_names[@]}]=$1
  tmux_wrapper_bind_titles[$1]=$2
  tmux_wrapper_bind_paths[$1]=$3
}

tmux_wrapper_main(){
  if [ -z "$tmux_wrapper_file" ]; then
    tmux_wrapper_file=~/.tmux.conf
  fi
  if [ -z "$tmux_wrapper_work_path" ]; then
    tmux_wrapper_work_path=~/.tmux.wrapper
  fi
  if [ -z "$tmux_wrapper_term" ]; then
    tmux_wrapper_term=screen-256color
  fi
  if [ -z "$tmux_wrapper_host" ]; then
    tmux_wrapper_host=localhost
  fi
  if [ -z "$tmux_wrapper_shell" ]; then
    tmux_wrapper_shell=bash
  fi
  if [ -z "$tmux_wrapper_color" ]; then
    tmux_wrapper_color=green
  fi

  if [ -z "$tmux_wrapper_id" ]; then
    tmux_wrapper_id=${0}
    tmux_wrapper_id="tmux-${tmux_wrapper_id//\//-}"
  fi
  if [ -z "$tmux_wrapper_session" ]; then
    tmux_wrapper_session="$(basename $0)"
  fi

  if [ ! -d "$tmux_wrapper_work_path" ]; then
    mkdir -p "$tmux_wrapper_work_path"
  fi

  tmux_wrapper_work=$tmux_wrapper_work_path/$tmux_wrapper_id.conf
  tmux_wrapper_socket=$tmux_wrapper_work_path/$tmux_wrapper_id.sock

  if [ "$tmux_wrapper_host" == localhost ]; then
    tmux_status_cmd=uptime
  else
    tmux_status_cmd="ssh $tmux_wrapper_host uptime"
  fi

  cp "$tmux_wrapper_file" "$tmux_wrapper_work"
  echo >> "$tmux_wrapper_work"
  echo "# generated by tmux-wrapper" >> "$tmux_wrapper_work"
  echo >> "$tmux_wrapper_work"
  echo 'set -g default-terminal "'$tmux_wrapper_term'"' >> "$tmux_wrapper_work"
  echo 'set -g status-left "#[fg='$tmux_wrapper_color']<'$tmux_wrapper_session'>"' >> "$tmux_wrapper_work"
  echo 'set -g status-right "#[fg='$tmux_wrapper_color'][#('$tmux_status_cmd' | sed '"'s/.*load average: //'"')]"' >> "$tmux_wrapper_work"

  tmux_wrapper_build_env
  tmux_wrapper_build_bind

  tmux_wrapper_exec
}
tmux_wrapper_build_bind(){
  local cmd
  local bind_name

  if [ "$tmux_wrapper_host" == localhost ]; then
    cmd="$tmux_wrapper_shell -c"
  else
    cmd="ssh $tmux_wrapper_host -t"
  fi

  if [ ${#tmux_wrapper_bind_names[@]} -gt 0 ]; then
    for bind_name in ${tmux_wrapper_bind_names[@]}; do
      echo bind $bind_name neww -n ${tmux_wrapper_bind_titles[$bind_name]} '"'$cmd' '"'cd ${tmux_wrapper_bind_paths[$bind_name]}; $tmux_wrapper_shell'"'"' >> "$tmux_wrapper_work"
    done
  fi
}
tmux_wrapper_build_env(){
  local env_name

  if [ ${#tmux_wrapper_env_names[@]} -gt 0 ]; then
    for env_name in ${tmux_wrapper_env_names[@]}; do
      echo "set-environment -g $env_name ${tmux_wrapper_envs[$env_name]}" >> "$tmux_wrapper_work"
    done
  fi
}
tmux_wrapper_exec(){
  local cmd

  if tmux -S "$tmux_wrapper_socket" has -t "$tmux_wrapper_session" 2> /dev/null; then
    tmux -S "$tmux_wrapper_socket" source "$tmux_wrapper_work"
    tmux -S "$tmux_wrapper_socket" attach -t "$tmux_wrapper_session"
    return
  fi

  if [ "$tmux_wrapper_host" == localhost ]; then
    cmd=$tmux_wrapper_shell
  else
    cmd="ssh $tmux_wrapper_host"
  fi

  if [ -z "$tmux_wrapper_initial_window_name" ]; then
    tmux_wrapper_exec_bare
    return
  fi
  if [ -z "$tmux_wrapper_initial_window_path" ]; then
    tmux_wrapper_exec_bare
    return
  fi

  if [ "$tmux_wrapper_host" == localhost ]; then
    cmd="$cmd -c"
  else
    cmd="$cmd -t"
  fi
  cmd="$cmd 'cd $tmux_wrapper_initial_window_path; $tmux_wrapper_shell'"

  tmux -2 -u -S "$tmux_wrapper_socket" -f "$tmux_wrapper_work" new -s "$tmux_wrapper_session" -n "$tmux_wrapper_initial_window_name" "$cmd"
}
tmux_wrapper_exec_bare(){
  tmux -2 -u -S "$tmux_wrapper_socket" -f "$tmux_wrapper_work" new -s "$tmux_wrapper_session" -n "$tmux_wrapper_session" "$cmd"
}
