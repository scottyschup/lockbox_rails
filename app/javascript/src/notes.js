const addNewNote = note => {
  $('tbody').prepend(note);
  highlightTopNote();
};

const openNoteForm = () => {
  $('#new-note-form').slideDown(250);
  $('#new-note')
    .parent()
    .addClass('selected');
  $('#new-note-form textarea').focus();
};

const displayNoteSuccess = text => {
  $('#note-success #note-text').text(text);
  $('#note-success').slideDown(250);
};

const hideNoteSuccess = () => {
  $('#note-success').slideUp(250);
  clearHighlights();
};

const clearHighlights = () => {
  $('.notes-log tbody tr').removeClass('green');
};

const highlightTopNote = () => {
  clearHighlights();
  $('.notes-log tbody tr')
    .first()
    .addClass('green');
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
    displayNoteSuccess(data.text);
  }
};

const setupNotes = () => {
  const notesLog = $('.notes-log');
  if (notesLog) {
    $('#new-note').on('click', event => {
      event.preventDefault();
      openNoteForm();
      hideNoteSuccess();
    });
    $('#cancel-note').on('click', event => {
      event.preventDefault();
      clearNoteForm();
      hideNoteSuccess();
    });
    document.removeEventListener('ajax:success', handleNoteResponse);
    document.addEventListener('ajax:success', handleNoteResponse);
  }
};

document.addEventListener('turbolinks:load', () => {
  setupNotes();
});
