import:
	@cp ~/Downloads/epgp.csv ./data/$(name).csv

run:
	@cd src; iex -S mix

dep:
	@cd src; mix deps.get

build:
	@cd src: mix compile

update:
	