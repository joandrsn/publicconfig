env=~/.ssh/agent.env

agent_load_env() 
{ 
  test -f "$env" && . "$env" >| /dev/null ; 
}

agent_start() 
{
  (umask 077; ssh-agent >| "$env")
  . "$env" >| /dev/null ; 
}

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
  agent_start
fi

unset env

if [[ "$OSTYPE" == "darwin"* ]]; then
  osx=true
else
  osx=false
fi

if [ -x /usr/bin/dircolors ]; then
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

if [[ $- == *i* ]]; then
  PS1="\[\033[38;5;9m\]\u\[$(tput sgr0)\]\[\033[38;5;208m\]@\[$(tput sgr0)\]\[\033[38;5;11m\]\h\[$(tput sgr0)\]\[\033[38;5;10m\]:\[$(tput sgr0)\]\[\033[38;5;33m\]\w\[$(tput sgr0)\]\[\033[38;5;99m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"
else
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

case "$TERM" in
  xterm*|rxvt*)
    if [ "$osx" = false ]; then
      PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    fi
   ;;
esac

if [ "$osx" = false ]; then 
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

unset osx
export PS1
export VISUAL=vim
export EDITOR="$VISUAL"
if [[ "$TERM" == "xterm-termite" ]]; then
  export TERM=xterm-256color
fi
