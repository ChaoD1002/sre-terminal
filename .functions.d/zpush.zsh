# 🚀 Git 提交并推送（支持参数或默认）
zpush() {
  cd ~/sre-terminal
  git add .
  git commit -m "${1:-update configs}"
  git push
  echo "🚀 配置已提交！"
}
