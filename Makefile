.PHONY: lint

lint:
	swiftformat .
	swiftlint autocorrect
