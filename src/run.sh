#!/bin/bash

conda init bash
source activate py_3.10
export KMP_DUPLICATE_LIB_OK=TRUE
WHISPER_MODEL="${WHISPER_MODEL:-distil-small.en}"
exec python3 -m wyoming_whisper --device cuda --model $WHISPER_MODEL --uri 'tcp://0.0.0.0:10300' --data-dir /data --download-dir /data "$@"
