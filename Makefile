.PHONY: build
build:
	mix compile

.PHONY: run
run:
	mix run -e "AdventOfCode2019.run"

.PHONY: format
format:
	mix format

.PHONY: test
test:
	mix test

.PHONY: test_focus
test_focus:
	iex -S mix test --only focus:true
