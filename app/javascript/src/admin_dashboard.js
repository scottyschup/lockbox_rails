const refreshUsers = users => {
  $('.admin-dashboard-users').replaceWith(users)
}

const clearUserForm = () => {
  const form = $('#new-user-form')[0]
  form.reset()
}

const handleUserResponse = response => {
  const data = response.detail[0]
  if (data.users) {
    refreshUsers(data.users)
    clearUserForm()
  }
}

const handleExpandUser = event => {
  button = $(event.target)
  hidden = button.parents('tr').find('p:last-child')
  hidden.slideToggle(300)
  if (button.html() == "Expand record") {
    button.html("Collapse record")
  } else {
    button.html("Expand record")
  }
}

const setupAdminDashboard = () => {
  const users = $('.admin-dashboard-users-wrapper')
  if (users) {
    $('#new-user-form').off('ajax:success', handleUserResponse)
    $('#new-user-form').on('ajax:success', handleUserResponse)
    users.off('click', '.expand', handleExpandUser)
    users.on('click', '.expand', handleExpandUser)
  }
}

document.addEventListener('turbolinks:load', () => {
  setupAdminDashboard()
});