Custom Lambda Runtime for Perl
==============================

This is an experiment to get Perl support in Lambda

It consists of an implementation of the `bootstrap` script as [AWS documentation suggests](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html).

The implementation is not complete yet, though it does work to some extent :)

Try it
======

 - Create a runtime layer

Although Perl is installed in the Lambda environment, since AWS bases the OS on CentOS, the Perl runtime is quite old (5.16, where at the time of this
writing Perl has gone through 5.18, 5.20, 5.22, 5.24, 5.26 and 5.28 releases). Added to that, the Perl installation is lacking the 'perl-core' yum
package, which makes that Perl very hard to deal with, since it's lacking almost all of the "core" modules that you would normally find installed
on a system. Because of that, we're going to use custom compiled, modern versions of Perl as the runtime.

```
make runtime-5.28
```

will generate a `runtimes/5.28/layer.zip`. Create a layer uploading this zip file in the Lambda console. Take good note of it's ARN. If you don't want
to compile Perl, you can find it in the git repo.

 - Create a Lambda function

Create a Lambda function with a custom runtime. Execute `make dist`. This will create a layers/lambda.zip file with the code to upload to Lambda. The
default `hello.handler` will work. You can upload the code to the Lambda function with:

```
aws lambda --region xx-xxxx-x update-function-code --function-name LambdaFunctionName --zip-file fileb://./layers/lambda.zip
```

 - Invoke the function

You can invoke the function with the AWS CLI, or with Paws: `paws Lambda --region x Invoke FunctionName TheNameOfYourLambda Payload ''`

The bootstrap script will require the `hello` file (or whatever the handler of the Lambda function tells it to), and will invoke the `handler` sub in 
the hello file with the parsed JSON payload passed to the function as a hashref.

Packaging binary dependencies
=============================

If you write a a cpanfile and invoke `make layer1-lib`, a zip file will be generated in the layers directory. It contains the packaged binary dependencies. Upload the Layer to Lambda, and add the layer to the appropiate Lambda function.

You will be able to use the dependencies from your handler.

TODO
====

Follow all the Processing Tasks in [custom runtimes section](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-custom.html)

Handle errors in compilation phase of the Lambda function

Find a way to package binary dependencies like `JSON::MaybeXS` or `Moo`, probably in a layer

See if Dist::Zilla can build the zip for distributing to Lambda

Notes
=====

Finding out what you can or can't do inside the Lambda runtime can be exhausting if you do it directly inside Lambda. The `make explore-lambda-environment` target 
runs a shell inside a Docker container that resembles the Lambda runtime environment.

The example consumes 23MB of RAM when invoked on Perl 5.28. This is nice because it leaves plenty of headroom for custom logic (the minumum mem for Lambda is 128MB).

License
=======

This software is released under an Apache 2.0

Copyright
=========

(c) 2018 CAPSiDE

Author
======

Jose Luis Martinez Torres



