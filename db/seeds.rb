User.where(email: 'cats@test.com').first_or_create(
  password: 'password',
  confirmed_at: Time.current
)
