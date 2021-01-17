.PHONY: lint

lint:
	swiftformat .
	swiftlint autocorrect
	swiftlint lint --strict
