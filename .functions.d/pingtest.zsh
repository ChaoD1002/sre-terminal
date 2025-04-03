pingtest() {
  for host in 8.8.8.8 github.com google.com; do
    echo "🌐 Ping $host:"
    ping -c 2 $host
    echo "------------------------"
  done
}

