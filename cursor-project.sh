#!/bin/bash
# NAME: Project Selector
# DESCRIPTION: Select and open a project using Rofi and Cursor editor
# AUTHOR: nk
# VERSION: 1.0

# 検索対象のディレクトリリスト
DIRECTORIES=(
    "$HOME/Project"
    "$HOME/.config/nvim/lua/user"
    "$HOME/script"
)

select_project() {
    local options=""

    # Project ディレクトリの直下のサブディレクトリを追加
    while read -r subdir; do
        relative_path="${subdir#$HOME/Project/}"
        options+="Project: $relative_path"$'\n'
    done < <(find "$HOME/Project" -maxdepth 1 -mindepth 1 -type d)

    # user と script ディレクトリを追加
    options+="Neovim: user"$'\n'
    options+="Script: script"$'\n'

    selected=$(echo -e "$options" | sort | \
               rofi -dmenu -i -p "Select Project")

    if [ -z "$selected" ]; then
        exit 0
    fi

    # プレフィックスと相対パスを分離
    prefix="${selected%%:*}"
    relative_path="${selected#*: }"

    # 選択されたディレクトリの完全パスを構築
    case $prefix in
        "Project")
            selected_project="$HOME/Project/$relative_path"
            ;;
        "Neovim")
            selected_project="$HOME/.config/nvim/lua/user"
            ;;
        "Script")
            selected_project="$HOME/script"
            ;;
    esac

    echo "$selected_project"
}

# プロジェクト選択の開始
selected_project=$(select_project)

# プロジェクトが選択された場合
if [ -n "$selected_project" ]; then
    # プロジェクトディレクトリに移動
    cd "$selected_project" || exit
    
    # ここでプロジェクトを開くコマンドを実行
    # 例: Cursorで開く場合
    cursor .
    
    # または、ターミナルで開く場合
    # alacritty -e bash -c "cd $selected_project && exec bash"
fi
