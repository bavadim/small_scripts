HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

bindkey '\e[3~' delete-char # del
bindkey ';5D' backward-word # ctrl+left 
bindkey ';5C' forward-word #ctrl+right

setopt hist_ignore_all_dups

autoload -U compinit promptinit
compinit
promptinit;

if [[ $EUID == 0 ]] 
then
PROMPT=$'%{\e[1;31m%}%n %{\e[1;34m%}%~ #%{\e[0m%} ' # user dir %
else
PROMPT=$'%{\e[1;32m%}%n %{\e[1;34m%}%~ %#%{\e[0m%} ' # root dir #
fi
RPROMPT=$'%{\e[1;34m%}%T%{\e[0m%}' # right prompt with time

alias ls='ls -G'
alias grep='grep --color=auto'
alias translate="~/scripts/small_scripts/translater.sh"

setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent noclobber
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash

autoload -U compinit
compinit

setopt menucomplete
zstyle ':completion:*' menu select=1 _complete _ignored _approximate

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

function advise()
{
  COWDIR=/opt/local/share/cowsay/cows/;
  COWNUM=$(($RANDOM%$(ls $COWDIR | wc -l)));
  COWFILE="$(ls $COWDIR | sed -n ''$COWNUM'p')";
  fortune | cowsay -f "$COWFILE";
}

advise
