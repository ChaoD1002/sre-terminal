# 🔄 Git 拉取并重载配置
zpull() {
  cd ~/sre-terminal
  git pull
  source ~/.zshrc
  echo "✅ 配置已同步并重载"
}
