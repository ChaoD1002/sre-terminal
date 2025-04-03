#!/bin/bash

echo "🩺 Dotfiles Doctor 正在诊断你的终端配置..."

# 要检查的软链文件
dotfiles=(.zshrc .aliases .functions .p10k.zsh)

echo ""
echo "🔗 检查软链接状态："
for file in "${dotfiles[@]}"; do
  target="$HOME/$file"
  if [ -L "$target" ]; then
    echo "✅ $file 是软链接 → $(readlink "$target")"
  elif [ -e "$target" ]; then
    echo "⚠️  $file 存在但不是软链接（建议备份并软链）"
  else
    echo "❌ $file 不存在（可能未安装）"
  fi
done

echo ""
echo "📁 检查 .functions.d 目录："
if [ -d ~/sre-terminal/.functions.d ]; then
  echo "✅ 已找到 ~/sre-terminal/.functions.d"
  count=$(ls ~/sre-terminal/.functions.d/*.zsh 2>/dev/null | wc -l)
  echo "📦 包含 $count 个函数模块"
else
  echo "❌ 未找到 ~/sre-terminal/.functions.d"
fi

echo ""
echo "🧪 测试 zsh 是否为默认 shell："
if [ "$SHELL" = "/bin/zsh" ]; then
  echo "✅ 当前 shell 为 zsh"
else
  echo "⚠️ 当前 shell 为 $SHELL，建议运行：chsh -s $(which zsh)"
fi

echo ""
echo "🔁 检查 scripts/ 是否在 PATH："
if echo "$PATH" | grep -q "$HOME/sre-terminal/scripts"; then
  echo "✅ scripts/ 目录已加入 PATH"
else
  echo "❌ scripts/ 目录未加入 PATH，建议在 .zshrc 中添加："
  echo 'export PATH="$HOME/sre-terminal/scripts:$PATH"'
fi

echo ""
echo "✅ Dotfiles 检查完成。"
