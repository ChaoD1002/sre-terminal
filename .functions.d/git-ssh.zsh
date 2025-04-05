# 将 Git 远程地址从 HTTPS 切换为 SSH
git-ssh() {
  # 检查是否在 Git 仓库中
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "⚠️ 当前目录不是 Git 仓库"
    return 1
  fi

  # 获取远程地址
  local remote_url
  remote_url=$(git remote get-url origin 2>/dev/null)

  if [[ "$remote_url" == https://github.com/* ]]; then
    local repo_path="${remote_url#https://github.com/}"
    local ssh_url="git@github.com:${repo_path}"

    echo "🔁 正在将 Git 远程地址切换为 SSH：$ssh_url"
    git remote set-url origin "$ssh_url"
    echo "✅ 已切换为 SSH"
    git remote -v
  else
    echo "✅ Git 已使用 SSH 或非 GitHub 源：$remote_url"
  fi
}
