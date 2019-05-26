// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require('@rails/ujs').start();
require('turbolinks').start();
require('@rails/activestorage').start();
require('channels');
require('uswds');

const fadeAlert = () => {
  const alert = document.getElementsByClassName('fade')[0];
  alert.style.maxHeight = '0';
  alert.style.padding = '0';
};

document.addEventListener('DOMContentLoaded', () => {
  window.setTimeout(fadeAlert, 3000);
});
