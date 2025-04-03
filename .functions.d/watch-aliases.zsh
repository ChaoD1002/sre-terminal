# 🌀 watch-aliases：监听 .aliases 文件变化并自动加载
watch-aliases() {
  echo "👀 正在监听 ~/.aliases 修改，保存时自动 reload。按 Ctrl+C 停止。"
  while inotifywait -e modify ~/.aliases >/dev/null 2>&1; do
    source ~/.aliases
    echo "✅ .aliases 已重新加载！"
  done
}
