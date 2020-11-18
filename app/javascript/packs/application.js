// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")
import 'bootstrap'
import '../stylesheets/application.scss'
import '@fortawesome/fontawesome-free/js/all';

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// ADD
require("jquery");
require("admin-lte");
require("izimodal");
require("jquery-jpostal-ja");
require("sweetalert2");

window.$ = jQuery;
window.jQuery = jQuery;
window.$.fn.iziModal = iziModal;
window.Swal = Swal;

const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

$(function() {
  $('.clear').on('click', function() {
    var target_id = $(this).data('target_id');
    $('#'+target_id).val('');
  });
});
