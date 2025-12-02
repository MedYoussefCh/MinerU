# Local demo setup (pipeline + VLLM)

This guide keeps every model artifact inside the repository so you can run `demo/demo.py` fully offline.

## 1) Install MinerU with VLLM extras

```bash
uv pip install "mineru[core,vllm]"
```

## 2) Download all models into `./models`

Use the helper script which pins the cache directory to the repo and writes a config file alongside it:

```bash
scripts/prepare_local_models.sh
# Optional overrides:
#   MINERU_MODEL_SOURCE=modelscope   # or huggingface (default)
#   MINERU_MODEL_CACHE_DIR=/custom/path
#   MINERU_TOOLS_CONFIG_JSON=/custom/path/mineru.local.json
```

This downloads both the pipeline bundle and the `MinerU2.5-2509-1.2B` VLM locally and generates `mineru.local.json` pointing to them.

## 3) Run the demo with local models

Use the generated config and force local loading:

```bash
export MINERU_TOOLS_CONFIG_JSON="$(pwd)/mineru.local.json"
export MINERU_MODEL_SOURCE=local
python demo/demo.py
```

### Running against a VLLM server (optional)

If you prefer the VLM HTTP client, start a VLLM server on your desired port (e.g. 8000) using the downloaded model path, then point the demo to it:

```bash
mineru-openai-server --engine vllm --model ./models/MinerU2.5-2509-1.2B --port 8000
export MINERU_TOOLS_CONFIG_JSON="$(pwd)/mineru.local.json"
export MINERU_MODEL_SOURCE=local
python demo/demo.py --backend vlm-http-client --server_url http://127.0.0.1:8000
```

This keeps all downloads and configuration within the repository directory for easy testing.
