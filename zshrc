## Search path for cd command
#cdpath=(.. ~ ~/src ~/zsh)

## Default Permission
## New File: 644, New Directory: 755
umask 022

## Alias
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias git='nocorrect git'
alias make='nocorrect make'
alias grep=egrep
alias ls='ls -F --color=yes'
alias ll='ls -l'
alias la='ls -a'
alias clean='rm *~'
alias gcc='gcc -Wall'
alias g++='g++ -Wall'
alias diff='diff -u'
alias screen='screen -t main'
alias vi=vim
#alias make='make -j 4'
alias makelog='make -j 1 |& tee make.log'
alias sshsip1='ssh -l a0600760 sip1.mu.renesas.com'
alias sshtama='ssh 10.30.95.31'
alias sshkita='ssh klsl003'
alias sshmu='ssh mlsl111'
alias sshgpu='ssh mcll001'
alias t='tmux'
alias tig='tig --all'

## Alias for displaying only directory and symbolic link
alias lsd='ls -ld *(-/DN)'

## Alias for displaying only "." files
alias lsa='ls -ld .*'

## Global Aliasing
alias -g M='|more'
alias -g H='|head'
alias -g T='|tail'
alias -g G='|grep'
alias -g GI='|grep -i'

## Seaching autoload zsh functions
fpath=(/svhome/takiyo/local/hp/share/zsh/site-functions ~/dotfiles/zsh/completion $fpath)

## Remove dupulicate path
typeset -U path cdpath fpath manpath

## Prompt
PROMPT='ZSH[%m]%# '
RPROMPT=' %~'

export LANG=ja_JP.UTF-8

## Proxy
#export HTTP_PROXY=proxy01.mu.renesas.com:8080
#export http_proxy=${HTTP_PROXY}
#export HTTPS_PROXY=${HTTP_PROXY}
#export https_proxy=${HTTP_PROXY}
#export FTP_PROXY=${HTTP_PROXY}
#export ftp_proxy=${HTTP_PROXY}

## Manual Path
#export MANPATH=($X11HOME/man /usr/man /usr/lang/man /usr/local/man /opt/local/man)

## EDITOR
export EDITOR=vim

## Other Environment Variable
HISTSIZE=2000
SAVEHIST=100000
HISTFILE=~/.zhistory
DIRSTACKSIZE=100

##
## zsh option
##
## History
setopt histnostore        # Not register history command
setopt histignoredups     # Not register duplicate command
setopt histreduceblanks   # Remove useless spaces
setopt incappendhistory   # Registered from shells which are launched.
setopt sharehistory       # Share history between several shells.
## File Glob
setopt extendedglob       # Use Extention File Glob
setopt globdots           # Match file which begins "."
#setopt numericglobsort    # Display file from numerical sorting
## Input/Output
setopt noclobber          # Display Error when overwriting file.
setopt correct            # Spell correction when command inputting
setopt correctall         # Spell correction with arguments
setopt ignore_eof         # Don't logout with C-d
## Changing Directory
#setopt cdable_vars        # Interpreted as directory in absolute path
setopt auto_cd            # chdir only directory path
setopt auto_pushd         # pushed to directory stack
setopt pushdminus
setopt pushdtohome
## Job Control
setopt autoresume         # Job reexecution only firct character of job name.
setopt longlistjobs       # Using long format in job list
setopt notify             # Display background job status immediately
setopt recexact
## Completion
setopt autolist           # List automatically when several candidates are existed.
setopt listpacked         # List compactly
setopt listtypes          # Display file type

## Loading zsh module
zmodload -a zsh/stat stat          # stat command
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile

## Emacs like keybind
bindkey -e

## Enable Auto completion
autoload -U compinit
compinit -u

## Coloring
autoload -U colors
colors

## GNUPLOT
export GNUTERM=x11

## Emacs
[[ $EMACS = t ]] && unsetopt zle
[[ $TERM = "eterm-color" ]] && TERM=xterm-color

if [ $?LD_LIBRARY_PATH ]; then
  export LD_LIBRARY_PATH=/eda04/SIPDA/local/lib:/eda04/SIPDA/local/lib64:${LD_LIBRARY_PATH}
else
  export LD_LIBRARY_PATH=/eda04/SIPDA/local/lib:/eda04/SIPDA/local/lib64
fi

export PATH=/eda04/SIPDA/local/bin:${PATH}

# CUDA
if [ -d /svtool/cuda/41/cuda ]; then
  export CUDA_INSTALL_DIR=/svtool/cuda/41/cuda
  export PATH=${CUDA_INSTALL_DIR}/bin:$PATH
  export LD_LIBRARY_PATH=${CUDA_INSTALL_DIR}/lib64:${CUDA_INSTALL_DIR}/lib:${CUDA_INSTALL_DIR}/libnvvp:${CUDA_INSTALL_DIR}/../sdk/C/lib:$LD_LIBRARY_PATH
fi

## Localな環境設定ファイルがあれば、それをロードする
if [ -f $HOME/.zshrc.local ]; then
  source $HOME/.zshrc.local
fi

unset SSH_ASKPASS
