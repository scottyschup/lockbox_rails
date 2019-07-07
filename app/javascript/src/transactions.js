const addTransaction = transactions => {
  const div = document.createElement('div');
  div.innerHTML = document
    .getElementById('transaction_template')
    .innerHTML.trim();
  transactions.querySelector('.entries').appendChild(div.firstChild);
};

const _updateTotal = transactions => {
  return function() {
    let total = 0;
    const entries = transactions.querySelector('.entries').children;
    for (var i = 0; i < entries.length; i++) {
      const value = parseFloat(
        entries[i].querySelector('input[type=number]').value
      );
      if (!isNaN(value)) {
        total += value;
      }
    }
    document.querySelector('#total').innerHTML = `Total: \$${(
      Math.round(total * 100) / 100
    ).toFixed(2)}`;
  };
};

const setupTotal = () => {
  let transactions = document.getElementsByClassName(
    'support_case_transactions'
  );
  if (transactions.length === 0) {
    return false;
  }
  transactions[0]
    .querySelector('#add_transaction')
    .addEventListener('click', event => {
      event.preventDefault();
      addTransaction(transactions[0]);
    });
  const updateTotal = _updateTotal(transactions[0]);
  transactions[0].addEventListener('keyup', updateTotal);
  transactions[0].addEventListener('change', updateTotal);
  transactions[0].addEventListener('paste', updateTotal);
};

document.addEventListener('turbolinks:load', () => {
  setupTotal();
});
