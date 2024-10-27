#!/bin/bash

# 引数がない場合、ユーザーに入力を求める
if [ -z "$1" ]; then
    read -p "Enter issue title: " ISSUE_TITLE
else
    ISSUE_TITLE="$1"
fi

if [ -z "$2" ]; then
    read -p "Enter branch name: " CUSTOM_BRANCH_NAME
else
    CUSTOM_BRANCH_NAME="$2"
fi

# Issueを作成し、番号を取得
ISSUE_URL=$(gh issue create --title "$ISSUE_TITLE" --body "Issue created via script" --assignee @me)
ISSUE_NUMBER=$(echo $ISSUE_URL | grep -oE '[0-9]+$')

if [ -z "$ISSUE_NUMBER" ]; then
    echo "Failed to create issue"
    exit 1
fi

# ブランチ名を生成
if [[ $CUSTOM_BRANCH_NAME == *"/"* ]]; then
    # プレフィックスがある場合（feat/など）
    BRANCH_PREFIX=$(echo $CUSTOM_BRANCH_NAME | cut -d'/' -f1)
    BRANCH_SUFFIX=$(echo $CUSTOM_BRANCH_NAME | cut -d'/' -f2-)
    BRANCH_NAME="${BRANCH_PREFIX}/issue-${ISSUE_NUMBER}-${BRANCH_SUFFIX}"
else
    # プレフィックスがない場合
    BRANCH_NAME="issue-${ISSUE_NUMBER}-${CUSTOM_BRANCH_NAME}"
fi

# Issueに対応するブランチを作成し、チェックアウト
gh issue develop $ISSUE_NUMBER --name $BRANCH_NAME --checkout

echo "Issue created: $ISSUE_URL"
echo "Branch created and checked out: $BRANCH_NAME"
