# 🚀 zpush.v2：更智能的 Git 提交 + 推送工具
zpush() {
  cd ~/sre-terminal || return

  # 检查 Git 仓库状态
  if [ -n "$(git status --porcelain)" ]; then
    echo "🔄 检测到未提交改动，准备暂存并合并远程..."
    git stash push -m "🔒 zpush auto-stash before pull"
  fi

  # 拉取远程并 rebase（更整洁）
  echo "📥 正在 pull 并 rebase..."
  if ! git pull --rebase origin main; then
    echo "❌ rebase 失败，请手动解决冲突后再执行 zpush"
    return 1
  fi

  # 恢复 stash（如果之前 stash 过）
  if git stash list | grep -q "zpush auto-stash"; then
    echo "📦 正在恢复暂存内容..."
    git stash pop
  fi

  # 添加更改
  git add .

  # 使用第一个参数作为 commit message，若无则默认
  local msg="${1:-update configs}"
  git commit -m "$msg"
  git push

  echo "✅ zpush 成功：$msg"
}
