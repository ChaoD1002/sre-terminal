zpush() {
  cd ~/sre-terminal
  git stash push -m "🔒 zpush auto stash"
  git pull --rebase
  git stash pop
  git add .
  git commit -m "${1:-update configs}"
  git push
  echo "✅ zpush 完成"
}# 🚀 Git 提交并推送（支持参数或默认）
zpush() {
  cd ~/sre-terminal
  git add .
  git commit -m "${1:-update configs}"
  git push
  echo "🚀 配置已提交！"
}
