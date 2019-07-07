require 'rails_helper'
require './lib/create_support_request'

describe CreateSupportRequest do
  let(:mac_user) { FactoryBot.create(:user) }
  let(:lockbox_partner) do
    FactoryBot.create(:lockbox_partner, :active)
  end

  let(:params) do
    {
      client_ref_id:      "1234",
      name_or_alias:      "some name",
      urgency_flag:       "urgent",
      lockbox_partner_id: lockbox_partner.id,
      lockbox_action: {
        eff_date:         Date.current,
        lockbox_transactions: [
          {
            amount:       42.42,
            category:     "gas"
          }
        ]
      },
      user_id:            mac_user.id,
    }
  end

  it 'works' do
    result = CreateSupportRequest.call(params: params)
    expect(result).to be_success
    expect(result.value).to be_an_instance_of(SupportRequest)
  end
end
