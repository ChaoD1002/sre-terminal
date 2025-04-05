# 将Git远程地址从http改为SSH
git-ssh(){
	local remote_url
	remote_url=$(git remote get-url origin 2>/dev/null)

	if [[ -z "$remote_url" ]]; then
		echo "当前目录不是Git仓库"
		return 1
	fi

	if [[ "$remote_url" == https://github.com/* ]]; then
		local repo_path="${remote_url#https://github.com/}"
		local ssh_url="git@github.com:${repo_path}"

		echo "正在将远程地址切换为SSH"
		echo "$ssh_url"

		git remote set-url origin "$ssh_url"

		echo "已切换为SSH"
		git remote -v
	else
		echo "已使用SSH无需切换"
	fi
}
