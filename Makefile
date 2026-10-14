PYTHON := .venv/bin/python

.PHONY: install run database

install:
	$(PYTHON) -m pip install -r requirements.txt

run:
	@test -f .env || (echo 'Missing .env. Copy .env.example to .env and add OPENAPI_KEY.' && exit 1)
	@set -a; . ./.env; set +a; $(PYTHON) db_bot.py

database:
	$(PYTHON) -c 'import db_bot; c = db_bot.create_database(); c.close(); print("Created aidb.sqlite")'
