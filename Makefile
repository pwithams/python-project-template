MODULE_PATHS = yourmodule1 yourmodule2
TEST_PATHS = tests
PRETTIER_PATTERN = \"**/*.{yml,md,json}\"

all:
	make format
	make check
	make style
	make type
	make test

format:
	black $(MODULE_PATHS) $(TEST_PATHS)
	isort $(MODULE_PATHS) $(TEST_PATHS) --profile black
	# requires prettier via npm install
	# if using npm, Makefile can optionally be migrated to package.json scripts
	@echo "----> Skipped: prettier -w $(PRETTIER_PATTERN) --ignore-path=.gitignore"

format-check:
	black $(MODULE_PATHS) $(TEST_PATHS) --check
	isort $(MODULE_PATHS) $(TEST_PATHS) --profile black --check
	prettier -w $(PRETTIER_PATTERN) --ignore-path=.gitignore --check

check:
	pylint -E $(MODULE_PATHS) $(TEST_PATHS)

style:
	pylint $(MODULE_PATHS) $(TEST_PATHS) --fail-under 9

type:
	mypy $(MODULE_PATHS)

test:
	coverage run -m unittest discover $(TEST_PATHS)
	coverage report

test-unit:
	coverage run -m unittest discover $(TEST_PATHS)/unit
	coverage report

test-integration:
	coverage run -m unittest discover $(TEST_PATHS)/integration
	coverage report
