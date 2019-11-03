const handleSupportRequestRow = event => {
  const row = event.target.closest('tr');
  const url = $(row).data('support-request-url');
  location.href = url;
};

const setupSupportRequestRow = () => {
  const handler = handleSupportRequestRow;
  $('#supportRequestsTable').off('click', 'tbody tr', handler);
  $('#supportRequestsTable').on('click', 'tbody tr', handler);
};

document.addEventListener('turbolinks:load', () => {
  let table = $('#supportRequestsTable');
  if (table === null) {
    return false;
  }
  $('#supportRequestsTable').dataTable({
    paging: false,
    searching: false,
    info: false
  });
  setupSupportRequestRow();
});
