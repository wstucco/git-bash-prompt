# set git executable path
GIT="/usr/bin/git"

[[ -x $GIT ]] || {
  echo "Error: git was not found or is not executable" 1>&2 
  return
}

function parse_git_prompt {

  local GIT_IS_WORKING_TREE="$($GIT rev-parse --is-inside-work-tree 2>/dev/null)";  

  if [ "true" = "${GIT_IS_WORKING_TREE}" ]; then

    local GIT_BRANCH=$($GIT branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/');
    local GIT_STATUS=$($GIT status --porcelain 2> /dev/null);
    local GIT_UNCOMMITTED=$(echo "$GIT_STATUS" | grep "^M" | wc -l);
    local GIT_UNSTAGED=$(echo "$GIT_STATUS" | grep "^ M" | wc -l);
    local GIT_UNTRACKED=$(echo "$GIT_STATUS" | grep "^??" | wc -l);
    local GIT_REMOTE=$($GIT remote | grep "^origin")
    local GIT_CLEAN="${LIGHT_GREEN}✔"
    local GIT_WARNING=""


    GIT_PROMPT="[${LIGHT_GREEN}";
    GIT_PROMPT="${GIT_PROMPT}${GIT_BRANCH}";

    # untracked files
    [[ $GIT_UNTRACKED -gt 0 ]] && GIT_WARNING="${GREEN}●";  
    # unstaged files
    [[ $GIT_UNSTAGED -gt 0 ]] && GIT_WARNING="${GIT_WARNING}${YELLOW}●";  
    # uncommitted files
    [[ $GIT_UNCOMMITTED -gt 0 ]] && GIT_WARNING="${GIT_WARNING}${ORANGE}●";  

    if [ "origin" = "$GIT_REMOTE" ]; then
      local GIT_NEED_PULL=$($GIT rev-list HEAD...origin/master --count);
      [[ $GIT_NEED_PULL -gt 0 ]] && GIT_WARNING="${GIT_WARNING}${RED}●";
    fi 

    if [ -n "$GIT_WARNING" ]; then
      GIT_PROMPT="${GIT_PROMPT} ${GIT_WARNING}";
    else
      GIT_PROMPT="${GIT_PROMPT} ${GIT_CLEAN}";
    fi

    # need a pull from origin
    GIT_PROMPT="${GIT_PROMPT}${RESET}]";
  fi  
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

  if [ "$(id -u)" -eq 0 ]; then
    # root here
    USERNAME_COLOR="${RED}"
    DASH_COLOR="${RED}"
  fi

  local TERM_TITLE='\[\033]0;\u@\h:\w\007\]'  
  local PROMPT_START="[${USERNAME_COLOR}\u${RESET}][${GRAY}\h:${CYAN}\w${RESET}]"

  parse_git_prompt

  export PS1="${TERM_TITLE}${PROMPT_START}${GIT_PROMPT}${DASH_COLOR}\\$ ";

  unset GIT_PROMPT
}

PROMPT_COMMAND=git_prompt

