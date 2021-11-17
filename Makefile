.PHONY: lint

lint:
	swiftformat .
	swiftlint --fix
	swiftlint lint --strict
