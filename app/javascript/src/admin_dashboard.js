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
  } else {
    console.log(data)
  }
}

const setupAdminDashboard = () => {
  const users = $('.admin-dashboard-users')
  if (users) {
    console.log('setting up user form handler')
    $('#new-user-form').off('ajax:success', handleUserResponse)
    $('#new-user-form').on('ajax:success', handleUserResponse)
  }
}

document.addEventListener('turbolinks:load', () => {
  setupAdminDashboard()
});