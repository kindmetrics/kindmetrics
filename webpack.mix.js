/*
 | Mix Asset Management
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your application.
 |
 | Docs: https://github.com/JeffreyWay/laravel-mix/tree/master/docs#readme
 */
 const tailwindcss = require('tailwindcss')
 const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
 const DefinePlugin = require('webpack').DefinePlugin;

let mix = require("laravel-mix");

let plugins = [
  new DefinePlugin({
    "KINDURL": JSON.stringify(process.env.NODE_ENV == 'production' ? '//app.kindmetrics.io' : '//localhost:5000')
  })
];

// Customize the notifier to be less noisy
let WebpackNotifierPlugin = require('webpack-notifier');
let webpackNotifier = new WebpackNotifierPlugin({
  alwaysNotify: false,
  skipFirstNotification: true
})
plugins.push(webpackNotifier)

// Compress static assets in production
if (mix.inProduction()) {
  let CompressionWepackPlugin = require('compression-webpack-plugin');
  let gzipCompression = new CompressionWepackPlugin({
    compressionOptions: { level: 9 },
    test: /\.js$|\.css$|\.html$|\.svg$/
  })
  plugins.push(gzipCompression)

  // Add additional compression plugins here.
  // For example if you want to add Brotli compression:
  //
  // let brotliCompression = new CompressionWepackPlugin({
  //   compressionOptions: { level: 11 },
  //   filename: '[path].br[query]',
  //   algorithm: 'brotliCompress',
  //   test: /\.js$|\.css$|\.html$|\.svg$/
  // })
  // plugins.push(brotliCompression)
}

mix
  // JS entry file. Supports Vue, and uses Babel
  //
  // More info and options (like React support) here:
  // https://github.com/JeffreyWay/laravel-mix/blob/master/docs/mixjs.md
  .js("src/js/app.js", "public/js")
  //track javascript
  .js("src/js/track.js", "public/js")
  // SASS entry file. Uses autoprefixer automatically.
  .sass("src/css/app.scss", "public/css")
  // Customize postCSS:
  // https://github.com/JeffreyWay/laravel-mix/blob/master/docs/css-preprocessors.md#postcss-plugins
  .options({
    // If you want to process images, change this to true and add options from
    // https://github.com/tcoopman/image-webpack-loader
    imgLoaderOptions: { enabled: false },
    // Stops Mix from clearing the console when compilation succeeds
    clearConsole: false,
    postCss: [
      tailwindcss('./tailwind.config.js'),
    ]
  })
  // Set public path so manifest gets output here
  .setPublicPath("public")
  // Add assets to the manifest
  .version(["public/assets"])
  // Reduce noise in Webpack output
  .webpackConfig({
    stats: "errors-only",
    plugins: plugins,
    watchOptions: {
      ignored: /node_modules/
    },
    optimization: {
      minimize: true,
      minimizer: [
        new UglifyJsPlugin({ cache: true, parallel: true, sourceMap: false })
      ]
    }
  })
  // Disable default Mix notifications because we're using our own notifier
  .disableNotifications()

// Full API
// Docs: https://github.com/JeffreyWay/laravel-mix/tree/master/docs#readme
//
// mix.js(src, output);
// mix.react(src, output); <-- Identical to mix.js(), but registers React Babel compilation.
// mix.preact(src, output); <-- Identical to mix.js(), but registers Preact compilation.
// mix.coffee(src, output); <-- Identical to mix.js(), but registers CoffeeScript compilation.
// mix.ts(src, output); <-- TypeScript support. Requires tsconfig.json to exist in the same folder as webpack.mix.js
// mix.extract(vendorLibs);
// mix.sass(src, output);
// mix.less(src, output);
// mix.stylus(src, output);
// mix.postCss(src, output, [require('postcss-some-plugin')()]);
// mix.browserSync('my-site.test');
// mix.combine(files, destination);
// mix.babel(files, destination); <-- Identical to mix.combine(), but also includes Babel compilation.
// mix.copy(from, to);
// mix.copyDirectory(fromDir, toDir);
// mix.minify(file);
// mix.sourceMaps(); // Enable sourcemaps
// mix.version(); // Enable versioning.
// mix.disableNotifications();
// mix.disableSuccessNotifications();
// mix.setPublicPath('path/to/public');
// mix.setResourceRoot('prefix/for/resource/locators');
// mix.autoload({}); <-- Will be passed to Webpack's ProvidePlugin.
// mix.webpackConfig({}); <-- Override webpack.config.js, without editing the file directly.
// mix.babelConfig({}); <-- Merge extra Babel configuration (plugins, etc.) with Mix's default.
// mix.then(function () {}) <-- Will be triggered each time Webpack finishes building.
// mix.dump(); <-- Dump the generated webpack config object to the console.
// mix.extend(name, handler) <-- Extend Mix's API with your own components.
// mix.options({
//   extractVueStyles: false, // Extract .vue component styling to file, rather than inline.
//   globalVueStyles: file, // Variables file to be imported in every component.
//   processCssUrls: true, // Process/optimize relative stylesheet url()'s. Set to false, if you don't want them touched.
//   purifyCss: false, // Remove unused CSS selectors.
//   terser: {}, // Terser-specific options. https://github.com/webpack-contrib/terser-webpack-plugin#options
//   postCss: [] // Post-CSS options: https://github.com/postcss/postcss/blob/master/docs/plugins.md
// });
