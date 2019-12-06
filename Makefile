build:
	mix compile

run:
	mix run -e "AdventOfCode2019.run"

format:
	mix format

make test:
	mix test

make test_focus:
	mix test --only focus:true
