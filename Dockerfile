# syntax=docker/dockerfile:1
FROM ghcr.io/astral-sh/uv:0.13.7 AS uv
FROM python:3.12-slim-bookworm

COPY --from=uv /uv /uvx /usr/local/bin/

# PyTorch and scikit-learn use the OpenMP runtime.
RUN apt-get update \
    && apt-get install -y --no-install-recommends libgomp1 \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_PYTHON_DOWNLOADS=never \
    UV_LINK_MODE=copy \
    UV_PROJECT_ENVIRONMENT=/opt/venv \
    PATH="/opt/venv/bin:$PATH" \
    HF_HOME=/home/app/.cache/huggingface

WORKDIR /workspace
COPY pyproject.toml uv.lock .python-version README.md ./

# Keep the Linux environment outside the bind-mounted Windows workspace.
# Reuse downloaded wheels across builds without storing the cache in the image.
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --group dev --no-install-project

RUN useradd --create-home --uid 1000 app \
    && mkdir -p /home/app/.cache/huggingface \
    && chown -R app:app /workspace /home/app
COPY --chown=app:app . .
USER app

EXPOSE 8888
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--ServerApp.root_dir=/workspace"]
