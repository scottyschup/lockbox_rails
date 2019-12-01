require 'verbalize'

class UpdateSupportRequest
  include Verbalize::Action

  # This is what params input looks like
  #
  # {
  #   support_request: {
  #     lockbox_action_attributes: {
  #       eff_date: "2019-09-04",
  #       id: "6",
  #       lockbox_transactions_attributes: {
  #         "0": {
  #           amount: "33.16",
  #           category: "",
  #           _destroy: "false",
  #           id: "7"
  #         },
  #         1: {
  #           ...
  #         },
  #       }
  #     },
  #     name_or_alias: "Foster",
  #     client_ref_id: "qwertyuiopp",
  #     urgency_flag: "one"
  #   },
  #   lockbox_partner_id: "3",
  #   id: "3"
  # }
  #
  # We'll pass it directly to SupportRequest to take advantage of AcceptsNestedAttributes.
  input :params

  attr_accessor :support_request, :original_values

  def call
    find_support_request

    cache_original_values

    if support_request.update(params[:support_request])
      notate_changes
    else
      fail!(support_request.errors.full_messages.join(". "))
    end

    support_request
  end

  private

  def cache_original_values
    self.original_values ||= {}
    original_values[:client_ref_id] = support_request.client_ref_id
    original_values[:name_or_alias] = support_request.name_or_alias
    original_values[:urgency_flag]  = support_request.urgency_flag
    original_values[:eff_date]      = support_request.eff_date
    original_values[:amount]        = support_request.amount
  end

  def notate_changes
    note_text = []

    timestamp = Time.now.strftime("%Y-%m-%d at %-I:%M%P")

    original_values.each do |field, original_value|
      new_value = support_request.send(field)
      if new_value != original_value
        note_text << "The #{field_labels[field]} for this Support Request was changed on #{timestamp} from #{original_value} to #{new_value}"
      end
    end

    support_request.notes.create(text: note_text.join("\n"))
  end

  def field_labels
    HashWithIndifferentAccess.new(
      amount: "Total Amount",
      client_ref_id: "Client Reference ID",
      eff_date: "Pickup Date",
      name_or_alias: "Client Alias",
      urgency_flag: "Urgency Flag",
    )
  end

  def find_support_request
    self.support_request = SupportRequest.find(params[:id])
  end

end
