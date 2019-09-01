document.addEventListener('turbolinks:load', () => {
  $(".url-switcher").on('change', function(){
    window.location = this.value;
  });
});
