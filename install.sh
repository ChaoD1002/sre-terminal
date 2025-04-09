#!/bin/bash

set -e

MODE=${1:-install}
echo "🧭 当前模式：$MODE"
echo "🚀 开始安装 SRE 终端配置..."

# 👉 需要管理的 dotfiles 文件名（无需加点）
DOTFILES=(zshrc aliases functions p10k.zsh) # List of dotfiles to be managed (without the leading dot)

# 👉 平台判断
if [[ -f "./.functions.d/detect_platform.zsh" ]]; then
  # shellcheck disable=SC1091
  source "./.functions.d/detect_platform.zsh"
  detect_platform
  echo "✅ 平台标识符检测成功"
else
  echo "⚠️ 平台标识符文件不存在，将使用通用模板"
fi

# install
install_all() {
  echo "开始安装 SRE 终端配置"

  # 🔁 初始化子模块（仅当为空）
  if [ -f .gitmodules ]; then
    if [[ -d ssh-setup && -z "$(ls -A ssh-setup 2>/dev/null)" ]]; then
      echo "🔄 检测到 ssh-setup 子模块未初始化，正在拉取..."
      git submodule update --init --recursive
    else
      echo "✅ ssh-setup 子模块已存在，跳过初始化"
    fi
  fi

  # 安装基本工具 for WSL & Linux
  if [[ "$IS_WSL" == true || "$IS_LINUX" == true ]]; then
    sudo apt update
    PKGS=(git curl zsh vim locales unzip htop docker.io fzf zoxide tldr)
    for pkg in "${PKGS[@]}"; do
      if ! dpkg -s "$pkg" &>/dev/null; then
        echo "🔧 安装 $pkg..."
        sudo apt install -y "$pkg" || echo "⚠️ 无法安装 $pkg，跳过"
      else
        echo "✅ 已安装 $pkg"
      fi
    done

    echo "🌐 配置 locale..."
    sudo locale-gen en_US.UTF-8
    sudo update-locale LANG=en_US.UTF-8
    export LANG="en_US.UTF-8"
    export LANGUAGE="zh_CN:en_US"
    export LC_ALL="en_US.UTF-8"
  fi

  # 安装基本工具 for macOS
  if [[ "$IS_MAC" == true ]]; then
    echo "🍎 检测到 macOS，检查 Homebrew..."
    if ! command -v brew &>/dev/null; then
      echo "⚠️ 未安装 Homebrew，请前往 https://brew.sh 手动安装后重试。"
    else
      echo "✅ Homebrew 已安装，检查必要工具..."
      BREW_PKGS=(htop unzip fzf zoxide tldr)
      for pkg in "${BREW_PKGS[@]}"; do
        if ! brew list "$pkg" &>/dev/null; then
          echo "🔧 安装 $pkg..."
          brew install "$pkg"
        else
          echo "✅ 已安装 $pkg"
        fi
      done
    fi
  fi

  # 安装 oh-my-zsh
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🔧 安装 oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  # 安装 Powerlevel10k
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k

  # 安装插件
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting

  # 🔐 初始化 SSH 身份配置（通过子模块 ssh-setup）
  if [[ -d "$(pwd)/ssh-setup" ]]; then
    echo "🔐 检测到 ssh-setup 子模块，开始初始化 SSH 配置..."
    cd ssh-setup

    if [[ ! -f ~/.ssh/id_ed25519 ]]; then
      echo "📦 尚未检测到 SSH key，开始生成..."
      if [[ -f generate-key.sh ]]; then
        bash generate-key.sh || echo "⚠️ SSH key 生成失败，请手动运行 ssh-keygen"
      else
        echo "⚠️ 未找到 generate-key.sh 文件，请确保其存在于 ssh-setup 目录中"
      fi
    else
      echo "✅ SSH key 已存在，跳过生成"
    fi

    if [[ ! -f ~/.ssh/config && -f config.template ]]; then
      cp config.template ~/.ssh/config
      echo "✅ 已部署 config.template → ~/.ssh/config"
    fi

    cd - >/dev/null
  else
    echo "⚠️ 未找到 ssh-setup 子模块，跳过 SSH 初始化"
  fi

  # 链接配置文件
  echo "📎 正在链接配置文件到本地 home 目录..."
  for name in "${DOTFILES[@]}"; do
    src="$(pwd)/.$name"
    dest="$HOME/.$name"

    if [[ -e "$dest" && ! -L "$dest" ]]; then
      echo "📦 检测到 $dest 存在，备份为 $dest.bak"
      mv "$dest" "$dest.bak.$(date +%s)"
    fi

    ln -sf "$src" "$dest"
    echo "✅ 已链接: $dest → $src"
  done

  # 平台本地配置
  if [[ ! -f "$HOME/.zshrc.local" ]]; then
    echo "🛠 正在创建本地平台配置 (.zshrc.local)..."
    if [[ "$IS_WSL" == true ]]; then
      cp .zshrc.local.WSL ~/.zshrc.local
      echo "✅ 已应用 WSL 配置模板"
    elif [[ "$IS_MAC" == true ]]; then
      cp .zshrc.local.mac ~/.zshrc.local
      echo "✅ 已应用 macOS 配置模板"
    else
      cp .zshrc.local.example ~/.zshrc.local
      echo "✅ 已应用默认通用配置模板"
    fi
  else
    echo "✅ 已存在 .zshrc.local，跳过生成"
  fi

  # ✅ Git 使用 SSH 协议
  if [[ -f .functions.d/git-ssh.zsh ]]; then
    echo "🔍 正在检查 Git 是否使用 SSH 协议..."
    # shellcheck disable=SC1091
    source .functions.d/git-ssh.zsh && git-ssh
  fi

  # ✅ 环境自动加载逻辑（含 shell 检测 + 自动切换 + 提示）
  if [[ "$(ps -p $$ -o comm=)" != "zsh" ]]; then
    if [[ -t 1 ]]; then
      echo "✨ 当前 shell 为 $SHELL，自动切换至 zsh..."
      exec zsh
    else
      echo "✅ 安装完成！⚠️ 当前 shell 非 zsh，请手动执行："
      echo "👉 exec zsh && source ~/.zshrc"
    fi
  else
    if [[ -f "$HOME/.zshrc" ]]; then
      echo "🔄 当前已是 zsh，自动加载配置中..."
      # shellcheck disable=SC1091
      source "$HOME/.zshrc"
    fi
    echo "✅ 安装完成！已自动应用配置 🎉"
  fi
}

# uninstall
uninstall_all() {
  echo "🧹 开始卸载 dotfiles..."
  for file in "${DOTFILES[@]}"; do
    target="$HOME/.$file"
    if [[ -L "$target" ]]; then
      echo "❌ 取消软链：$target"
      rm "$target"
    elif [[ -e "$target" ]]; then
      echo "📦 本地存在非软链文件，备份为 $target.bak"
      mv "$target" "$target.bak.$(date +%s)"
    fi
  done

  echo "🧽 清理 oh-my-zsh / p10k / 插件..."
  rm -rf "$HOME/.oh-my-zsh"
  rm -rf "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  rm -rf "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  rm -rf "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

  echo "🗑 移除 ~/.zshrc.local"
  rm -f "$HOME/.zshrc.local"

  echo "✅ 卸载完成！建议手动执行：cd .. && rm -rf sre-terminal"
  exit 0
}

# 安装模式选择
case "$MODE" in
  uninstall)
    uninstall_all
    ;;
  reinstall)
    "$0" uninstall
    "$0" install
    ;;
  install)
    install_all
    ;;
  *)
    echo "❌ 参数错误，可用参数为：install | reinstall | uninstall"
    exit 1
    ;;
esac
