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

export LANG="en_US.UTF-8"
export LANGUAGE="zh_CN:en_US"
export LC_ALL="en_US.UTF-8"
export EDITOR=vim
[[ ! -f ~.p10k.zsh ]] || source ~./p10k.zsh
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.functions ]] && source ~/.functions
detect_platform
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# 🚀 自动将 sre-terminal/scripts 加入 PATH
if [ -d "$HOME/sre-terminal/scripts" ]; then
  PATH="$HOME/sre-terminal/scripts:$PATH"
fi
