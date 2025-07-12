#!/bin/bash

conda init bash
source activate py_3.10
pip install -r /app/src/wyoming_piper/install_requirements.txt
pip install /app/ctranslate2-dist/*.whl
