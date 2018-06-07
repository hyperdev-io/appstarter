### @testx/eval
This package exports a simple function, that allows you to *eval* code in context. The function has the signature **evalInContext(context, codeToExecute)**.

#### Example

```javascript
  const assert = require("assert");
  const evalInCtx = require("@testx/eval");
  const context = { some: "value" };
  const result = evalInCtx(context, "some");
  assert.equal(result, "value");
```
