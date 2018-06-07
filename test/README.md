Your new [testx](http://testx.io/testx) project
====================

## Prerequisites
Install [protractor](http://www.protractortest.org/) (may need to run as root/administrator):

	npm install -g protractor

Update the local chrome and firefox selenium drivers using webdriver-manager (comes with protractor):

	webdriver-manager update

## Install dependencies
Install all dependencies. In the project directory do:

	npm install

## Run
From within the project directory:

	protractor conf.coffee

or

	npm test

### Run with [Docker](https://www.docker.com/)
This method is recommended when executing your tests as part of a continuous integration pipeline. When using Docker you do not need protractor installed on your machine (or the CI server), but of course you need Docker.

  	npm run test-docker

## Next steps
The sample testx script is in **scripts/my-first-script.testx**. Change it to do something more useful and run it again.

[Protractor](http://www.protractortest.org/) configuration (your starting point) is in **conf.coffee**.

Check the [testx documentation](http://testx.io/testx) documentation to find out where to go from here.

## Editor support
Use [the atom testx language plugin](https://atom.io/packages/language-testx) for syntax highlights and auto-completion. If you do not use [Atom](https://atom.io) you are on your own. But seriously, you should.
