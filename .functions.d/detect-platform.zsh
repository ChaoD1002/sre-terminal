detect_platform() {
  if grep -qi microsoft /proc/version 2>/dev/null; then
    export IS_WSL=true
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    export IS_MAC=true
  else
    export IS_LINUX=true
  fi
}
