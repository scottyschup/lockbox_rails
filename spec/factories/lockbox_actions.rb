FactoryBot.define do
  factory :lockbox_action do
    eff_date        { Date.current }
    status          { 'pending' }
    lockbox_partner

    trait :add_cash do
      action_type   { 'add_cash' }
    end

    trait :reconciliation do
      action_type   { 'reconcile' }
    end

    trait :support_client do
      action_type   { 'support_client' }
    end

    trait :completed do
      status        { 'completed' }
    end

    trait :canceled do
      status        { 'canceled' }
    end
  end
end
