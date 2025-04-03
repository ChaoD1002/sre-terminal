#!/bin/bash

echo "🚀 开始安装 SRE 终端配置..."

# 安装基本工具
sudo apt update
PKGS=(git curl zsh vim locales unzip htop docker.io z)
for pkg in "${PKGS[@]}"; do
  if ! dpkg -s "$pkg" &>/dev/null; then
    echo "🔧 安装 $pkg..."
    sudo apt install -y "$pkg"
  else
    echo "✅ 已安装 $pkg"
  fi
done

# locale 设置
sudo locale-gen en_US.UTF-8
sudo update-locale LANG=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 安装 oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🔧 安装 oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 安装 Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git   ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# 安装插件
git clone https://github.com/zsh-users/zsh-autosuggestions   ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git   ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 链接配置文件
echo "正在链接配置文件到本地home目录..."
link_dotfile() {
  local name="$1"
  local src="$(pwd)/.$name"
  local dest="$HOME/.$name"

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "📦 检测到 $dest 存在（非软链接），备份为 $dest.bak"
    mv "$dest" "$dest.bak.$(date +%s)"
  fi

  ln -sf "$src" "$dest"
  echo "✅ 已链接: $dest → $src"
}
for file in zshrc aliases functions p10k.zsh; do
  link_dotfile "$file"
done

echo "✅ 安装完成！请运行：source ~/.zshrc 或重启终端"
