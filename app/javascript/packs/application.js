// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require('@rails/ujs').start();
require('turbolinks').start();
require('@rails/activestorage').start();
require('babel-polyfill');
require('channels');
require('cocoon-js');
require('jquery')
require('bootstrap/dist/js/bootstrap')
window.$ = $
require('imports-loader?define=>false!datatables.net')(window, $)
require('imports-loader?define=>false!datatables.net-bs4')(window, $)

require('../src/alerts');
require('../src/notes');
require('../src/pending_support_requests_table');
require('../src/transactions');
require('../src/url_switching_select');
