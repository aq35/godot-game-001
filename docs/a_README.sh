# !/bin/bash

mkdir -p /Users/kazumahosobe/godot-study/godot-game-001/docs/002

for i in $(seq 1 562); do
  success=false
  for ext in webp jpg png; do
    url="https://m9.imhentai.xxx/028/w134io87v5/${i}.${ext}"
    out="/Users/kazumahosobe/godot-study/godot-game-001/docs/002/${i}.${ext}"

    if curl -fs -o "$out" "$url"; then
      echo "✅ Success: ${i}.${ext}"
      success=true
      break
    fi
  done

  if [ "$success" = false ]; then
    echo "❌ Failed : ${i} (no format matched)"
  fi

done
