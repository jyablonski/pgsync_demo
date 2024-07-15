FROM python:3.11-slim AS base

ENV POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_NO_INTERACTION=1

FROM base AS python-deps

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends git gcc && \
    rm -rf /var/lib/apt/lists/*

COPY pyproject.toml poetry.lock ./

RUN pip install --upgrade pip poetry && \
    poetry install --no-root

FROM base AS runtime

COPY --from=python-deps ./.venv ./.venv
ENV PATH="/.venv/bin:$PATH"

RUN useradd --create-home appuser
WORKDIR /home/appuser
USER appuser

COPY event_producer/ ./event_producer

CMD ["python3", "-m", "event_producer.main"]
