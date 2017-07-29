process.env['NODE_ENV'] = 'production';

var fs                  = require('fs');
var browserify          = require('browserify');

var ENGINE_DIR          = process.argv[2];
var ENGINE_VERSION      = process.argv[3];
var OUTPUT_FILE         = process.argv[4];

browserify({entries: [ENGINE_DIR + '/lib/index.js'], standalone: 'jade'})
  .transform('babelify', {
    presets: ['es2015'],
    plugins: ['transform-es2015-block-scoping']
  })
  .transform('envify')
  .bundle()
  .pipe(fs.createWriteStream(OUTPUT_FILE));
