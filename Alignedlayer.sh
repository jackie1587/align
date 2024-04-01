#!/bin/bash

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi

# 检查并安装 Node.js、npm 和 PM2
function check_and_install_dependencies() {
    if ! command -v node >/dev/null 2>&1; then
        echo "Node.js 未安装，正在安装..."
        curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
        sudo apt-get install -y nodejs
        echo "Node.js 安装完成。"
    else
        echo "Node.js 已安装。"
    fi

    if ! command -v npm >/dev/null 2>&1; then
        echo "npm 未安装，正在安装..."
        sudo apt-get install -y npm
        echo "npm 安装完成。"
    else
        echo "npm 已安装。"
    fi

    if ! command -v pm2 >/dev/null 2>&1; then
        echo "PM2 未安装，正在安装..."
        npm install -g pm2
        echo "PM2 安装完成。"
    else
        echo "PM2 已安装。"
    fi
}

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi

check_and_install_dependencies

# 脚本保存路径
SCRIPT_PATH="$HOME/Alignedlayer.sh"

# 自动设置快捷键的功能
function check_and_set_alias() {
    local alias_name="Ali"
    local shell_rc="$HOME/.bashrc"

    # 对于Zsh用户，使用.zshrc
    if [ -n "$ZSH_VERSION" ]; then
        shell_rc="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        shell_rc="$HOME/.bashrc"
    fi

    # 检查快捷键是否已经设置
    if ! grep -q "$alias_name" "$shell_rc"; then
        echo "设置快捷键 '$alias_name' 到 $shell_rc"
        echo "alias $alias_name='bash $SCRIPT_PATH'" >> "$shell_rc"
        # 添加提醒用户激活快捷键的信息
        echo "快捷键 '$alias_name' 已设置。请运行 'source $shell_rc' 来激活快捷键，或重新打开终端。"
    else
        # 如果快捷键已经设置，提供一个提示信息
        echo "快捷键 '$alias_name' 已经设置在 $shell_rc。"
        echo "如果快捷键不起作用，请尝试运行 'source $shell_rc' 或重新打开终端。"
    fi
}

# 节点安装功能
function install_node() {

#!/bin/bash

# 创建节点名称
read -p "输入节点名称,别搞奇形怪状的符号，纯英文就行: " MONIKER

# 更新和安装依赖
sudo apt update && sudo apt upgrade -y
sudo apt install curl git jq lz4 build-essential -y

# 安装 Go
rm -rf $HOME/go
sudo rm -rf /usr/local/go
curl -L https://go.dev/dl/go1.22.0.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile
source $HOME/.bash_profile
go version

# 下载并安装 Aligned Layer 二进制文件
cd $HOME
wget https://github.com/yetanotherco/aligned_layer_tendermint/releases/download/v0.1.0/alignedlayerd
chmod +x alignedlayerd
sudo mv alignedlayerd /usr/local/bin/

# 配置节点和创世文件
alignedlayerd init $MONIKER --chain-id alignedlayer

# 从指定的 URL 安装创世文件
wget -O $HOME/.alignedlayer/config/genesis.json https://snap.nodex.one/alignedlayer-testnet/genesis.json
wget -O $HOME/.alignedlayer/config/addrbook.json https://raw.githubusercontent.com/a3165458/Alignedlayer/main/addrbook.json

# 设置种子节点和最小 gas 价格
SEEDS="d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:24210"
PERSISTENT_PEERS="125b4260951111e1d7111c071011aec6d24f2087@148.251.82.6:26656,74af08a0cf53d78e3a071c944b355cae95c1c1ef@37.60.243.112:26656,797d6ad9a64abd63b785ce81c75ee7397a590786@213.199.62.101:26656,33a338aef4f9e887571fe7e2baf9dd5baa43e9a2@47.236.180.181:26656,0468a823477832e2dd17c94834ac639ac1929860@213.199.39.156:26656"
MINIMUM_GAS_PRICES="0.0001stake"


sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.alignedlayer/config/config.toml
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PERSISTENT_PEERS\"|" $HOME/.alignedlayer/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"$MINIMUM_GAS_PRICES\"|" $HOME/.alignedlayer/config/app.toml

# 使用 PM2 启动 alignedlayerd
    pm2 start /usr/local/bin/alignedlayerd --name alignedlayer-node -- start --watch
    pm2 save
    pm2 startup
    
    echo "Alignedlayer 节点安装和启动完成。"
}

