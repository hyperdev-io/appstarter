pkg  = require './package.json'
xlsx = require './lib/xlsx'

module.exports =
  name: pkg.name
  version: pkg.version
  extensions: ['xlsx', 'xls']
  parse: xlsx.parse
  parseFile: xlsx.parse
