# colors
BLUE="\[\033[0;34m\]"
LIGHT_BLUE="\[\033[1;34m\]"
RED="\[\033[0;31m\]"
LIGHT_RED="\[\033[1;31m\]"
ORANGE="\[\033[38;5;202m\]"
GREEN="\[\033[0;32m\]"
LIGHT_GREEN="\[\033[1;32m\]"
YELLOW="\[\033[1;33m\]"
DARK_YELLOW="\[\033[0;33m\]"
PURPLE="\[\033[0;35m\]"
LIGHT_PURPLE="\[\033[1;35m\]"
CYAN="\[\033[0;36m\]"
LIGHT_CYAN="\[\033[1;36m\]"
GRAY="\[\033[1;30m\]"
LIGHT_GRAY="\[\033[0;37m\]"
WHITE="\[\033[1;37m\]"
RESET="\[\033[0m\]"

function parse_git_prompt {

  local GIT_IS_WORKING_TREE="$(git rev-parse --is-inside-work-tree 2>/dev/null)";  
  if [ "true" = "${GIT_IS_WORKING_TREE}" ]; then

    local GIT_BRANCH=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/');
    local GIT_STATUS=$(git status --porcelain 2> /dev/null);
    local GIT_UNCOMMITTED=$(echo "$GIT_STATUS" | grep "^M" | wc -l);
    local GIT_UNSTAGED=$(echo "$GIT_STATUS" | grep "^ M" | wc -l);
    local GIT_UNTRACKED=$(echo "$GIT_STATUS" | grep "^??" | wc -l);
    local GIT_REMOTE=$(git remote | grep "^origin")
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
      local GIT_NEED_PULL=$(git rev-list HEAD...origin/master --count);
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

  local TERM_TITLE='\[\033]0;\u@\h:\w\007\]'  
  local PROMPT_START="[${YELLOW}\u${RESET}][${GRAY}\h:${CYAN}\w${RESET}]"

  parse_git_prompt

  export PS1="${TERM_TITLE}${PROMPT_START}${GIT_PROMPT}\\$ ";

  unset GIT_PROMPT
}

PROMPT_COMMAND=git_prompt

