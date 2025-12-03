#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_CACHE_DIR="$ROOT_DIR/models"
DEFAULT_CONFIG_PATH="$ROOT_DIR/mineru.local.json"

MINERU_MODEL_CACHE_DIR="${MINERU_MODEL_CACHE_DIR:-$DEFAULT_CACHE_DIR}"
MINERU_TOOLS_CONFIG_JSON="${MINERU_TOOLS_CONFIG_JSON:-$DEFAULT_CONFIG_PATH}"
MINERU_MODEL_SOURCE="${MINERU_MODEL_SOURCE:-huggingface}"

export MINERU_MODEL_CACHE_DIR
export MINERU_TOOLS_CONFIG_JSON

mkdir -p "$MINERU_MODEL_CACHE_DIR"

echo "Downloading MinerU pipeline + VLM models to: $MINERU_MODEL_CACHE_DIR"
echo "Config file will be written to: $MINERU_TOOLS_CONFIG_JSON"

mineru-models-download -s "$MINERU_MODEL_SOURCE" -m all

echo "\nDownload finished. To use these models in the demo, run:"
echo "export MINERU_TOOLS_CONFIG_JSON=$MINERU_TOOLS_CONFIG_JSON"
echo "export MINERU_MODEL_SOURCE=local"
echo "python demo/demo.py"
