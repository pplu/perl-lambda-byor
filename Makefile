runtime-5.28:
	docker build -t lambda-perl-runtime:5.28 runtimes/5.28/
	docker run --name get_runtime lambda-perl-runtime:5.28 echo ''
	docker cp get_runtime:/layer.zip runtimes/5.28/
	docker rm get_runtime

dist:
	mkdir -p layers
	zip layers/lambda.zip -j bootstrap/bootstrap hello

explore-lambda-environment:
	docker run --rm -ti --entrypoint /bin/bash lambci/lambda:latest
