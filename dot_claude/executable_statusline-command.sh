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

# Build output
OUTPUT="$MODEL | ctx ${CTX_REMAINING}%"

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
