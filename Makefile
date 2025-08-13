.PHONY: install run clean help all

# ─────────────────────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────────────────────
PYTHON = $(shell which python)
APP_NAME = gs
VENV = .venv
PYTHONDONTWRITEBYTECODE = 

# ─────────────────────────────────────────────────────────────
# Dependency Management
# ─────────────────────────────────────────────────────────────
install:
	uv pip install -r requirements.txt

run:
	uv pip install -r requirements.txt --extra-index-url https://pypi.org/simple

requirements:
	uv pip freeze > requirements.txt

# ─────────────────────────────────────────────────────────────
# Development
# ─────────────────────────────────────────────────────────────

clean:
	find . -type d \( -name '__pycache__' -o -name '.pytest_cache' -o -name '*.egg-info' -o -name '.eggs' -o -name '*.dist-info' \) -print0 | xargs -0 rm -rf
	find . -type f \( -name "*.pyc" -o -name "*.pyo" -o -name "*.pyd" -o -name ".coverage" \) -delete
	rm -rf dist build htmlcov
	rm -rf data/security/*
	rm -rf data/collections/*
	rm -rf data/embeddings/*
	rm -rf data/meta/*
	rm -rf data/blobs/*
	rm -rf .cache/*

all: install run

help:
	@echo "Available targets:"
	@echo "  install             - Install dependencies with uv"
	@echo "  run                 - Install with optional dev index"
	@echo "  clean               - Remove cache & build artifacts"