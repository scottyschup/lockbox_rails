document.addEventListener('turbolinks:load', () => {
  const popup = $('#lockbox_partner_balance_popup_text');
  popup.hide();

  const button = $('#lockbox_partner_balance_button')
  button.on('click', event => {
    popup.show();
    // popup.popover({
    //   container: 'body',
    //   trigger: 'focus'
    // })

    const popper = new Popper(button, popup,{
      placement: 'left'
    });
  });
});
