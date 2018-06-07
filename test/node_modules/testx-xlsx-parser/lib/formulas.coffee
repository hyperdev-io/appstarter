formulajs = require 'formulajs'
_ = require 'lodash'
moment = require 'moment'
ssf = require('xlsx').SSF
i18n = require './i18n'

today = -> moment().diff(moment([1900, 0, 1]), 'days') + 2

module.exports =
  _.extend formulajs,
    TEXT: (n, fmt) -> ssf.format i18n.translate(fmt), n
    TODAY: today
    NOW: today
    VLOOKUP: (key, matrix, index) ->
      matrix.reduce (memo, row) ->
        if row[0] == key then row[index-1] else memo
      ,'vlookup failed'
    CELL: ->
      console.warn 'Warning: "CELL" Excel function is not implemented!'
    INDIRECT: ->
      console.warn 'Warning: "INDIRECT" Excel function is not implemented!'
    LEFT: (target, num) ->
      target.toString().substring 0, num
