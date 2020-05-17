document.addEventListener('turbolinks:load', () => {
  const lockbox_partner_balance_popup_text = $("#lockbox_partner_balance_popup_text");
  lockbox_partner_balance_popup_text.hide();
  console.log('boo');

  $("lockbox_partner_balance_button").on("click", event => {
    console.log(1);
    lockbox_partner_balance_popup_text.show();
  });
});
