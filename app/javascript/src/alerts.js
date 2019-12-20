const handleAlert = response => {
  const data = response.detail[0];
  if (data.error) {
    document.getElementById('errors').innerHTML = data.error;
    $('.alert').alert();
    console.log('alert has been set');
    $('html, body').animate({ scrollTop: 0 }, 500);
  }
};

const setupAlerts = () => {
  document.removeEventListener('ajax:success', handleAlert);
  document.addEventListener('ajax:success', handleAlert);
};

document.addEventListener('turbolinks:load', () => {
  $('.alert').alert();
  setupAlerts();
});
