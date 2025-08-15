### Python Stuff

## Managing Dependencies

# Pipenv - https://pipenv.pypa.io/en/latest/

activate virtual environment: `pipenv shell`<br/>
ensure packages are available: `pipenv run python main.py`<br/>
install packages: `pipenv install flask black`<br/>

# Poetry - https://python-poetry.org/docs/

settings:<br/>

-   Creata .venv folder inside project: `poetry config virtualenvs.in-project true`

create new project:`poetry new poe-test`<br/>
activate virtual environment: `poetry shell`<br/>
add/remove dependencies: `poetry add/remove requests`<br/>
add dev dependencies: `poetry add black --group (-G) dev`<br/>

# uv - https://docs.astral.sh/uv/

list installed python version:`uv python list`
create new project:`uv init example`<br/>
activate virtual environment: `source .venv/bin/activate`<br/>
add/remove dependencies: `uv add/remove requests`<br/>
add dev dependencies: `uv add --dev black`<br/>

### Data Science
