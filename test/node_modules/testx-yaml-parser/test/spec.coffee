parser = require '..'
assert = require 'assert'
pkg  = require '../package.json'

expected =
  source:
    file: 'test/test.testx'
  steps: [
     name: 'go to',
     meta:
       Row: 1
       'Full name': 'go to [with comment]'
       Comment: 'with comment'
     arguments:
       'arg 11': 'val 1'
       'arg 12': 'val 2'
  ,
     name: 'set',
     meta:
       Row: 4
       'Full name': 'set'
       Comment: ''
     arguments:
       'arg 21': 'val 111'
       'arg 22': 'multi\n- line\nstring'
  ,
     name: 'set'
     meta:
       Row: 10
       'Full name': 'set'
       Comment: ''
     arguments:
       'arg 3': 'ooooo'
  ,
     name: 'no params'
     meta:
       Row: 12
       'Full name': 'no params'
       Comment: ''
     arguments: []
  ]

script = parser.parseFile 'test/test.testx'
console.dir script,
  depth: 5
assert.deepEqual script, expected
