#!/usr/bin/env bash
set -euo pipefail

# 1. Install gdown if missing
pip install --user gdown

# 2. Download the ZIP directly from Google Drive
gdown --id 179TXJBfMMbP9FDC_hsdpGLQPmN6iB4vY --output train.zip

# # 3. Create directories
mkdir -p data/repobench/repos
mkdir -p data/repobench/extracted

# 4. Unzip into the temporary folder
# Check if train.zip exists and is not empty
if [ -s train.zip ]; then
    # Attempt to unzip the file
    if unzip -q -t train.zip > /dev/null 2>&1; then
        unzip -q train.zip -d data/repobench/extracted
        echo "Successfully unzipped train.zip"
    else
        echo "Error: train.zip is not a valid zip file. Please check the file and try again."
        exit 1
    fi
else
    echo "Error: train.zip is empty or not found in /home/nuc11extreme-012/Downloads/repo/RepoHyper. Please check the file and try again."
    exit 1
fi

# 5. Move all unzipped contents into the dataset root
mv data/repobench/extracted/data/train/* data/repobench/

# Clean up
rm -rf data/repobench/extracted

# Run the repo-downloading script
python3 -m scripts.data.download_repos \
    --dataset data/repobench \
    --output data/repobench/repos \
    --num-processes 8
