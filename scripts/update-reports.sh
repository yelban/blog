#!/bin/bash
# 掃描 reports/raw/*.md，更新 reports/reports.json
# 排序：按檔名降序（最新在前）

RAW_DIR="reports/raw"
OUTPUT="reports/reports.json"

# 取得所有 .md 檔名（不含路徑和副檔名），降序排列
files=$(ls -1 "$RAW_DIR"/*.md 2>/dev/null | xargs -n1 basename | sed 's/\.md$//' | sort -r)

# 轉成 JSON 陣列
json='{\n  "reports": ['
first=true
for f in $files; do
  if [ "$first" = true ]; then
    json+="\n    \"$f\""
    first=false
  else
    json+=",\n    \"$f\""
  fi
done
json+='\n  ]\n}'

echo -e "$json" > "$OUTPUT"
echo "Updated $OUTPUT with $(echo "$files" | wc -w | tr -d ' ') reports"
