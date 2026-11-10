# Setup guide

Install `uv`

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Restart terminal

Download dependencies

```powershell
uv sync
```

Start JupyterLab

```powershell
uv run jupyter lab
```

## Docker

Install and start Docker Desktop, then run:

```powershell
docker compose up --build
```

With GPU:

```powershell
docker compose -f compose.yaml -f compose.gpu.yaml up --build
```

Open `http://localhost:8888` using the token printed in the terminal.
