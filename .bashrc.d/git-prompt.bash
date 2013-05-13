# set git executable path
GIT="/usr/bin/git"

[[ -x $GIT ]] || {
  echo "Error: git was not found or is not executable" 1>&2 
  return
}

function build_git_ptompt {

  local GIT_IS_WORKING_TREE="$($GIT rev-parse --is-inside-work-tree 2>/dev/null)";  

  if [ "true" = "${GIT_IS_WORKING_TREE}" ]; then

    local GIT_BRANCH=$($GIT branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/');
    local GIT_STATUS=$($GIT status --porcelain 2> /dev/null);
    local GIT_REMOTE=$($GIT remote | grep "^origin")
    local GIT_CLEAN="${LIGHT_GREEN}✔"
    local GIT_WARNING=""


    printf "%s" "[${LIGHT_GREEN}"
    printf "%s" "${GIT_BRANCH}";

    # untracked files
    [[ "${GIT_STATUS}" = M*  ]] && GIT_WARNING="${GREEN}●";  
    # unstaged files
    [[ "${GIT_STATUS}" = [[:space:]]M* ]] && GIT_WARNING="${GIT_WARNING}${YELLOW}●";  
    # uncommitted files
    [[ "${GIT_STATUS}" = '??'* ]] && GIT_WARNING="${GIT_WARNING}${ORANGE}●";  

    if [ "origin" = "$GIT_REMOTE" ]; then
      local GIT_NEED_PULL=$($GIT rev-list HEAD...origin/master --count);
      # need a pull from origin or to push
      [[ $GIT_NEED_PULL -gt 0 ]] && GIT_WARNING="${GIT_WARNING}${RED}●";
    fi 

    if [ -n "$GIT_WARNING" ]; then
      printf "%s"  " ${GIT_WARNING}";
    else
      printf "%s" " ${GIT_CLEAN}";
    fi

    printf "%s" "${RESET}]";
  fi  
}

function git_ruby {
  [[ -s ".rvmrc" ]] && {
    source ".rvmrc";
    [[ -n "$environment_id" ]] && printf "[⌘ %s]" "$environment_id"
  }
}

function git_prompt() {

  # colors
  local BLUE="\[\033[0;34m\]"
  local LIGHT_BLUE="\[\033[1;34m\]"
  local RED="\[\033[0;31m\]"
  local LIGHT_RED="\[\033[1;31m\]"
  local ORANGE="\[\033[38;5;202m\]"
  local GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local YELLOW="\[\033[1;33m\]"
  local DARK_YELLOW="\[\033[0;33m\]"
  local PURPLE="\[\033[0;35m\]"
  local LIGHT_PURPLE="\[\033[1;35m\]"
  local CYAN="\[\033[0;36m\]"
  local LIGHT_CYAN="\[\033[1;36m\]"
  local GRAY="\[\033[1;30m\]"
  local LIGHT_GRAY="\[\033[0;37m\]"
  local WHITE="\[\033[1;37m\]"
  local RESET="\[\033[0m\]"

  local USERNAME_COLOR="${YELLOW}"
  local DASH_COLOR="${RESET}"  
  local HOST_COLOR="${GRAY}"
  local PATH_COLOR="${CYAN}"

  if [ $(id -u) -eq 0 ]; then
    # root colors are different
    USERNAME_COLOR="${LIGHT_RED}"
    DASH_COLOR="${LIGHT_RED}"
    HOST_COLOR="${GRAY}"
    PATH_COLOR="${LIGHT_GRAY}"
  fi

  local TERM_TITLE='\[\033]0;\u@\h:\w\007\]'  
  local PROMPT_START="[${USERNAME_COLOR}\u${RESET}][${HOST_COLOR}\h:${PATH_COLOR}\w${RESET}]"

  export PS1="${TERM_TITLE}${PROMPT_START}$(build_git_ptompt)${DASH_COLOR}\\$ ${RESET}";

  unset GIT_PROMPT
}

PROMPT_COMMAND=git_prompt

