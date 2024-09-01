.PHONY: build
build:
	swift build

.PHONY: test
test:
	swift test

.PHONY: lint 
lint:
	act -j commitlint -P ubuntu-24.04=catthehacker/ubuntu:act-22.04 -P macos-latest=self-hosted

.PHONY: format
format:
	act -j format -P ubuntu-24.04=catthehacker/ubuntu:act-22.04 -P macos-latest=self-hosted