mac_user = User.where(email: 'cats@test.com').first_or_create(
  password: 'password1234',
  confirmed_at: Time.current
)

LOCKBOX_PARTNERS = [
  ['Cats Clinic', 'fluffy@catsclinic.com'],
  ['Owl Health Associates', 'swoop@owls.com'],
  ['Healthy Sloths', 'yawny@sloths.com'],
  ['Dogs Clinic', 'floof@dogs.com'],
]

LOCKBOX_PARTNERS.map do |partner_name, partner_user_email|
  lockbox_partner = LockboxPartner.where(name: partner_name).first_or_create(
    address: Faker::Address.full_address,
    phone_number: Faker::PhoneNumber.phone_number
  )

  User.where(email: partner_user_email).first_or_create(
    lockbox_partner: lockbox_partner,
    password: 'heytherefancypants4321',
    confirmed_at: Time.current
  )

  support_request = SupportRequest.create(
    client_ref_id: Faker::Alphanumeric.alpha(10),
    name_or_alias: [Faker::Name.first_name, Faker::Name.initials(2)].sample,
    lockbox_partner: lockbox_partner
  ).tap do |sup_req|
    action = LockboxAction.create(
      eff_date: Date.current + (1..10).to_a.sample.days,
      action_type: 'support_client',
      lockbox_partner: lockbox_partner
    )

    categories = LockboxTransaction::EXPENSE_CATEGORIES.sample((1..3).to_a.sample)
    categories.each do |category|
      action.lockbox_transactions.create(
        eff_date: action.eff_date,
        amount_cents: (1..60).to_a.sample,
        balance_effect: 'debit'
      )
    end
  end
end

