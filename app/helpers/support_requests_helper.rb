module SupportRequestsHelper
  def expense_category_select_options
    LockboxTransaction::EXPENSE_CATEGORIES.map { |c| [c.capitalize, c] }
  end

  def active_lockbox_partner_select_options
    LockboxPartner.active.order(:name).pluck(:name, :id)
  end
end
