# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Basic ZSH config with Powerlevel10k and plugins
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  z
  sudo
  docker
  colored-man-pages
  extract
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Aliases
alias cls="clear"
alias reload="source ~/.zshrc"
alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"
alias gd="git diff"
alias dps="docker ps"
alias dcu="docker-compose up -d"
alias dcd="docker-compose down"
alias dimg="docker images"
alias drm="docker rm $(docker ps -aq)"
alias drmi="docker rmi $(docker images -q)"
alias srelog="tail -f /var/log/syslog | grep --color sre"
alias errlog="journalctl -p err -n 50"
alias myip="curl ifconfig.me"
alias ports="ss -tulnp"
alias cpu="lscpu"
alias mem="free -h"
alias dfh="df -h"
alias cdp="cd ~/projects"
alias cdg="cd ~/git"
alias venv="python3 -m venv venv && source venv/bin/activate"

export LANG="en_US.UTF-8"
export LANGUAGE="zh_CN:en_US"
export LC_ALL="en_US.UTF-8"
export EDITOR=vim

[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.functions ]] && source ~/.functions
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# 🚀 自动将 sre-terminal/scripts 加入 PATH
if [ -d "$HOME/sre-terminal/scripts" ]; then
  PATH="$HOME/sre-terminal/scripts:$PATH"
fi
