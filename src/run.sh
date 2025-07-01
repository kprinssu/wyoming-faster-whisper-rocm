#!/usr/bin/env bash

conda init bash
source activate py_3.10
exec python3 -m wyoming_whisper --device cuda --model distil-small.en --uri 'tcp://0.0.0.0:10300' --data-dir /data --download-dir /data "$@"
