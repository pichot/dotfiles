PROMPT='%{$fg[cyan]%}%m: %{$fg[yellow]%}$(get_pwd)%{$reset_color%} rb:%{$fg[blue]%}$(rb_prompt)%{$reset_color%} py:%{$fg[blue]%}$(py_prompt)%{$reset_color%} $(git_prompt_info)
%{$fg[red]%}] %{$reset_color%}'

function get_pwd() {
   echo "${PWD/$HOME/~}"
}

rb_prompt(){
  if $(which rbenv &> /dev/null)
  then
    echo "$(rbenv version | awk '{print $1}')"
  else
    echo ""
  fi
}

py_prompt(){
  if $(which pythonbrew &> /dev/null)
  then
    echo "$(py_version)"
  else
    echo ""
  fi
}

function py_version(){
  echo "$(
python << EOF
import platform
print(platform.python_version())
EOF
  )"
}

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

ZSH_THEME_GIT_PROMPT_PREFIX="{"
ZSH_THEME_GIT_PROMPT_SUFFIX="}"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]+"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"
