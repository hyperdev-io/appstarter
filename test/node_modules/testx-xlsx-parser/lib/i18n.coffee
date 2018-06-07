locales =
  NL: [
    {from: /jj/gi, to: 'YY'}
  ]

module.exports =
  format: (val) ->
    val.z = translate val.z
    val

  translate: translate = (fmt) ->
    locale = global.xlsx.locale
    format = fmt
    if locale
      lcl = if typeof locale is 'string' then locales[locale] else locale
      for l in lcl
        format = format.replace?(l.from, l.to)
    format
