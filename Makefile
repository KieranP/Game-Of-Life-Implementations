.PHONY: format

format:
	prettier --write --log-level warn '**/*.md'
