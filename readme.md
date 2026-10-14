# Blood Bank Natural Language SQL

This project models blood-bank donors, staff, locations, and donations. Users ask questions in plain English; the app sends the database schema and question to an OpenAI model, runs the generated read-only SQLite query, and asks the model to summarize the returned rows. It compares zero-shot prompting with single-domain prompting.

## Run locally

1. Create a virtual environment if needed: `python3 -m venv .venv`
2. Install the dependency: `make install`
3. Copy `.env.example` to `.env` if needed, then set `OPENAPI_KEY` to your own API key. Do not commit or share `.env`.
4. Run the experiment: `make run`

The Makefile uses `.venv/bin/python`, loads variables from `.env`, and runs the same eight questions with both strategies. Each run recreates `aidb.sqlite` from `setup.sql` and `setupData.sql`, then writes one `response_<strategy>_<timestamp>.json` file per strategy. Set `OPENAI_MODEL` in `.env` to override the default model (`gpt-4o`).
