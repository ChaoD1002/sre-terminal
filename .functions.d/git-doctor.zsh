# 📋 Git 协作自检函数
git-doctor() {
  echo "🔍 检查 Git 用户信息..."
  git config --global user.name  || echo "❗️ 尚未设置 user.name"
  git config --global user.email || echo "❗️ 尚未设置 user.email"

  echo "\n🔐 检查 SSH 配置..."
  if [[ -f ~/.ssh/id_ed25519.pub ]]; then
    echo "✅ 公钥存在：~/.ssh/id_ed25519.pub"
  else
    echo "❗️ 未生成 SSH key，运行 ssh-keygen 创建"
  fi

  echo "\n🌐 测试 GitHub SSH 连接..."
  ssh -T git@github.com || echo "❌ 无法通过 SSH 连接 GitHub"

  if git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "\n📦 当前 Git 仓库信息："
    git remote -v
  else
    echo "⚠️ 当前目录不是 Git 仓库"
  fi
}
