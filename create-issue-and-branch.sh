#!/bin/bash

# issueのタイトルを引数から取得
ISSUE_TITLE="$1"

if [ -z "$ISSUE_TITLE" ]; then
    echo "Usage: $0 <issue title>"
    exit 1
fi

# issueを作成し、番号を取得
ISSUE_NUMBER=$(gh issue create --title "$ISSUE_TITLE" --body "Issue created via script" --assignee @me --json number --jq .number)

if [ -z "$ISSUE_NUMBER" ]; then
    echo "Failed to create issue"
    exit 1
fi

# ブランチ名を生成（例：issue-123-short-title）
BRANCH_NAME="issue-${ISSUE_NUMBER}-$(echo $ISSUE_TITLE | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | cut -c1-20)"

# issueに対応するブランチを作成し、チェックアウト
gh issue develop $ISSUE_NUMBER --name $BRANCH_NAME --checkout
