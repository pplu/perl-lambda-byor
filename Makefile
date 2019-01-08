dist:
	cpanm -n -l dzil-local Dist::Zilla
	PATH=$(PATH):dzil-local/bin PERL5LIB=dzil-local/lib/perl5 dzil authordeps --missing | cpanm -n -l dzil-local/
	PATH=$(PATH):dzil-local/bin PERL5LIB=dzil-local/lib/perl5 dzil build

upload-runtimes:
	aws lambda --region us-west-2 publish-layer-version --layer-name Perl516 --zip-file fileb://runtimes/5.16/layer.zip
	aws lambda --region us-west-2 publish-layer-version --layer-name Perl528 --zip-file fileb://runtimes/5.28/layer.zip

upload-code:
	aws lambda --region us-west-2 update-function-code --function-name Perl528Lambda --zip-file fileb://./layers/lambda.zip

explore-lambda-environment:
	docker run --rm -ti --entrypoint /bin/bash lambci/lambda:latest
