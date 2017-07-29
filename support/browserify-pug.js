process.env['NODE_ENV'] = 'production';

var fs                  = require('fs');
var browserify          = require('browserify');

var ENGINE_DIR          = process.argv[2];
var ENGINE_VERSION      = process.argv[3];
var OUTPUT_FILE         = process.argv[4];

var ENGINE_INDEX        = fs.existsSync(ENGINE_DIR + '/packages/pug/lib/index.js') ?
                          ENGINE_DIR + '/packages/pug/lib/index.js' :
                          ENGINE_DIR + '/lib/index.js';

browserify({entries: [ENGINE_INDEX], standalone: 'pug'})
  .transform('babelify', {
    global:  true,
    only:    /\/node_modules\/pug-/,
    presets: ['es2015'],
    plugins: ['transform-es2015-block-scoping']
  })
  .transform('envify')
  .bundle()
  .pipe(fs.createWriteStream(OUTPUT_FILE));
