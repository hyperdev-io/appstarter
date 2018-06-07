module.exports = function(ctx, code) {
  with (ctx) {
    return eval(code);
  }
};
