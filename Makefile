runtime-5.28:
	docker build -t lambda-perl-runtime:5.28 runtimes/5.28/
	docker run --name get_runtime lambda-perl-runtime:5.28 echo ''
	docker cp get_runtime:/layer.zip runtimes/5.28/
	docker rm get_runtime

runtime-5.16:
	docker build -t lambda-perl-runtime:5.16 runtimes/5.16/
	docker run --name get_runtime lambda-perl-runtime:5.16 echo ''
	docker cp get_runtime:/layer.zip runtimes/5.16/
	docker rm get_runtime


layer1-lib:
	docker build -t lambda-perl-layer1:test .
	docker run --name get_zip lambda-perl-layer1:test echo ''
	docker cp get_zip:/layer.zip layers/lib-layer.zip
	docker rm get_zip


upload-runtimes:
	aws lambda --region us-west-2 publish-layer-version --layer-name Perl516 --zip-file fileb://runtimes/5.16/layer.zip
	aws lambda --region us-west-2 publish-layer-version --layer-name Perl528 --zip-file fileb://runtimes/5.28/layer.zip

dist:
	mkdir -p layers
	zip layers/lambda.zip -j bootstrap/bootstrap hello

upload-code:
	aws lambda --region us-west-2 update-function-code --function-name Perl528Lambda --zip-file fileb://./layers/lambda.zip

explore-lambda-environment:
	docker run --rm -ti --entrypoint /bin/bash lambci/lambda:latest
