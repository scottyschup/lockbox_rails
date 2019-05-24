FactoryBot.define do
  factory :lockbox_action do
    eff_date        { Date.current }
    status          { 'pending' }
    lockbox_partner

    trait :active_lockbox_partner do
      association :lockbox_partner, :active
    end

    trait :add_cash do
      action_type   { 'add_cash' }
    end

    trait :reconciliation do
      active_lockbox_partner
      action_type   { 'reconcile' }
    end

    trait :support_client do
      active_lockbox_partner
      action_type   { 'support_client' }
      association :support_request
    end

    trait :completed do
      status        { 'completed' }
    end

    trait :canceled do
      status        { 'canceled' }
    end
  end
end
