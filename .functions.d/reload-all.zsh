reload-all() {
  source ~/.aliases
  [[ -f ~/.functions ]] && source ~/.functions
  source ~/.zshrc
  echo "✅ 所有配置已重载"
}

