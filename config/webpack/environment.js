const { environment } = require('@rails/webpacker')

// ADD START
const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery'
  })
)
// ADD END

module.exports = environment
