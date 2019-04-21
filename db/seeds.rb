User.where(email: 'cats@test.com').first_or_create(
  password: 'password1234',
  confirmed_at: Time.current
)
