const handleNoteResponse = response => {
  const data = response.detail[0];
  if (data.note) {
    $('tbody').prepend(data.note);
    $('#new-note-form').slideUp(250);
    $('#new-note-form textarea').val('');
    $('#new-note')
      .parent()
      .removeClass('selected');
  }
};

const setupNotes = () => {
  const notesLog = $('.notes-log');
  if (notesLog) {
    const newNoteButton = $('#new-note');
    newNoteButton.on('click', event => {
      event.preventDefault();
      $('#new-note-form').slideDown(250);
      newNoteButton.parent().addClass('selected');
    });
    document.removeEventListener('ajax:success', handleNoteResponse);
    document.addEventListener('ajax:success', handleNoteResponse);
  }
};

document.addEventListener('turbolinks:load', () => {
  setupNotes();
});
