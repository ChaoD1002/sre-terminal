# 🛠 checkport：查看某端口是否被监听
checkport() {
  if [ -z "$1" ]; then
    echo "用法: checkport 端口号"
    return 1
  fi
  sudo lsof -i :$1
}
