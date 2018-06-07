_ = require 'lodash'
i18n = require './i18n'
excelFormulaUtilities = require('./ExcelFormulaUtilities')

defaultOpts =
  tmplFunctionStart: 'formulas.{{token}}('
  tmplFunctionStop: '{{token}})'
  tmplOperandError: '{{token}}'
  tmplLogical: ''
  tmplOperandLogical: '{{token}}'
  tmplOperandNumber: '{{token}}'
  tmplOperandText: '"{{token}}"'
  tmplArgument: '{{token}}',
  tmplOperandOperatorInfix: '{{token}}'
  tmplFunctionStartArray: ''
  tmplFunctionStartArrayRow: '{'
  tmplFunctionStopArrayRow: '}'
  tmplFunctionStopArray: ''
  tmplSubexpressionStart: '('
  tmplSubexpressionStop: ')'
  customTokenRender: null
  prefix: ""
  postfix: ""

module.exports =
  format: (formula, sheetName) ->
    opts = _.extend defaultOpts,
      tmplOperandRange: 'resolveRef("' + sheetName + '", "{{token}}")'

    excelFormulaUtilities.formatFormula formula, opts
