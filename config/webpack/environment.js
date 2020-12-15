const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

environment.plugins.append('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default'],
    iziModal: 'izimodal',
    jpostal: 'jpostal',
    Swal : 'sweetalert2',
    Calendar: 'fullcalendar'
  })
)

module.exports = environment
