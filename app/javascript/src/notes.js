const addNewNote = note => {
  $('tbody').prepend(note);
};

const openNoteForm = () => {
  $('#new-note-form').slideDown(250);
  $('#new-note')
    .parent()
    .addClass('selected');
  $('#new-note-form textarea').focus();
};

const clearNoteForm = () => {
  $('#new-note-form').slideUp(250);
  $('#new-note-form textarea').val('');
  $('#new-note')
    .parent()
    .removeClass('selected');
};

const handleNoteResponse = response => {
  const data = response.detail[0];
  if (data.note) {
    addNewNote(data.note);
    clearNoteForm();
  }
};

const setupNotes = () => {
  const notesLog = $('.notes-log');
  if (notesLog) {
    $('#new-note').on('click', event => {
      event.preventDefault();
      openNoteForm();
    });
    $('#cancel-note').on('click', event => {
      event.preventDefault();
      clearNoteForm();
    });
    document.removeEventListener('ajax:success', handleNoteResponse);
    document.addEventListener('ajax:success', handleNoteResponse);
  }
};

document.addEventListener('turbolinks:load', () => {
  setupNotes();
});
