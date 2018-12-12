Custom Lambda Runtime for Perl
==============================

This is an experiment to get Perl support in Lambda

It consists of an implementation of the `bootstrap` script as [AWS documentation suggests](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html).

The implementation is not complete yet, though it does work to some extent :)

Prepare
=======

```
git clone git@github.com:pplu/perl-lambda-byor.git
carton install
carton exec $SHELL -l
export PATH=$PATH:$(pwd)/script
```

Try it
======

 - Create a directory for your Lambda project:

```
mkdir my-lambda-project
cd my-lambda-project
```

 - Create a config file named `lambda-perl.config` for your project
```
# The dependencies layer will be built with this name
lambda_name: test1
# Which runtime we will be using
perl_version: 5.28
# The region where we will operate the lambdas
region: us-east-1
```

 - Create a runtime layer

Although Perl is installed in the Lambda environment, since AWS bases the OS on CentOS, the Perl runtime is quite old (5.16, where at the time of this
writing Perl has gone through 5.18, 5.20, 5.22, 5.24, 5.26 and 5.28 releases). Added to that, the Perl installation is lacking the 'perl-core' yum
package, which makes that Perl very hard to deal with, since it's lacking almost all of the "core" modules that you would normally find installed
on a system. Because of that, we're going to use custom compiled, modern versions of Perl as the runtime.

```
mkdir layers
build-lambda-perl-runtime
```

will generate a `layers/perl_5.28.zip`. Create a layer in the Lambda console by uploading this zip file in the "Layers" section of the AWS Lambda Console. 
Take good note of it's ARN. If you don't want to compile Perl, you can find it in this git repo.

 - Create a cpanfile

Create a `cpanfile` with the dependencies for your Lambda function

```
requires 'Moo';
```
Generate the dependencies layer with:
```
build-lambda-deps-layer
```

this will generate another zip file that can be uploaded as another layer to AWS Lambda.

 - Write code. Start a file called `lambda_code`. Write a Perl subroutine:

```
sub my_function {
  return "I'm alive!"
}
```

Zip the `bootstrap` file with the `lambda_code` file: `zip layers/lambda.zip -j bootstrap/bootstrap lambda_code`

In the AWS Console: create a Lambda function with a custom runtime. Set the handler to the name of the file, followed by '.' 
and the name of the function to invoke: `lambda_code.my_function`. 

```
aws lambda --region xx-xxxx-x update-function-code --function-name LambdaFunctionName --zip-file fileb://./layers/lambda.zip
```

 - Invoke the function

You can invoke the function with the AWS CLI, or with Paws: `paws Lambda --region x Invoke FunctionName TheNameOfYourLambda Payload ''`

The bootstrap script will require the `lambda_code` file (or whatever the handler of the Lambda function tells it to), and will invoke the `my_function` sub in 
the hello file with the parsed JSON payload passed to the function as a hashref as it's first argument.

TODO
====

Automate the lambda.zip file creation

Ship the bootstrap script with the lambda runtime (instead of the final lambda.zip file)

Follow all the Processing Tasks in [custom runtimes section](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-custom.html)

Handle errors in compilation phase of the Lambda function

See if Dist::Zilla can build the zip for distributing to Lambda

Notes
=====

Finding out what you can or can't do inside the Lambda runtime can be exhausting if you do it directly inside Lambda. The `make explore-lambda-environment` target 
runs a shell inside a Docker container that resembles the Lambda runtime environment.

License
=======

This software is released under an Apache 2.0

Copyright
=========

(c) 2018 CAPSiDE

Author
======

Jose Luis Martinez Torres



