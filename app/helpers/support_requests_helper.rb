module SupportRequestsHelper
  def expense_category_select_options
    LockboxTransaction::EXPENSE_CATEGORIES.map { |c| [c.capitalize, c] }
  end

  def lockbox_partner_select_options
    LockboxPartner.order(:name).pluck(:name, :id)
  end

  def active_lockbox_partner_select_options
    LockboxPartner.active.order(:name).pluck(:name, :id)
  end

  def submit_url(lockbox_partner)
    return support_requests_path if lockbox_partner.nil?
    lockbox_partner_support_requests_path(lockbox_partner)
  end
end
