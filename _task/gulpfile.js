var requireDir = require('require-dir');
var ret = requireDir('./gulp/tasks', { recurse: true });
console.log(ret)
