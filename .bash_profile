export SDK_ROOT="~/Applications/eclipse/android_sdk_darwin_m3-rc20a"
export HXCPP=/usr/lib/haxe/lib/hxcpp/0,4/
export PATH="/opt/local/bin/:/opt/local/sbin/:/usr/local/bin:$SDK_ROOT/tools:/usr/local/mysql/bin:$HXCPP/bin/Mac:~/.vim/bin:$PATH"
export DYLD_LIBRARY_PATH=$HXCPP/bin/Mac

alias hibernateon='sudo pmset -a hibernatemode 1'
alias hibernateoff='sudo pmset -a hibernatemode 0'
alias mtr='mtr --curses'

alias rsyncmv="rsync -rahv --partial --progress --append --remove-sent-files"
alias rsynccp="rsync -rahv --partial --progress --append "


##
# Your previous /Users/maks/.bash_profile file was backed up as /Users/maks/.bash_profile.macports-saved_2009-10-11_at_19:32:28
##

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"


for i in ~/.bashrc.d/*.bash; do
	source "$i";
done
