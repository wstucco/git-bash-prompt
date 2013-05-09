export PATH="/opt/local/bin/:/opt/local/sbin/:/usr/local/bin:/usr/local/heroku/bin:$PATH"
export DYLD_LIBRARY_PATH=$HXCPP/bin/Mac

alias hibernateon='sudo pmset -a hibernatemode 1'
alias hibernateoff='sudo pmset -a hibernatemode 0'
alias mtr='mtr --curses'

alias rsyncmv="rsync -rahv --partial --progress --append --remove-sent-files"
alias rsynccp="rsync -rahv --partial --progress --append "

# load you bash scripts
for i in ~/.bashrc.d/*.bash; do
	source "$i";
done
