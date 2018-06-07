yaml = require 'js-yaml'
fs   = require 'fs'
pkg  = require './package.json'

String::startsWith ?= (s) -> @[...s.length] is s

findKeywordLines = (lines) ->
  line: i + 1 for line, i in lines when line.startsWith '- '

module.exports =
  name: pkg.name
  version: pkg.version
  extensions: ['testx', 'yaml', 'yml']

  parseFile: (file) ->
    script = parse fs.readFileSync(file, 'utf8')
    script.source = file: file
    script

  parse: parse = (content) ->
    lines = findKeywordLines content.split '\n'
    doc = yaml.safeLoad content
    steps = for step, row in doc
      if typeof step is 'object'
        keyword = Object.keys(step)[0]
        args = step[keyword]
      else
        keyword = step
        args = []
      [all, kwd, _ignore, comment] = keyword.match /^(.*?)(\[(.*)\])?$/
      name: kwd?.trim() or keyword
      meta:
        'Full name': keyword
        Comment: comment?.trim() or ''
        Row: lines[row]?.line or row
      arguments: args

    steps: steps
