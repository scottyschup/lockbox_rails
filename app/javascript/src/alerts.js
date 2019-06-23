const fadeAlert = () => {
  $().alert('close');
};

const setupAlerts = () => {
  window.setTimeout(fadeAlert, 3000);
  document.addEventListener('ajax:success', response => {
    const data = response.detail[0];
    if (data.error) {
      document.getElementById('errors').innerHTML = data.error;
      $('.alert').alert();
      console.log('alert has been set');
    }
  });
};

document.addEventListener('DOMContentLoaded', () => {
  setupAlerts();
});
