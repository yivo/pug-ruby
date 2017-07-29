process.env['NODE_ENV'] = 'production';

var fs                  = require('fs');
var uglifyJS            = require('uglify-js');

var INPUT_FILE          = process.argv[2];
var OUTPUT_FILE         = INPUT_FILE;

var code = fs.readFileSync(INPUT_FILE, 'UTF-8');

fs.writeFileSync(OUTPUT_FILE, uglifyJS.minify(code, {compress: true, mangle: true}).code);
