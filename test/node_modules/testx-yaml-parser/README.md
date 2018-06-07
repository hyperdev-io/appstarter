# Usage

In your test file (*mytests/test.yaml*):

```YAML
- go to:
    url: /

# fill in the search box and press search
- set:
    searchBox: sample pdf files

- set:
    searchBtn: ''

# check the content of the pdf file
- check in pdf:
    link: pdfLink
    expect1: D e n t i s t s
    expect2: P o l i t i c i a n s
```

In your spec file (CoffeeScript):

``` CoffeeScript
testx = require 'testx'
yamlParser = require 'testx-yaml-parser'

describe 'Some page', ->
  it 'should work in a certain way', ->
    testx.runScript yamlParser.parseFile 'mytests/test.yaml'
```

Alternatively you can pass the YAML as a literal string. In CoffeeScript:

``` CoffeeScript
testx = require 'testx'
yamlParser = require 'testx-yaml-parser'

describe 'Some page', ->
  it 'should work in a certain way', ->
    testx.runScript yamlParser.parse """

- go to:
    url: /

# fill in the search box and press search
- set:
    searchBox: sample pdf files

- set:
    searchBtn: ''

# check the content of the pdf file
- check in pdf:
    link: pdfLink
    expect1: D e n t i s t s
    expect2: P o l i t i c i a n s    
"""
```
