const updateTotal = () => {
  let total = 0;
  const transactions = $('#lockbox_transactions input[type=number]:visible');
  const entries = transactions.map((i, t) => $(t).val());
  for (var i = 0; i < entries.length; i++) {
    const value = parseFloat(entries[i]);
    if (!isNaN(value)) {
      total += value;
    }
  }
  $('#total').text(`Total: \$${(Math.round(total * 100) / 100).toFixed(2)}`);
};

const setupTotal = () => {
  let transactions = $('#lockbox_transactions');
  if (transactions === null) {
    return false;
  }
  transactions.on('keyup', updateTotal);
  transactions.on('change', updateTotal);
  transactions.on('paste', updateTotal);
  transactions.on('cocoon:after-remove', updateTotal);
  updateTotal();
};

document.addEventListener('turbolinks:load', () => {
  setupTotal();
});
