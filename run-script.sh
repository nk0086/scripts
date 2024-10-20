#!/bin/bash
# NAME: Script Runner
# DESCRIPTION: Run scripts from a directory using Rofi

# スクリプトのディレクトリを設定
SCRIPT_DIR="$HOME/script"

# 現在のスクリプト名を取得
CURRENT_SCRIPT=$(basename "$0")

# スクリプト一覧を取得し、メタデータと共にRofiで選択させる
selected_script=$(find "$SCRIPT_DIR" -type f -executable | 
    grep -v "$CURRENT_SCRIPT" | 
    grep -E '\.sh$' |
    while read -r script; do
        name=$(grep "^# NAME:" "$script" | cut -d':' -f2- | xargs)
        [ -z "$name" ] && name=$(basename "$script")
        # description=$(grep "^# DESCRIPTION:" "$script" | cut -d':' -f2- | xargs)
        # [ -z "$description" ] && description="No description available"
        echo -e "<b>$name</b>"
    done | 
    rofi -dmenu -i -p "Select script to run" -format 'i:s' -markup-rows)

# スクリプトが選択された場合
if [ -n "$selected_script" ]; then
    index=$(echo "$selected_script" | cut -d':' -f1)
    script_path=$(find "$SCRIPT_DIR" -type f -executable | grep -v "$CURRENT_SCRIPT" | sed -n "$((index+1))p")
    
    # スクリプトを実行
    "$script_path"
fi