# 下载快照

wget $(curl -s https://services.staketab.org/backend/aligned-testnet/ | jq -r .snap_link)
tar -xf $(curl -s https://services.staketab.org/backend/aligned-testnet/ | jq -r .snap_filename) -C $HOME/.alignedlayer/data/


echo "====================== 安装完成 ==========================="
    
}

# 创建钱包
function add_wallet() {
    alignedlayerd keys add wallet
   
}

# 创建验证者
function add_validator() {
cd $HOME && wget -O setup_validator.sh https://raw.githubusercontent.com/yetanotherco/aligned_layer_tendermint/main/setup_validator.sh && chmod +x setup_validator.sh && bash setup_validator.sh wallet 1050000stake



}

# 导入钱包
function import_wallet() {
    alignedlayerd keys add wallet --recover


    
}

# 查询余额
function check_balances() {
    read -p "请输入钱包地址: " wallet_address
    alignedlayerd query bank balances "$wallet_address" 

    
}

# 查看节点同步状态
function check_sync_status() {
    alignedlayerd status | jq .sync_info

    
}

# 查看Alignedlayer 服务状态
function check_service_status() {
    systemctl status alignedlayerd

    
}

# 节点日志查询
function view_logs() {
    sudo journalctl -f -u alignedlayerd.service 

    
}

function uninstall_node() {
    echo "你确定要卸载 Alignedlayer 节点程序吗？这将会删除所有相关的数据。[Y/N]"
    read -r -p "请确认: " response

    case "$response" in
        [yY][eE][sS]|[yY])
            echo "开始卸载节点程序..."
            pm2 stop alignedlayer-node && pm2 delete alignedlayer-node
            rm -rf $HOME/.alignedlayerd && rm -rf $HOME/aligned_layer_tendermint && sudo rm -rf $(which alignedlayerd)
            echo "Alignedlayer 节点程序卸载完成。"
            ;;
        *)
            echo "取消卸载操作。"
            ;;
    esac
}


# 主菜单
function main_menu() {
    while true; do
    clear
    echo "脚本以及教程由推特用户大赌哥 @y95277777 编写，免费开源，请勿相信收费"
    echo "================================================================"
    echo "节点社区 Telegram 群组:https://t.me/niuwuriji"
    echo "节点社区 Telegram 频道:https://t.me/niuwuriji"
    echo "退出脚本，请按键盘ctrl c退出即可"
    echo "请选择要执行的操作:"
    echo "1. 安装节点"
    echo "2. 创建钱包"
    echo "3. 导入钱包"
    echo "4. 创建验证者"
    echo "5. 查看钱包地址余额"
    echo "6. 查看节点同步状态"
    echo "7. 查看当前服务状态"
    echo "8. 运行日志查询"
    echo "9. 卸载脚本"
    echo "10. 设置快捷键"  
    read -p "请输入选项（1-11）: " OPTION

    case $OPTION in
    1) install_node ;;
    2) add_wallet ;;
    3) import_wallet ;;
    4) add_validator ;;
    5) check_balances ;;
    6) check_sync_status ;;
    7) check_service_status ;;
    8) view_logs ;;
    9) uninstall_node ;;
    10) check_and_set_alias ;;  
    *) echo "无效选项。" ;;
    esac
    echo "按任意键返回主菜单..."
    read -n 1
done
}

# 显示主菜单
main_menu
