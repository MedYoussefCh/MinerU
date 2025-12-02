# Local demo setup (pipeline + VLLM)

This guide keeps every model artifact inside the repository so you can run `demo/demo.py` fully offline. Follow the checklist
from start to finish on a fresh machine.

## 0) Prerequisites
- Python 3.10–3.13 (3.10 works with the published vLLM wheels).
- CUDA 12.x drivers (e.g., 12.8) with an NVIDIA GPU such as L40S.
- Models already downloaded into `./models` plus the generated `mineru.local.json` in the repo root (from
  `scripts/prepare_local_models.sh` or your manual download).

## 1) Create a virtual environment and install MinerU with VLLM extras

```bash
python3 -m venv .venv
source .venv/bin/activate
uv pip install "mineru[core,vllm]"  # or: pip install "mineru[core,vllm]"
```

## 2) Point MinerU to the repo-local config and models

```bash
export MINERU_TOOLS_CONFIG_JSON="$(pwd)/mineru.local.json"
export MINERU_MODEL_SOURCE=local
```

If you relocated the models, edit `mineru.local.json` to update `models-dir.pipeline` and `models-dir.vlm` so they match your
paths.

## 3) Quick test with the default pipeline backend

```bash
python demo/demo.py -p /path/to/your.pdf -o ./output
```

- Results (Markdown, JSON, annotated PDFs) will appear in `./output/<pdf_name>/`.
- Use `--start_page_id` / `--end_page_id` to limit pages if needed.

## 4) Run with the VLLM backend

### Option A — local engine (no HTTP server)
```bash
python demo/demo.py -p /path/to/your.pdf -o ./output --backend vlm-vllm-engine
```

### One-minute VLM-only smoke test
If you only want to validate the VLM model (and skip the pipeline models):

```bash
# 1) ensure your VLM model is in ./models/MinerU2.5-2509-1.2B (or update mineru.local.json)
export MINERU_TOOLS_CONFIG_JSON="$(pwd)/mineru.local.json"
export MINERU_MODEL_SOURCE=local

# 2) run the VLM engine directly
python demo/demo.py -p /path/to/your.pdf -o ./output --backend vlm-vllm-engine
```

- This path never loads the pipeline models; it only exercises the VLM inference stack.
- If you prefer an HTTP flow instead, see Option B below and start the vLLM server first.

### Option B — HTTP client talking to your vLLM server
1. Start the server on your preferred port (e.g., 8000):
   ```bash
   mineru-openai-server --engine vllm --model ./models/MinerU2.5-2509-1.2B --port 8000
   ```
2. Run the demo against it:
   ```bash
   python demo/demo.py -p /path/to/your.pdf -o ./output --backend vlm-http-client --server_url http://127.0.0.1:8000
   ```

> Tip: If your server is exposed over TLS, replace `http://` with `https://` in `--server_url`.

## 5) What to expect / troubleshoot
- The demo prints the output folder path upon completion; inspect the Markdown and `_middle.json` files there.
- If vLLM fails to load on GPU, verify your CUDA driver matches the installed wheel (CUDA 12.x) and that `nvidia-smi` lists your
  L40S.
- If MinerU reports missing models, ensure `mineru.local.json` points to where you installed the assets and that
  `MINERU_MODEL_SOURCE=local` is set.
