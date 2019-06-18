const setupNotes = () => {
  const notesLog = $('.notes-log');
  if (notesLog) {
    const newNoteButton = $('#new-note');
    newNoteButton.on('click', event => {
      event.preventDefault();
      const newNoteForm = $('#new-note-form').slideDown(250);
    });
    document.addEventListener('ajax:success', response => {
      const data = response.detail[0];
      if (data.note) {
        $('tbody').prepend(data.note);
        $('#new-note-form').slideUp(250);
        $('#new-note-form textarea').val('');
      }
    });
  }
};

document.addEventListener('turbolinks:load', () => {
  setupNotes();
});
