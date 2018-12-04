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
default `hello.handler` will work.

The bootstrap script will require the `hello` file (or whatever the handler tells it to), and will invoke the `handler` sub in the hello file with
the payload passed to the function invocation.

You can invoke the function with the AWS CLI, or with Paws: `paws Lambda --region x Invoke FunctionName TheNameOfYourLambda Payload ''`

TODO
====

Follow all the Processing Tasks in [custom runtimes section](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-custom.html)

Handle errors in compilation phase of the Lambda function

Parse JSON from the request that AWS sends in before passing it to the function

Find a way to package binary dependencies like `JSON::MaybeXS` or `Moo`, probably in a layer

Find a way to package a modern non-system Perl in a layer

See if Dist::Zilla can build the zip for distributing to Lambda

Notes
=====

Finding out what you can or can't do inside the Lambda runtime can be exhausting if you do it directly inside Lambda. The `make explore-lambda-environment` target 
runs a shell inside a Docker container that resembles the Lambda runtime environment.

The example consumes 14MB of RAM when invoked. This is nice because it leaves plenty of headroom for custom logic (the minumum mem for Lambda is 128MB).

The environment and Perl
========================

I've tried to install Perl modules in the Lambda environment with `cpanm` (downloading and executing it). Unfortunately I get an `ExtUtils::Manifest not found` error
which means that perl-core isn't installed in the runtime enviornment [see](https://github.com/miyagawa/cpanminus/issues/493). The runtime environment is Amazon Linux, which is based on CentOS.

The bootstrap script is trying to be agnostic of the Perl that is below, only using core modules, but

License
=======

This software is released under an Apache 2.0

Copyright
=========

(c) 2018 CAPSiDE

Author
======

Jose Luis Martinez Torres



