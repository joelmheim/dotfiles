export EDITOR="vim"

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
export ZSH_THEME="jreese"

# Set to this to use case-sensitive completion
export CASE_SENSITIVE="true"

# Uncomment following line if you want to disable autosetting terminal title.
#export DISABLE_AUTO_TITLE="true"

export DISABLE_UPDATE_PROMPT=true

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(aws bundler chucknorris command-not-found common-aliases compleat debian dircycle dirpersist docker encode64 gem gpg-agent gitfast git-extras github heroku jruby lein lol node npm nvm pip postgres python rake rails ruby rvm scala sbt ssh-agent sublime systemd vi-mode virtualenv tmux tmuxinator thefuck code)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
bindkey -v
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# marks concept based on post by Jeroen Janssens:
# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html

export MARKPATH=$HOME/.marks

mark_go() {
    cd -P "${PROJECTS_ROOT:=$HOME/work}/$1/git" 2>/dev/null || cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark $1"
}
#alias c=mark_go

echo_markpath() {
    if [[ -h "$MARKPATH/$1" ]]; then
        printf "$(readlink $MARKPATH/$1)"
    elif [[ -d "${PROJECTS_ROOT:=$HOME/work}/$1/git" ]]; then
        printf "${PROJECTS_ROOT:=$HOME/work}/$1/git"
    else
        printf $1
    fi
}

mark() { 
    if (( $# == 0 )); then
        marks
    else
        mkdir -p $MARKPATH; ln -s "$(pwd)" "$MARKPATH/$1"
    fi
}
alias m=mark

unmark() { 
    rm -i "$MARKPATH/$1" 
}

marks() {
    for link in $MARKPATH/*(@); do
        local markname="$fg[cyan]${link:t}$reset_color"
        local markpath="$fg[blue]$(readlink $link)$reset_color"
        printf "%s\t" $markname
        printf "-> %s \t\n" $markpath
    done
}

_mark_go_cpl() {
    reply=($MARKPATH/*(@:t))
    reply+=(${PROJECTS_ROOT:=$HOME/work}/*(/:t))
}

_unmark_cpl() {
    reply=($MARKPATH/*(@:t))
}

# use ctrl-g to replace inline mark name with full path:
# ls mymark<Ctrl-g>
# becomes:
# ls /Path/to/my/mark
_mark_expansion() {
    autoload -U modify-current-argument
    modify-current-argument '$(echo_markpath $ARG)'
}
zle -N _mark_expansion
bindkey "^g" _mark_expansion

compctl -K _mark_go_cpl mark_go
compctl -K _unmark_cpl unmark

export JAVA_HOME="/usr/lib/jvm/default-java"
export MAVEN_HOME="/home/joe/devtools/apache-maven-2.2.1"
export AKKA_HOME="/home/joe/devtools/akka-core-1.2"
export ANDROID_HOME="/opt/android-sdk-linux"
export GRADLE_HOME="/home/joe/devtools/gradle-3.0"
export GOPATH="/home/joe/code/go"
export CONNECTIQROOT="/home/joe/devtools/connectiq"
export ORACLE_HOME="prog/oracle/11.2.0"

export PATH="${PATH}:/home/joe/bin:/home/joe/code/scripts/:/usr/local/go/bin:${JAVA_HOME}/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:/home/joe/devtools/play-2.0:/home/joe/devtools/sbt-0.12.0/bin:${GRADLE_HOME}/bin:${CONNECTIQROOT}/bin"

export LD_LIBRARY_PATH="${ORACLE_HOME}/lib:${LD_LIBRARY_PATH}"
export TNS_ADMIN=${ORACLE_HOME}

### User aliases ###
alias ports='nc -v -w 1 localhost -z 1-10000 2>&1 | grep succeeded'

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

source ~/.bin/tmuxinator.zsh

rvm use latest
nvm use stable
