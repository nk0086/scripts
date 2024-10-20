#!/bin/bash
# NAME: Obsidian Memo
# DESCRIPTION: Add a memo to Obsidian with optional additional notes
# AUTHOR: nk
# VERSION: 1.0

current_time=$(date +"%H:%M")

# rofiからメモの入力を受け取る
memo=$(rofi -dmenu -p "Enter additional notes (optional)")

# メモが空の場合は終了
if [ -z "$memo" ]; then
    exit 0
fi

# URLエンコード
encoded_memo=$(echo "$memo" | sed 's/ /%20/g')

xdg-open "obsidian://adv-uri?vault=Obsidian-Memo&daily=true&mode=append&data=-%20$current_time%20$encoded_memo"
