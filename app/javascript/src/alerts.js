const fadeAlert = () => {
  const alerts = Array.from(document.getElementsByClassName('fade'));
  alerts.forEach(alert => (alert.style.maxHeight = '0'));
};

const setupAlerts = () => {
  window.setTimeout(fadeAlert, 3000);
  document.addEventListener('ajax:success', response => {
    document.getElementById('errors').innerHTML = response.detail[0];
  });
};

document.addEventListener('DOMContentLoaded', () => {
  setupAlerts();
});
