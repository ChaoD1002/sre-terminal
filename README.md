# 🚀 SRE Terminal 配置框架

本项目是一个跨平台（WSL / macOS / Linux）支持的终端配置管理系统，具备模块化、高可维护性和一键部署能力，适用于 SRE / DevOps / 工程师日常工作场景。

---

## 🧩 项目结构说明

| 文件/目录 | 功能说明 |
|------------|-----------|
| `.zshrc` | 主配置文件，加载插件、主题、自定义模块 |
| `.aliases` | Shell 快捷命令集合 |
| `.functions` | 加载 `.functions.d/` 下的函数定义 |
| `.functions.d/` | 模块化函数管理目录 |
| `.p10k.zsh` | Powerlevel10k 主题配置 |
| `.zshrc.local.*` | 平台个性配置（macOS / WSL / 默认） |
| `install.sh` | 安装脚本，支持安装 / 重装 / 卸载 |
| `scripts/` | 自定义 CLI 工具目录（可选） |

---

## 📦 快速安装

克隆仓库并运行安装脚本：

```bash
git clone https://github.com/ChaoD1002/sre-terminal.git
cd sre-terminal
./install.sh            # 默认安装
./install.sh reinstall  # 清理后重新安装
./install.sh uninstall  # 卸载所有配置和软链
```

---

## 📚 install.sh 支持功能

| 模式 | 功能说明 |
|------|----------|
| `install`（默认） | 安装主题、插件、软链 dotfiles、生成 `.zshrc.local` |
| `reinstall` | 卸载后重新安装，避免冲突和冗余 |
| `uninstall` | 移除所有配置软链、插件、.zshrc.local、.oh-my-zsh |

### ✅ 自动化功能

- ✅ 自动识别平台（mac / WSL / Linux）
- ✅ 自动生成对应 `.zshrc.local` 模板
- ✅ macOS 环境下自动检测 Homebrew，安装推荐工具（`htop`、`unzip`、`z`）
- ✅ 安装 Powerlevel10k、常用插件（autosuggestions / syntax-highlighting）

---

## 🎨 Powerlevel10k 主题

本项目预设使用 `powerlevel10k/powerlevel10k` 主题，安装时会自动下载。首次使用时可运行配置向导：

```bash
p10k configure
```

---

## 🧠 平台识别函数

项目内置 `detect_platform()` 函数，可在任何地方判断系统环境：

```bash
if [[ $IS_WSL == true ]]; then echo "Running on WSL"; fi
```

你也可以执行：

```bash
platform_info  # 输出当前平台状态（CLI 工具）
```

---

## 🛠 alias / 函数

alias统一定义在 `.aliases` 中。
函数统一定义在 `.functions.d/*.zsh` 中。
支持模块化管理。

---

## ☁️ 推荐搭配

- iTerm2 + MesloLGS NF 字体（macOS）
- Windows Terminal + Ubuntu-WSL（Windows）
- GitHub + SSH + 自动化配置同步

---

## 📌 待办 / 拓展

- [ ] 丰富 `scripts/` 中 CLI 工具集
- [ ] 编写平台环境安装提示文档

---

## 📬 联系我

欢迎 issue、PR、交流反馈：  
📧 Email: eric97irl@gmail.com  
🌐 [LinkedIn](https://www.linkedin.com/in/dangchao)
