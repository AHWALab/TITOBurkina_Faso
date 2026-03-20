#!/bin/bash
# Downloads and extracts Burkina Faso EF5 model configuration files.
# basic.zip     → basic/
# crestParem.zip → parameters/
# kwParam.zip   → parameters/
# Existing files are always replaced.

set -e

BASE_URL="https://github.com/AHWALab/Burkina_Faso_EF5_configuration/raw/main/model_config"
TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "Downloading Burkina Faso EF5 configuration files..."

# ── basic.zip → basic/ ────────────────────────────────────────────────────────
echo "  Downloading basic.zip..."
curl -fL "$BASE_URL/basic.zip" -o "$TMP_DIR/basic.zip"
echo "  Extracting to basic/..."
mkdir -p basic
unzip -o "$TMP_DIR/basic.zip" -d basic/

# ── crestParem.zip → parameters/ ────────────────────────────────────────────
echo "  Downloading crestParem.zip..."
curl -fL "$BASE_URL/crestParem.zip" -o "$TMP_DIR/crestParem.zip"
echo "  Extracting to parameters/..."
mkdir -p parameters
unzip -o "$TMP_DIR/crestParem.zip" -d parameters/

# ── kwParam.zip → parameters/ ─────────────────────────────────────────────────
echo "  Downloading kwParam.zip..."
curl -fL "$BASE_URL/kwParam.zip" -o "$TMP_DIR/kwParam.zip"
echo "  Extracting to parameters/..."
unzip -o "$TMP_DIR/kwParam.zip" -d parameters/

echo "Burkina Faso EF5 configuration files downloaded and extracted successfully."
