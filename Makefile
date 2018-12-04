dist:
	mkdir -p layers
	zip layers/lambda.zip -j bootstrap hello

explore-lambda-environment:
	docker run --rm -ti --entrypoint /bin/bash lambci/lambda:latest
