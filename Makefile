.PHONY: build
build:
	docker build -t screenwork/pageres-cli .

# make run ARGS=[ https://www.screenwork.de/ --crop 800x600 1024x768 1600x900 1920x1080 ]
.PHONY: run
run:
	docker run --rm -v ${PWD}:/data screenwork/pageres-cli $(ARGS)