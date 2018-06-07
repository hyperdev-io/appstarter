testx-xlsx-parser
=====

Simple XLSX file parser for use with the testx library. Converts a test script in a XLSX sheet to testx test script (JSON).

## API
This library exposes only one method **parse** that takes 3 arguments *fileName*, *sheetName* and *formatLocale* and returns a promise that resolves to the JSON representation of the test script on that sheet. Example:

```
  xlsx = require('testx-xlsx-parser')
  xlsx.parse('xls-files/test.xlsx', 'Sheet1', 'NL')
```

The format locale can be a two letter string or an array of regex replacements that are applied to the format string of each cell, for example:

```
  xlsx.parse('xls-files/test.xlsx', 'Sheet1', [{from: /JJ/g, to: 'YY'}, {from: /jj/g, to: 'yy'}])
```
