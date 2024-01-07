const { environment } = require('@rails/webpacker')

// webpackerの設定ファイルで、jQueryを管理下に追加するための記述を追加(応用課題7d)
const webpack = require('webpack')

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    jquery: 'jquery/src/jquery',
  })
)
// ここまで

module.exports = environment
