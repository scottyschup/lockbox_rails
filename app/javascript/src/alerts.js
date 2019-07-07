const fadeAlert = () => {
  $().alert('close');
};

const handleAlert = response => {
  const data = response.detail[0];
  if (data.error) {
    document.getElementById('errors').innerHTML = data.error;
    $('.alert').alert();
    console.log('alert has been set');
  }
};

const setupAlerts = () => {
  window.setTimeout(fadeAlert, 3000);
  document.removeEventListener('ajax:success', handleAlert);
  document.addEventListener('ajax:success', handleAlert);
};

document.addEventListener('DOMContentLoaded', () => {
  setupAlerts();
});
