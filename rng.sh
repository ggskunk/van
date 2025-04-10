#!/bin/bash

GPU_ID=$1
LOG_FILE="gpu${GPU_ID}_random_ranges.log"
FOUND_FILE="output_gpu${GPU_ID}.txt"
PREFIX="19vkiEajfh"
RANGE_SIZE=38

LOWER_BOUND=0x1C0000000000000000
UPPER_BOUND=0x1FFFFFFFFFFFFFFFFF

echo "🎯 GPU $GPU_ID başlatılıyor (range: $LOWER_BOUND – $UPPER_BOUND)..."

while true; do
    if [ -f "$FOUND_FILE" ]; then
        echo "✨ GPU $GPU_ID buldu! Durduruluyor..."
        break
    fi

    # Rastgele bir başlangıç değeri üret
    random_start=$(python3 -c "import random; print(hex(random.randint($LOWER_BOUND, $UPPER_BOUND - (1 << $RANGE_SIZE)))[2:].upper())")

    # Zaten denenmişse atla
    if grep -q "$random_start" "$LOG_FILE" 2>/dev/null; then
        echo "⏩ GPU $GPU_ID – zaten denenmiş: $random_start"
        continue
    fi

    echo "$random_start" >> "$LOG_FILE"
    echo "🚀 GPU $GPU_ID – tarama: $random_start (2^$RANGE_SIZE)"

    ./vanitysearch -gpuId $GPU_ID -o "$FOUND_FILE" -start "$random_start" -range $RANGE_SIZE "$PREFIX" 

    echo "✅ GPU $GPU_ID tamamladı: $random_start"
    echo "----------------------------"
    sleep 0.2
done
