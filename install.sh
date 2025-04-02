#!/bin/bash

echo "🚀 开始安装 SRE 终端配置..."

# 安装 oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🔧 安装 oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 安装 Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# 安装插件
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 链接配置文件
ln -sf "$(pwd)/.zshrc" ~/.zshrc

echo "✅ 安装完成，请运行：source ~/.zshrc"
