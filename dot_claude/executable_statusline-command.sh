#!/bin/bash
input=$(cat)

# Extract context window info
CTX_REMAINING=$(echo "$input" | jq -r '.context_window.remaining_percentage // 0' | cut -d'.' -f1)

# Extract usage quota (Max subscription limits)
# Try different possible field names since this is a newer feature
QUOTA_USED=$(echo "$input" | jq -r '.usage_quota.used_percentage // .quota.used_percentage // .rate_limit.used_percentage // empty' 2>/dev/null)
QUOTA_PERIOD=$(echo "$input" | jq -r '.usage_quota.period // .quota.period // .rate_limit.period // empty' 2>/dev/null)

# Extract model (shorten common names)
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
case "$MODEL" in
    "Claude Opus 4.5") MODEL="Opus" ;;
    "Claude Sonnet 4") MODEL="Sonnet" ;;
    "Claude Haiku 3.5") MODEL="Haiku" ;;
esac

# Extract current working directory from JSON input
CWD=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')

# Get git branch (skip optional locks for safety)
GIT_BRANCH=""
if [ -d "$CWD/.git" ]; then
    GIT_BRANCH=$(cd "$CWD" && git --no-optional-locks branch --show-current 2>/dev/null)
fi

# Build output with pwd and git branch
OUTPUT="$MODEL"

# Add directory (show basename only to keep it short)
if [ -n "$CWD" ]; then
    DIR_NAME=$(basename "$CWD")
    OUTPUT="$OUTPUT | $DIR_NAME"
fi

# Add git branch if available
if [ -n "$GIT_BRANCH" ]; then
    OUTPUT="$OUTPUT | $GIT_BRANCH"
fi

# Add context info
OUTPUT="$OUTPUT | ctx ${CTX_REMAINING}%"

# Add quota if available
if [ -n "$QUOTA_USED" ] && [ "$QUOTA_USED" != "null" ]; then
    QUOTA_INT=$(echo "$QUOTA_USED" | cut -d'.' -f1)
    if [ -n "$QUOTA_PERIOD" ] && [ "$QUOTA_PERIOD" != "null" ]; then
        OUTPUT="$OUTPUT | ${QUOTA_PERIOD}: ${QUOTA_INT}%"
    else
        OUTPUT="$OUTPUT | quota ${QUOTA_INT}%"
    fi
fi

echo "$OUTPUT"
