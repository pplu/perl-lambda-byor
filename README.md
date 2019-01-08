Custom Lambda Runtime for Perl
==============================

This is an experiment to get Perl support in Lambda.

It consists of an implementation of the `bootstrap` script as [AWS documentation suggests](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html).

The implementation is not complete yet, though it does work to some extent :)

Install AWS::Lambda::Toolkit
============================

```
cpanm AWS::Lambda::Toolkit
```

(Note: you might need to install the `cpanminus` system package to get access to the cpanm command).

This installs the utilities that help us bootstrap the Lambda environment.

Note2: While the distribution is not uploaded to CPAN, you can install this way:

```
git clone git@github.com:pplu/perl-lambda-byor.git
make dist
cpanm AWS-Lambda-Toolkit-0.01.tar.gz
```

Create your Lambda function
===========================

 - Create a directory for your Lambda project:

```
mkdir my-lambda-project
cd my-lambda-project
```

 - Initialize the directory as a lambda project:
Create a config file named `lambda-perl.config` for your project
```
init-lambda-perl
```
 - Create a runtime layer

Although Perl is installed in the Lambda environment, since AWS bases the OS on CentOS, the Perl runtime is quite old (5.16, where at the time of this
writing Perl has gone through 5.18, 5.20, 5.22, 5.24, 5.26 and 5.28 releases). Added to that, the Perl installation is lacking the 'perl-core' yum
package, which makes that Perl very hard to deal with, since it's lacking almost all of the "core" modules that you would normally find installed
on a system. Because of that, we're going to use custom compiled, modern versions of Perl as the runtime.

```
build-lambda-perl-runtime 5.28
```

will generate a `layers/perl_5.28.zip`. This can be uploaded to Lambda as a layer with `install-lambda-perl-runtime`.

 - Create a cpanfile with the dependencies of your project

```
requires 'Moo';
```

Generate the dependencies layer with:

```
build-lambda-deps-layer
```

this will generate another zip file in the layers directory that can be uploaded with `install-lambda-deps`

 - Write code. Start a file called `lambda`. Write a Perl subroutine:

```
sub main {
  return "I'm alive!"
}
```

Create a zip with with the `build-lambda-function`. This creates a zip with the code in the layers directory

Configure the `lambda-perl.config` file:

Add the config keys:
 
```
handler: lambda.main
role: arn:aws:iam::XXXXX:role/XXXXX
```

handler is formed by the name of the file that contains the lambda function (`lambda` in this example), followed
by `.` and the subroutine to invoke in that file.

Invoke `install-lambda-function` to up create the lambda function in AWS.

 - Invoke the function

You can invoke the function with the AWS CLI, or with Paws: `paws Lambda --region x Invoke FunctionName TheNameOfYourLambda Payload ''`

The bootstrap script will require the `lambda` file (or whatever the handler of the Lambda function tells it to), and will invoke the `main` sub in 
the lambda file with the parsed JSON payload passed to the function as a hashref as it's first argument.

TODO
====

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



