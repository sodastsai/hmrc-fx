.PHONY: lint

lint:
	swift run -c release swiftformat .
	# swift run -c release swiftlint --fix
	# swift run -c release swiftlint lint --strict
